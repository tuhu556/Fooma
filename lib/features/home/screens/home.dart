import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/data/data.dart';
import 'package:foodhub/features/home/components/recipe.dart';
import 'package:foodhub/features/home/components/recipeSuggestion.dart';
import 'package:foodhub/features/home/components/sideBar.dart';
import 'package:foodhub/features/notification/bloc/notification_bloc.dart';
import 'package:foodhub/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';
import 'package:foodhub/helper/helper.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../config/routes.dart';
import '../../../session/session.dart';
import '../../signin/provider/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTap;
  const HomeScreen({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfile()),
        ),
        BlocProvider(
            create: (_) => AllNotiBloc()..add(const AllNotification())),
      ],
      child: HomeView(
        onTap: widget.onTap,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final Function(int)? onTap;
  const HomeView({Key? key, this.onTap}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  Future<bool> _willPopCallback() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  TabController? tabController;
  UserProfileResponse userProfile = UserProfileResponse();
  String userName = '';
  String imageUserUrl =
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png';

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 10);
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cho phép nhận thông báo'),
              content: const Text(
                  'Ứng dụng của chúng tôi muốn gửi cho bạn thông báo'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Không cho phép',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Cho phép',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int page = 1;
    const int size = 30;
    const String sortOption = 'desc';
    const int role = 1;
    const String search = "";
    const String method = "";
    const String breakfast = "401fe089-1619-4dca-bd10-6d22b1a08301";
    const String lunch = "1ed5883b-d2d4-404e-aaa9-9c40cb19874b";
    const String dinner = "e8de9f5a-41e7-451b-b9ba-c80ac558428f";
    const String snacks = "197ead33-3ef9-49ae-a0d3-81f5dda32897";
    const String vietnam = "f331c21a-fcad-4aac-9206-28087b6f98fb";
    const String china = "345ff243-f479-4e9b-8344-3defaa39f7b8";
    const String thailand = "a181e9ad-3406-4495-80d2-718d3408f5bb";
    const String japan = "b0792cfe-c59c-49b2-a9a8-727e22278ee5";
    const String drink = "70dfbc3c-86d1-4d18-87c3-fe7f62199f5e";
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
      ],
      child: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
              scale: 20,
            ),
            centerTitle: true,
            actions: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.search_rounded,
                    color: FoodHubColors.color52616B,
                    size: 30,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.searchRecipe);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: [
                SizedBox(height: SizeConfig.screenHeight! * 0.02),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 15),
                  child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.redAccent, Colors.orange]),
                        borderRadius: BorderRadius.circular(50),
                        color: FoodHubColors.colorFC6011),
                    //labelColor: Colors.black,
                    unselectedLabelColor: FoodHubColors.colorFC6011,
                    isScrollable: true,
                    tabs: const [
                      Tab(
                        child: Text(
                          'Tủ lạnh của tôi',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Ăn sáng',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Ăn trưa',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Ăn tối',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Ăn vặt',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Thức uống',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Món Việt',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Món Tàu',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Món Thái',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Món Nhật',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.02,
                ),
                Container(
                  height: getProportionateScreenHeight(ResponsiveValue(
                    context,
                    defaultValue: 650.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 600.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 750.0,
                      )
                    ],
                  ).value!),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      //1
                      RecipeSuggestionScreen(
                          page: page, size: size, sortOption: sortOption),
                      //2
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: breakfast,
                        country: "",
                        method: method,
                        role: role,
                      ),
                      //3
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: lunch,
                        country: "",
                        method: method,
                        role: role,
                      ),
                      //4
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: dinner,
                        country: "",
                        method: method,
                        role: role,
                      ),
                      //5
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: snacks,
                        country: "",
                        method: method,
                        role: role,
                      ),
                      //6
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: drink,
                        country: "",
                        method: method,
                        role: role,
                      ),
                      //7
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: "",
                        country: vietnam,
                        method: method,
                        role: role,
                      ),
                      //8
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: "",
                        country: china,
                        method: method,
                        role: role,
                      ),
                      //9
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: "",
                        country: thailand,
                        method: method,
                        role: role,
                      ),
                      //10
                      Recipe(
                        page: page,
                        size: size,
                        sortOption: sortOption,
                        search: search,
                        category: "",
                        country: japan,
                        method: method,
                        role: role,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
