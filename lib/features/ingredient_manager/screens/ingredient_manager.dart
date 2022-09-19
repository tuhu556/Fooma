import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';

import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredient_category/ingredient_category_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_category_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';

import 'package:foodhub/helper/helper.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants/color.dart';
import '../../../data/data.dart';
import '../../../session/session.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';
import '../../user_profile/model/user_profile_entity.dart';

const String Freeze = "Ngăn Đông";
const String Cool = "Ngăn Mát";
const String Other = "Khác";

class FoodManagerScreen extends StatefulWidget {
  final Function(int)? onTap;
  const FoodManagerScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<FoodManagerScreen> createState() => _FoodManagerScreenState();
}

class _FoodManagerScreenState extends State<FoodManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => IngredientUserBloc()
            ..add(
              const IngredientUser("", "", "", ""),
            ),
        ),
        BlocProvider(
          create: (context) => IngredientCategoryBloc()
            ..add(
              const IngredientCateogy(),
            ),
        ),
        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfile()),
        ),
        BlocProvider(
          create: (_) => AllNotiBloc()
            ..add(
              const AllNotification(),
            ),
        ),
      ],
      child: FoodManagerView(
        onTap: widget.onTap,
      ),
    );
  }
}

class FoodManagerView extends StatefulWidget {
  final Function(int)? onTap;
  const FoodManagerView({Key? key, this.onTap}) : super(key: key);

  @override
  State<FoodManagerView> createState() => _FoodManagerViewState();
}

class _FoodManagerViewState extends State<FoodManagerView> {
  //GlobalKey<ScaffoldState> _key = GlobalKey();
  int? selectedIndex;
  int totalItem = 0;
  int totalFreeze = 0;
  int totalCool = 0;
  int totalOther = 0;
  bool _onTap = false;
  List<IngredientCategoryModel> categoryList = [];

  UserProfileResponse userProfile = UserProfileResponse();
  String userName = '';
  String imageUserUrl =
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png';

  List<IngredientUserModel> ingredientUserList = [];
  //List<IngredientCategoryModel> categoryList = [];
  //List<IngredientUserModel> gist = [];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state.status == UserProfileStatus.Processing) {
            } else if (state.status == UserProfileStatus.Failed) {
            } else if (state.status == UserProfileStatus.Ban) {
              signOutGoogle();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.signIn, (Route<dynamic> route) => false);
              ApplicationSesson.shared.clearSession();
              Helpers.shared.showDialogSuccess(context,
                  title: "Đăng xuất", message: "Phiên đăng nhập hết hạn");
            } else if (state.status == UserProfileStatus.Success) {
              setState(() {
                userProfile = state.userProfile!;
                userName = userProfile.name!;
                imageUserUrl = userProfile.imageUrl!;
                Data.avatar = imageUserUrl;
              });
            }
          },
        ),
        BlocListener<AllNotiBloc, AllNotiState>(listener: (context, state) {
          if (state.status == AllNotiStatus.AllProcessing) {
          } else if (state.status == AllNotiStatus.AllFailed) {
          } else if (state.status == AllNotiStatus.AllSuccess) {
            int count = 0;
            for (int i = 0; i < state.allNotification!.listNoti.length; i++) {
              if (state.allNotification!.listNoti[i].status == 1 &&
                  state.allNotification!.listNoti[i].isSeen == false) {
                setState(() {
                  count = count + 1;
                });
              }
            }
            widget.onTap!(count);
          }
        }),
        BlocListener<IngredientUserBloc, IngredientUserState>(
          listener: (context, state) {
            if (state.status == IngredientUserStatus.Processing) {
            } else if (state.status == IngredientUserStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi không thể load dữ liệu"),
                ),
              );
            } else if (state.status == IngredientUserStatus.Success) {
              ingredientUserList.clear();
              setState(
                () {
                  totalItem = state.ingredientUserResponse!.totalItem;
                  totalFreeze = state.ingredientUserResponse!.totalFreeze;
                  totalCool = state.ingredientUserResponse!.totalCool;
                  totalOther = state.ingredientUserResponse!.totalOutSide;
                  ingredientUserList = state.ingredientUserResponse!.items;
                },
              );
            }
          },
        ),
      ],
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Tủ lạnh",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 10,
                ),
                child: Text(
                  totalItem.toString() + " Nguyên liệu",
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          highlightColor: FoodHubColors.colorFFFFFF,
                          splashColor: FoodHubColors.colorFFFFFF,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: FoodHubColors.colorFC6011,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: FoodHubColors.colorFFFFFF,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    'Thêm nguyên liệu',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: FoodHubColors.colorFFFFFF,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            await Navigator.of(context).pushNamed(
                                Routes.addFood,
                                arguments: {'locationName': ''});
                            final bloc = context.read<IngredientUserBloc>();
                            bloc.add(const IngredientUser(
                                "desc", "", "CreateDate", ""));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    ingredientUserList.length >= 2
                        ? Row(
                            children: [
                              InkWell(
                                highlightColor: FoodHubColors.colorFFFFFF,
                                splashColor: FoodHubColors.colorFFFFFF,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 230,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: FoodHubColors.colorFC6011,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_right,
                                          color: FoodHubColors.colorFFFFFF,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          'Xem gợi ý công thức',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: FoodHubColors.colorFFFFFF,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    Routes.suggestedRecipeCaculation,
                                  );
                                },
                              ),
                            ],
                          )
                        : Row(
                            children: [Container()],
                          ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    _card(context, 'assets/images/snowy.png', Freeze,
                        totalFreeze),
                    _card(context, 'assets/images/wind.png', Cool, totalCool),
                    _card(context, 'assets/images/compass.png', Other,
                        totalOther),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorContainer() => Column(
        children: const [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text("Lỗi không thể kết nối với dữ liệu"),
          ),
        ],
      );
  Widget _buildNullList() => Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          SvgPicture.asset(
            "assets/icons/ingredients-mix-svgrepo-com.svg",
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Chưa có nguyên liệu nào hết trơn á!"),
          ),
        ],
      );
  Widget _buildLoading() => Center(
        child: CircularProgressIndicator(
          color: FoodHubColors.colorFC6011,
        ),
      );
  Widget _card(
    BuildContext context,
    String image,
    String sectionName,
    int quantity,
  ) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: Container(
          height: getProportionateScreenHeight(130),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 8),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(
                        image,
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  height: getProportionateScreenHeight(120),
                  width: getProportionateScreenWidth(120),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 35,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                sectionName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 25.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 26.0,
                                        )
                                      ],
                                    ).value,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.breakfast_dining_outlined,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  quantity.toString() + " nguyên liệu",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.ingredientSection,
            arguments: {"locationName": sectionName});
      },
    );
  }
}
