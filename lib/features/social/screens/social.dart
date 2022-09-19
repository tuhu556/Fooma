import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/social/bloc/all_post_bloc.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/widgets/build_post_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/routes.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../../widgets/build_recipe_screen.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../../user_profile/bloc/user_profile_bloc.dart';
import '../bloc/all_recipe_bloc.dart';

class SocialScreen extends StatefulWidget {
  final Function(int)? onTap;
  const SocialScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileBloc()..add(const UserProfile()),
        ),
        BlocProvider(
          create: (_) => AllPostBloc()..add(const AllPost(1)),
        ),
        BlocProvider(
          create: (_) => AllRecipeBloc()..add(const AllRecipe(1)),
        ),
        BlocProvider(
            create: (_) => AllNotiBloc()..add(const AllNotification())),
      ],
      child: SocialView(
        onTap: widget.onTap,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SocialView extends StatefulWidget {
  final Function(int)? onTap;
  const SocialView({Key? key, this.onTap}) : super(key: key);

  @override
  State<SocialView> createState() => _SocialViewState();
}

class _SocialViewState extends State<SocialView>
    with AutomaticKeepAliveClientMixin {
  String? validationContent;
  int tab = 0;

  String titleOfReport = '';
  List<String?> report = [
    'Ảnh không phù hợp',
    'Ngôn từ đả kích/gây thù ghét',
    'Spam',
    'Nội dung sai sự thật',
    'Khác'
  ];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKey = GlobalKey();

  final RefreshController _refreshControllerRecipe =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeyRecipe = GlobalKey();

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    super.initState();
  }

  int pagePost = 1;
  List<MyPost> allPost = [];
  bool enablePullUpPost = true;

  int pageRecipe = 1;
  List<Recipe> allRecipe = [];
  bool enablePullUpRecipe = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
          } else if (state.status == UserProfileStatus.Success) {}
        }),
        BlocListener<AllPostBloc, AllPostState>(
          listener: (context, state) {
            if (state.status == AllPostStatus.Processing) {
            } else if (state.status == AllPostStatus.Failed) {
            } else if (state.status == AllPostStatus.Success) {
              for (int i = 0; i < state.allPost!.myPost.length; i++) {
                if (state.allPost!.myPost[i].status == 1) {
                  setState(() {
                    allPost.add(state.allPost!.myPost[i]);
                  });
                }
              }
              if (pagePost >= state.allPost!.totalPage) {
                setState(() {
                  enablePullUpPost = false;
                });
              }
            }
          },
        ),
        BlocListener<AllRecipeBloc, AllRecipeState>(
          listener: (context, state) {
            if (state.status == AllRecipeStatus.Processing) {
            } else if (state.status == AllRecipeStatus.Failed) {
            } else if (state.status == AllRecipeStatus.Success) {
              for (int i = 0; i < state.allRecipe!.recipe.length; i++) {
                if (state.allRecipe!.recipe[i].status == 1) {
                  setState(() {
                    allRecipe.add(state.allRecipe!.recipe[i]);
                  });
                }
              }
              if (pageRecipe >= state.allRecipe!.totalPage) {
                setState(() {
                  enablePullUpRecipe = false;
                });
              }
            }
          },
        ),
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          AppBar(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: FoodHubColors.color52616B,
                                    size: 30,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.searchPost);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Material(
                      color: FoodHubColors.colorF0F5F9,
                      child: TabBar(
                        labelColor: FoodHubColors.colorFC6011,
                        unselectedLabelColor: FoodHubColors.color0B0C0C,
                        indicatorWeight: 2,
                        indicatorColor: FoodHubColors.colorFC6011,
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        onTap: (int index) {
                          setState(() {
                            tab = index;
                          });
                        },
                        tabs: const [
                          Tab(
                            text: "Bài viết",
                          ),
                          Tab(
                            text: "Công thức",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SmartRefresher(
                            key: _refresherKey,
                            controller: _refreshController,
                            enablePullUp: enablePullUpPost,
                            physics: const BouncingScrollPhysics(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              completeDuration: Duration(milliseconds: 500),
                            ),
                            onLoading: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pagePost++;
                              });
                              final bloc = context.read<AllPostBloc>();
                              bloc.add(AllPost(pagePost));
                              _refreshController.loadComplete();
                            },
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              setState(() {
                                allPost.clear();
                                enablePullUpPost = true;
                                pagePost = 1;
                              });
                              final bloc = context.read<AllPostBloc>();
                              bloc.add(AllPost(pagePost));
                              _refreshController.refreshCompleted();
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: allPost.length,
                                    itemBuilder: (context, index) {
                                      return BuildPostScreen(
                                        posts: allPost[index],
                                        index: index,
                                        onTap: (int value) {
                                          setState(() {
                                            allPost.removeAt(index);
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SmartRefresher(
                            key: _refresherKeyRecipe,
                            controller: _refreshControllerRecipe,
                            enablePullUp: enablePullUpRecipe,
                            physics: const BouncingScrollPhysics(),
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                              completeDuration: Duration(milliseconds: 500),
                            ),
                            onLoading: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              setState(() {
                                pageRecipe++;
                              });
                              final bloc = context.read<AllRecipeBloc>();
                              bloc.add(AllRecipe(pageRecipe));
                              _refreshControllerRecipe.loadComplete();
                            },
                            onRefresh: () async {
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              setState(() {
                                allRecipe.clear();
                                enablePullUpRecipe = true;
                                pageRecipe = 1;
                              });
                              final bloc = context.read<AllRecipeBloc>();
                              bloc.add(AllRecipe(pageRecipe));
                              _refreshControllerRecipe.refreshCompleted();
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: allRecipe.length,
                                    itemBuilder: (context, index) {
                                      return BuildRecipeScreen(
                                        recipe: allRecipe[index],
                                        index: index,
                                        onTap: (int value) {
                                          setState(() {
                                            allRecipe.removeAt(index);
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
            icon: Icons.add,
            // childPadding: EdgeInsets.symmetric(vertical: 50),
            childMargin: const EdgeInsets.symmetric(vertical: 10),
            activeIcon: Icons.close,
            spacing: 10,
            backgroundColor: FoodHubColors.colorFC6011,
            children: [
              SpeedDialChild(
                backgroundColor: FoodHubColors.colorFC6011,
                labelBackgroundColor: FoodHubColors.colorFC6011,
                child: Icon(
                  Icons.post_add,
                  size: 30,
                  color: FoodHubColors.colorFFFFFF,
                ),
                labelWidget: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: FoodHubColors.colorFC6011,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        "Thêm công thức",
                        style: TextStyle(
                          color: FoodHubColors.colorFFFFFF,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                label: "Thêm công thức",
                labelStyle: TextStyle(
                  color: FoodHubColors.colorFFFFFF,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.uploadRecipe);
                },
              ),
              SpeedDialChild(
                labelWidget: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: FoodHubColors.colorFC6011,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        "Thêm bài viết",
                        style: TextStyle(
                          color: FoodHubColors.colorFFFFFF,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                backgroundColor: FoodHubColors.colorFC6011,
                labelBackgroundColor: FoodHubColors.colorFC6011,
                child: Icon(
                  Icons.note_add,
                  size: 30,
                  color: FoodHubColors.colorFFFFFF,
                ),
                label: "Thêm bài viết",
                labelStyle: TextStyle(
                  color: FoodHubColors.colorFFFFFF,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.uploadPost);
                },
              ),
            ]),
      ),
    );
  }

  Padding postMethod(
      BuildContext context, String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: FoodHubColors.colorFFFFFF,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(
                0,
                3,
              ), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 50,
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.mainTab, arguments: 4),
                icon: const CircleAvatar(
                  radius: 80.0,
                  backgroundImage:
                      NetworkImage('https://placeimg.com/640/480/animals'),
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  onPressed: () {
                    tab == 0
                        ? Navigator.pushNamed(context, Routes.uploadPost)
                        : Navigator.pushNamed(context, Routes.uploadRecipe);
                  },
                ),
              ),
              IconButton(
                splashRadius: 30,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: FoodHubColors.colorFC6011,
                ),
                onPressed: () {
                  tab == 0
                      ? Navigator.pushNamed(context, Routes.uploadPost)
                      : Navigator.pushNamed(context, Routes.uploadRecipe);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
