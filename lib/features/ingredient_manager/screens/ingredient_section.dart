import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';

import "package:collection/collection.dart";
import 'package:foodhub/features/ingredient_manager/bloc/delete_ingredient/delete_ingredient_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredient_category/ingredient_category_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/update_ingredient/update_ingredient_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_category_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';

import 'package:foodhub/helper/helper.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants/color.dart';
import '../../../data/data.dart';
import '../../../session/session.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';
import '../../user_profile/model/user_profile_entity.dart';

class IngredientSectionScreen extends StatefulWidget {
  const IngredientSectionScreen({Key? key}) : super(key: key);

  @override
  State<IngredientSectionScreen> createState() =>
      _IngredientSectionScreenState();
}

class _IngredientSectionScreenState extends State<IngredientSectionScreen> {
  @override
  Widget build(BuildContext context) {
    String locationName = "";
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    locationName = args['locationName'];
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => IngredientUserBloc()
              ..add(
                IngredientUser("desc", "", "CreateDate", locationName),
              ),
          ),
          BlocProvider(
            create: (context) => IngredientCategoryBloc()
              ..add(
                const IngredientCateogy(),
              ),
          ),
          BlocProvider(
            create: (context) => DeleteIngredientBloc(),
          ),
          BlocProvider(
            create: (context) => UpdateIngredientBloc(),
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
        child: IngredientSectionView(
          locationName: locationName,
        ));
  }
}

class IngredientSectionView extends StatefulWidget {
  final String locationName;
  const IngredientSectionView({Key? key, required this.locationName})
      : super(key: key);

  @override
  State<IngredientSectionView> createState() => _IngredientSectionViewState();
}

class _IngredientSectionViewState extends State<IngredientSectionView> {
  int? selectedIndex;
  int totalItem = 0;
  int simpleIntInput = 0;
  bool _onTap = false;
  List<IngredientCategoryModel> categoryList = [];
  List<String> listFilter = [
    "Th??? t??? h???t h???n",
    "Ng??y th??m v??o m???i nh???t",
    "H???t h???n",
    "G???n h???t h???n",
    "Ch??a h???t h???n"
  ];

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
                  title: "????ng xu???t", message: "Phi??n ????ng nh???p h???t h???n");
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
        BlocListener<IngredientUserBloc, IngredientUserState>(
          listener: (context, state) {
            if (state.status == IngredientUserStatus.Processing) {
            } else if (state.status == IngredientUserStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("L???i kh??ng th??? load d??? li???u"),
                ),
              );
            } else if (state.status == IngredientUserStatus.Success) {
              ingredientUserList.clear();
              setState(
                () {
                  totalItem = state.ingredientUserResponse!.totalItem;
                  ingredientUserList = state.ingredientUserResponse!.items;
                },
              );
            }
          },
        ),
        BlocListener<DeleteIngredientBloc, DeleteIngredientState>(
          listener: (context, state) {
            if (state.status == DeleteIngredientStatus.Processing) {
            } else if (state.status == DeleteIngredientStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("L???i kh??ng th??? x??a d??? li???u"),
                ),
              );
            } else if (state.status == DeleteIngredientStatus.Success) {}
          },
        ),
        BlocListener<UpdateIngredientBloc, UpdateIngredientState>(
          listener: (context, state) {
            if (state.status == UpdateIngredientStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == UpdateIngredientStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == UpdateIngredientStatus.NothingChange) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("C???p nh???p kh??ng thay ?????i!"),
                ),
              );
              Navigator.pop(context);
            } else if (state.status == UpdateIngredientStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("C???p nh???p nguy??n li???u th??nh c??ng!"),
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            //centerTitle: true,
            title: Text(
              widget.locationName,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
            actions: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.import_export,
                    color: _onTap
                        ? FoodHubColors.colorFC6011
                        : FoodHubColors.color52616B,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _onTap = !_onTap;
                  });
                  filterScreen(context);
                },
              )
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
                                    width: 3,
                                  ),
                                  Text(
                                    'Th??m nguy??n li???u',
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
                            await Navigator.of(context)
                                .pushNamed(Routes.addFood, arguments: {
                              'locationName': widget.locationName
                            });
                            final bloc = context.read<IngredientUserBloc>();
                            bloc.add(IngredientUser(
                                "desc", "", "CreateDate", widget.locationName));
                          },
                        ),
                        Text(
                          totalItem.toString() + " Nguy??n li???u",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    BlocBuilder<IngredientUserBloc, IngredientUserState>(
                      buildWhen: ((previous, current) => true),
                      builder: ((context, state) {
                        if (state.status == IngredientUserStatus.Processing) {
                          return _buildLoading();
                        } else if (state.status ==
                            IngredientUserStatus.Failed) {
                          return _buildErrorContainer();
                        } else if (state.status ==
                            IngredientUserStatus.Success) {
                          if (ingredientUserList.isNotEmpty) {
                            final group = groupBy(ingredientUserList,
                                (IngredientUserModel model) {
                              return model.categoryName;
                            });

                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: group.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _categoryTitle(
                                          context, group.keys.elementAt(index)),
                                      ListView.builder(
                                          itemCount: ingredientUserList.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder:
                                              (BuildContext c, int index2) {
                                            if (group.keys.elementAt(index) ==
                                                ingredientUserList[index2]
                                                    .categoryName) {
                                              return _card(
                                                c,
                                                ingredientUserList[index2],
                                                index2,
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    ],
                                  );
                                });
                          } else {
                            return _buildNullList();
                          }
                        } else {
                          return Container();
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String convertDate(String date) {
    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }

  setColor(String condition) {
    if (condition == "good") {
      return Colors.green[700];
    } else if (condition == "about_to_expire") {
      return Colors.yellow[700];
    } else if (condition == "expired") {
      return Colors.red[700];
    }
  }

  int daysBetween(DateTime to) {
    DateTime from =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  int daysBetweenAdded(DateTime from) {
    from = DateTime(from.year, from.month, from.day);
    DateTime to =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return (to.difference(from).inHours / 24).round();
  }

  String remainAddedDays(int daysBetweenAdded) {
    int month;
    int year;
    int decade;
    if (daysBetweenAdded > 0 && daysBetweenAdded <= 1) {
      return "???? th??m v??o h??m qua";
    } else if (daysBetweenAdded > 1 && daysBetweenAdded < 30) {
      return "???? th??m v??o " + daysBetweenAdded.toString() + " ng??y tr?????c";
    } else if (daysBetweenAdded >= 30 && daysBetweenAdded < 365) {
      month = (daysBetweenAdded / 30).round();
      return "???? th??m v??o " + daysBetweenAdded.toString() + " th??ng tr?????c";
    } else if (daysBetweenAdded >= 365 && daysBetweenAdded < 3650) {
      year = (daysBetweenAdded / 365).round();
      return "???? th??m v??o " + daysBetweenAdded.toString() + " n??m tr?????c";
    } else if (daysBetweenAdded >= 3650) {
      decade = (daysBetweenAdded / 3650).round();
      return "???? th??m v??o " + daysBetweenAdded.toString() + " th???p k??? tr?????c";
    } else {
      return "???? th??m v??o h??m nay";
    }
  }

  String remainExpiredDays(int daysBetween) {
    int month;
    int year;
    int decade;
    if (daysBetween > 0 && daysBetween <= 1) {
      return "H???t h???n v??o ng??y mai";
    } else if (daysBetween > 1 && daysBetween < 30) {
      return "C??n " + daysBetween.toString() + " ng??y n???a h???t h???n";
    } else if (daysBetween >= 30 && daysBetween < 365) {
      month = (daysBetween / 30).round();
      return "C??n " + month.toString() + " th??ng n???a h???t h???n";
    } else if (daysBetween >= 365 && daysBetween < 3650) {
      year = (daysBetween / 365).round();
      return "C??n " + year.toString() + " n??m n???a h???t h???n";
    } else if (daysBetween >= 3650) {
      decade = (daysBetween / 3650).round();
      return "C??n " + decade.toString() + " th???p k??? n???a h???t h???n";
    } else {
      return "???? h???t h???n";
    }
  }

  Widget _buildErrorContainer() => Column(
        children: const [
          SizedBox(
            height: 100,
          ),
          Center(
            child: Text("L???i kh??ng th??? k???t n???i v???i d??? li???u"),
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
            child: Text("Ch??a c?? nguy??n li???u n??o h???t tr??n ??!"),
          ),
        ],
      );
  Widget _buildLoading() => Center(
        child: CircularProgressIndicator(
          color: FoodHubColors.colorFC6011,
        ),
      );

  Widget _categoryTitle(
    BuildContext context,
    String category,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Container(
        child: Text(
          category.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: FoodHubColors.colorFC6011,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IngredientUserModel model,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: InkWell(
        onTap: () async {
          bottomScreen(context, model, index);
          setState(() {
            model.onTap = true;
          });

          // await Navigator.pushNamed(context, Routes.editIngredient,
          //     arguments: model);
          // final bloc = context.read<IngredientUserBloc>();
          // bloc.add(IngredientUser("", "", "", widget.locationName));
        },
        child: Container(
          height: getProportionateScreenHeight(150),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: model.onTap
                ? Border.all(
                    color: FoodHubColors.colorFC7F401,
                    width: 2,
                  )
                : const Border(),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: setColor(model.condition),
                ),
                width: getProportionateScreenWidth(26),
                height: getProportionateScreenWidth(150),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(model.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: getProportionateScreenHeight(110),
                  width: getProportionateScreenWidth(110),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              double.parse(model.quantity.toString()) % 1 != 0
                                  ? model.quantity.toString() +
                                      " " +
                                      model.unit.toString()
                                  : model.quantity.toInt().toString() +
                                      " " +
                                      model.unit.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(150),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                model.ingredientName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 20.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 22.0,
                                        )
                                      ],
                                    ).value,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  remainExpiredDays(daysBetween(
                                      DateTime.parse(model.expiredDate))),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Divider(
                              color: FoodHubColors.color333333,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  remainAddedDays(daysBetweenAdded(
                                      DateTime.parse(model.createDate))),
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void filterScreen(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: FoodHubColors.colorF0F5F9,
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context2) {
        return BlocProvider.value(
          value: BlocProvider.of<IngredientUserBloc>(context),
          child: StatefulBuilder(builder: (context, setState) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.03,
                    ),
                    Text(
                      "S???p x???p theo",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: FoodHubColors.color0B0C0C,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.04,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listFilter.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: selectedIndex == index
                              ? Text(
                                  listFilter[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              : Text(
                                  listFilter[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                          tileColor: selectedIndex == index
                              ? FoodHubColors.colorFC6011
                              : null,
                          trailing: selectedIndex == index
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              final bloc = context.read<IngredientUserBloc>();
                              switch (selectedIndex) {
                                case 0:
                                  bloc.add(IngredientUser(
                                      "", "", "", widget.locationName));
                                  break;
                                case 1:
                                  bloc.add(IngredientUser("desc", "",
                                      "CreateDate", widget.locationName));
                                  break;
                                case 2:
                                  bloc.add(IngredientUser(
                                      "", "expired", "", widget.locationName));
                                  break;
                                case 3:
                                  bloc.add(IngredientUser("", "about_to_expire",
                                      "", widget.locationName));
                                  break;
                                case 4:
                                  bloc.add(IngredientUser(
                                      "", "good", "", widget.locationName));
                                  break;
                                default:
                              }

                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
    ).whenComplete(() {
      setState(() {
        _onTap = !_onTap;
      });
    });
  }

  Widget _buttonDefault(Color backgroundColor, Color textColor,
          Color borderColor, String text, Function() function) =>
      Container(
        width: double.infinity,
        height: getProportionateScreenHeight(50),
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
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: borderColor, width: 2)),
            primary: backgroundColor,
            backgroundColor: backgroundColor,
          ),
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
  void bottomScreen(
    context,
    IngredientUserModel model,
    int index,
  ) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (BuildContext context2) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: BlocProvider.of<IngredientUserBloc>(context),
              ),
              BlocProvider.value(
                value: BlocProvider.of<DeleteIngredientBloc>(context),
              ),
            ],
            child: StatefulBuilder(builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.70,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                          FoodHubColors.colorF1F1F1,
                          FoodHubColors.color30A197,
                          FoodHubColors.color30A197,
                          "Nh???p/ Xu???t Nguy??n li???u",
                          () => setState(
                                () {
                                  showQuantityDialog(context, model);
                                },
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                        FoodHubColors.colorF1F1F1,
                        FoodHubColors.colorFFC107,
                        FoodHubColors.colorFFC107,
                        "Ch???nh s???a Nguy??n li???u",
                        () async {
                          await Navigator.pushNamed(
                              context, Routes.editIngredient,
                              arguments: model);
                          final bloc = context.read<IngredientUserBloc>();
                          bloc.add(
                            IngredientUser(
                                "desc", "", "CreateDate", widget.locationName),
                          );
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                          FoodHubColors.colorF1F1F1,
                          FoodHubColors.colorCC0000,
                          FoodHubColors.colorCC0000,
                          "X??a Nguy??n li???u",
                          () => setState(
                                () {
                                  Helpers.shared.showDialogConfirm(
                                    context,
                                    title: "X??a",
                                    message:
                                        "B???n c?? ch???c mu???n x??a nguy??n li???u n??y?",
                                    okFunction: () {
                                      setState(() {
                                        ingredientUserList.removeAt(index);
                                        final bloc = context
                                            .read<DeleteIngredientBloc>();
                                        bloc.add(CreateDeleteIngredientEvent(
                                            id: model.id));

                                        var snackBar = SnackBar(
                                          content: Text("???? x??a nguy??n li???u " +
                                              model.ingredientName),
                                          duration: const Duration(
                                              milliseconds: 1500),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        totalItem--;
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                },
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      _buttonDefault(
                          FoodHubColors.colorE1E4E8,
                          Colors.black,
                          FoodHubColors.colorE1E4E8,
                          "????ng",
                          () => Navigator.pop(context)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }).whenComplete(() => setState(
          () {
            model.onTap = false;
            // if (isDelete) {
            //   planList.removeAt(index);
            //   isDelete = !isDelete;
            // }
          },
        ));
  }

  void showQuantityDialog(
    BuildContext context2,
    IngredientUserModel model,
  ) =>
      showDialog(
          context: context2,
          builder: (BuildContext context2) {
            double quantity = model.quantity;
            return BlocProvider.value(
              value: BlocProvider.of<UpdateIngredientBloc>(context),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: QuantityInput(
                              inputWidth: 200,
                              buttonColor: FoodHubColors.colorFC7F401,
                              type: model.quantity % 1 != 0
                                  ? QuantityInputType.double
                                  : QuantityInputType.int,
                              minValue: 1,
                              maxValue: 100,
                              value: quantity,
                              acceptsZero: false,
                              acceptsNegatives: false,
                              onChanged: (value) => setState(
                                  () => quantity = double.parse(value))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(model.unit),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _button(() {
                                Navigator.pop(context);
                              }, "H???y"),
                              const SizedBox(
                                width: 10,
                              ),
                              _button(() {
                                if (quantity > 0) {
                                  model.quantity = quantity;
                                  final bloc =
                                      context.read<UpdateIngredientBloc>();
                                  bloc.add(CreateUpdateIngredientEvent(
                                    ingredientNotifications: [],
                                    ingredientId: model.id,
                                    categoryId: model.categoryId,
                                    ingredientName: model.ingredientName,
                                    expiredDate: model.expiredDate,
                                    quantity: quantity,
                                    desciption: "",
                                    imageUrl: model.imageUrl,
                                    unit: model.unit,
                                    locationId: model.locationId,
                                    locationName: model.locationName,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("S??? l?????ng ph???i l???n h??n 0"),
                                    ),
                                  );
                                }

                                Navigator.pop(context);
                              }, "X??c nh???n")
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          });

  Widget _button(Function press, String lableString) => SizedBox(
        width: 150,
        height: getProportionateScreenHeight(40),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            primary: Colors.white,
            backgroundColor: FoodHubColors.colorFC6011,
          ),
          onPressed: press as void Function()?,
          child: Text(
            lableString,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
