import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart';

import '../../../config/size_config.dart';
import '../../../constants/color.dart';
import '../../social/screens/view_recipe_screen.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({Key? key}) : super(key: key);

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc()
        ..add(const MyListRecipe(1, 1))
        ..add(const MyListRecipePending(1, 2))
        ..add(const MyListRecipeDenied(1, 3)),
      child: const MyRecipeView(),
    );
  }
}

class MyRecipeView extends StatefulWidget {
  const MyRecipeView({Key? key}) : super(key: key);

  @override
  State<MyRecipeView> createState() => _MyRecipeViewState();
}

class _MyRecipeViewState extends State<MyRecipeView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int tabIndex = 0;
  int totalRecipe = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKey = GlobalKey();
  int pageApproved = 1;
  bool enablePullUpApproved = true;

  final RefreshController _refreshPendingController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherPendingKey = GlobalKey();
  int pagePending = 1;
  bool enablePullUpPending = true;

  final RefreshController _refreshDeniedController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherDeniedKey = GlobalKey();
  int pageDenied = 1;
  bool enablePullUpDenied = true;

  List<Recipe> approvedRecipe = [];
  List<Recipe> pendingRecipe = [];
  List<Recipe> deniedRecipe = [];

  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;
  var difference;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state.status == UserProfileStatus.MyRecipeProcessing) {
          // Helpers.shared.showDialogProgress(context);
        } else if (state.status == UserProfileStatus.MyRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == UserProfileStatus.MyRecipeSuccess) {
          // Helpers.shared.hideDialogProgress(context);

          for (var i = 0; i < state.myRecipe!.recipe.length; i++) {
            setState(() {
              approvedRecipe.add(state.myRecipe!.recipe[i]);
            });
          }
          setState(() {
            totalRecipe = approvedRecipe.length;
          });
          if (pageApproved >= state.myRecipe!.totalPage) {
            setState(() {
              enablePullUpApproved = false;
            });
          }
        }
        //!
        if (state.status == UserProfileStatus.MyRecipePendingProcessing) {
          // Helpers.shared.showDialogProgress(context);
        } else if (state.status == UserProfileStatus.MyRecipePendingFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == UserProfileStatus.MyRecipePendingSuccess) {
          // Helpers.shared.hideDialogProgress(context);

          for (var i = 0; i < state.myRecipePending!.recipe.length; i++) {
            setState(() {
              pendingRecipe.add(state.myRecipePending!.recipe[i]);
            });
          }
          setState(() {
            totalRecipe = pendingRecipe.length;
          });
          if (pagePending >= state.myRecipePending!.totalPage) {
            setState(() {
              enablePullUpPending = false;
            });
          }
        }
        //!
        if (state.status == UserProfileStatus.MyRecipeDeniedProcessing) {
          // Helpers.shared.showDialogProgress(context);
        } else if (state.status == UserProfileStatus.MyRecipeDeniedFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == UserProfileStatus.MyRecipeDeniedSuccess) {
          // Helpers.shared.hideDialogProgress(context);

          for (var i = 0; i < state.myRecipeDenied!.recipe.length; i++) {
            setState(() {
              deniedRecipe.add(state.myRecipeDenied!.recipe[i]);
            });
          }
          setState(() {
            totalRecipe = deniedRecipe.length;
          });
          if (pageDenied >= state.myRecipeDenied!.totalPage) {
            setState(() {
              enablePullUpDenied = false;
            });
          }
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: FoodHubColors.color0B0C0C,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Công thức của tôi",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 10),
                child: Text(
                  tabIndex == 0
                      ? approvedRecipe.length.toString() + " Công thức"
                      : tabIndex == 1
                          ? pendingRecipe.length.toString() + " Công thức"
                          : deniedRecipe.length.toString() + " Công thức",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          body: DefaultTabController(
            length: 3,
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            height: 0.1,
                          )
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: FoodHubColors.colorF0F5F9,
                      child: TabBar(
                        controller: _tabController,
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: setColor(_tabController!.index),
                        ),
                        unselectedLabelColor: FoodHubColors.color0B0C0C,
                        indicatorWeight: 2,
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        onTap: (int index) {
                          setState(() {
                            tabIndex = index;
                          });
                        },
                        tabs: const [
                          Tab(
                            text: "Đã duyệt",
                          ),
                          Tab(
                            text: "Đang duyệt",
                          ),
                          Tab(
                            text: "Không duyệt",
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SmartRefresher(
                            key: _refresherKey,
                            controller: _refreshController,
                            enablePullUp: enablePullUpApproved,
                            physics: const BouncingScrollPhysics(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              completeDuration: Duration(milliseconds: 500),
                            ),
                            onLoading: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pageApproved++;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(MyListRecipe(pageApproved, 1));
                              _refreshController.loadComplete();
                            },
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                approvedRecipe.clear();
                                enablePullUpApproved = true;
                                pageApproved = 1;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(const MyListRecipe(1, 1));
                              _refreshController.refreshCompleted();
                            },
                            child: approvedRecipe.isEmpty
                                ? _buildNullList()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: approvedRecipe.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return myRecipeButton(
                                        context,
                                        const Icon(
                                          Icons.event_available_rounded,
                                          size: 22,
                                          color: Colors.black54,
                                        ),
                                        approvedRecipe[index],
                                        index,
                                      );
                                    },
                                  ),
                          ),
                          SmartRefresher(
                            key: _refresherPendingKey,
                            controller: _refreshPendingController,
                            enablePullUp: enablePullUpPending,
                            physics: const BouncingScrollPhysics(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              completeDuration: Duration(milliseconds: 500),
                            ),
                            onLoading: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pagePending++;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(MyListRecipePending(pagePending, 2));
                              _refreshPendingController.loadComplete();
                            },
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pendingRecipe.clear();
                                enablePullUpPending = true;
                                pagePending = 1;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(const MyListRecipePending(1, 2));
                              _refreshPendingController.refreshCompleted();
                            },
                            child: pendingRecipe.isEmpty
                                ? _buildNullList()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: pendingRecipe.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return myRecipeButton(
                                        context,
                                        const Icon(
                                          Icons.event_repeat,
                                          size: 22,
                                          color: Colors.black54,
                                        ),
                                        pendingRecipe[index],
                                        index,
                                      );
                                    },
                                  ),
                          ),
                          SmartRefresher(
                            key: _refresherDeniedKey,
                            controller: _refreshDeniedController,
                            enablePullUp: enablePullUpDenied,
                            physics: const BouncingScrollPhysics(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              completeDuration: Duration(milliseconds: 500),
                            ),
                            onLoading: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pageDenied++;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(MyListRecipeDenied(pageDenied, 3));
                              _refreshDeniedController.loadComplete();
                            },
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                deniedRecipe.clear();
                                enablePullUpDenied = true;
                                pageDenied = 1;
                              });
                              final bloc = context.read<UserProfileBloc>();
                              bloc.add(const MyListRecipeDenied(1, 3));
                              _refreshDeniedController.refreshCompleted();
                            },
                            child: deniedRecipe.isEmpty
                                ? _buildNullList()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: deniedRecipe.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return myRecipeButton(
                                        context,
                                        const Icon(
                                          Icons.event_busy,
                                          size: 22,
                                          color: Colors.black54,
                                        ),
                                        deniedRecipe[index],
                                        index,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setColor(int tabIndex) {
    if (tabIndex == 0) {
      return Colors.green[700];
    } else if (tabIndex == 1) {
      return Colors.yellow[700];
    } else if (tabIndex == 2) {
      return Colors.red[700];
    }
  }

  Widget _buildNullList() => Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          SvgPicture.asset(
            "assets/icons/pumpkin-coco-fall-svgrepo-com.svg",
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Chưa có bài viết nào hết trơn á!"),
          ),
        ],
      );
  Widget myRecipeButton(
      BuildContext context, Icon icon, Recipe recipe, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Container(
          height: getProportionateScreenHeight(145),
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
                padding: const EdgeInsets.only(left: 20),
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
                        image: NetworkImage(recipe.thumbnail),
                        fit: BoxFit.cover),
                  ),
                  height: getProportionateScreenHeight(110),
                  width: getProportionateScreenWidth(110),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: Text(
                                recipe.recipeName,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 18.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 20.0,
                                        )
                                      ],
                                    ).value,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          recipe.description,
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              color: FoodHubColors.color0B0C0C,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          icon,
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            dateFormat
                                .format(dateFormat.parse(recipe.createDate))
                                .toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: FoodHubColors.color0B0C0C,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        difference = timePost(recipe.createDate);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewRecipeScreen(
              recipe: recipe,
              timeAgo: difference,
              index: index,
              onTap: recipe.status == 1
                  ? (int value) {
                      // setState(() {
                      //   approvedRecipe.removeAt(index);
                      // });
                      setState(() {
                        approvedRecipe.clear();
                        enablePullUpApproved = true;
                        pageApproved = 1;
                      });
                      final bloc = context.read<UserProfileBloc>();
                      bloc.add(const MyListRecipe(1, 1));
                    }
                  : recipe.status == 2
                      ? (int value) {
                          // setState(() {
                          //   pendingRecipe.removeAt(index);
                          // });
                          setState(() {
                            pendingRecipe.clear();
                            enablePullUpPending = true;
                            pagePending = 1;
                          });
                          final bloc = context.read<UserProfileBloc>();
                          bloc.add(const MyListRecipePending(1, 2));
                        }
                      : (int value) {
                          // setState(() {
                          //   pendingRecipe.removeAt(index);
                          // });
                          setState(() {
                            deniedRecipe.clear();
                            enablePullUpDenied = true;
                            pageDenied = 1;
                          });
                          final bloc = context.read<UserProfileBloc>();
                          bloc.add(const MyListRecipeDenied(1, 3));
                        },
            ),
          ),
        );
      },
    );
  }

  String timePost(String publishedDate) {
    var parsedDate = DateTime.parse(publishedDate);
    formattedYMD = formatterYMDHMS.format(parsedDate);
    timeAgo = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(formattedYMD);

    final dayAgo = DateTime.now().difference(timeAgo!).inDays;
    final hourAgo = DateTime.now().difference(timeAgo!).inHours;
    final minuteAgo = DateTime.now().difference(timeAgo!).inMinutes;
    final secondAgo = DateTime.now().difference(timeAgo!).inSeconds;
    if (dayAgo <= 0) {
      if (hourAgo <= 0) {
        if (minuteAgo <= 0) {
          difference = secondAgo.toString() + " giây trước";
        } else {
          difference = minuteAgo.toString() + " phút trước";
        }
      } else {
        difference = hourAgo.toString() + " giờ trước";
      }
    } else {
      if (dayAgo >= 30) {
        difference = (dayAgo / 30).toInt().toString() + " tháng trước";
      } else {
        difference = dayAgo.toString() + " ngày trước";
      }
    }
    return difference;
  }
}
