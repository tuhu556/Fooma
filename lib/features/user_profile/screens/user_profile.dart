import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';
import 'package:foodhub/widgets/build_post_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/routes.dart';
import '../../../helper/helper.dart';
import '../../../session/session.dart';
import '../../../widgets/build_recipe_screen.dart';
import '../../notification/bloc/notification_bloc.dart';
import '../../signin/provider/google_sign_in.dart';
import '../widgets/profile_header_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileBloc()
            ..add(const UserProfile())
            ..add(const MyListPost(1, 1))
            ..add(const MyListRecipe(1, 1)),
        ),
      ],
      child: const UserProfileView(),
    );
  }
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with TickerProviderStateMixin {
  final TextEditingController _descriptionController =
      new TextEditingController();
  String? validationContent;
  int tab = 0;

  UserProfileResponse userProfile =
      new UserProfileResponse(totalPost: 0, totalRecipe: 0);

  List<MyPost> myPost = [];
  List<Recipe> myRecipe = [];
  List<BoxShadow> shadowList = [
    BoxShadow(
        color: Colors.grey[300]!, blurRadius: 30, offset: const Offset(0, 10))
  ];

  bool onPress = false;
  bool enablePullUpPost = true;
  bool enablePullUpRecipe = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final GlobalKey _refresherKey = GlobalKey();
  int pageApprovedPost = 1;

  int pageApprovedRecipe = 1;
  final RefreshController _refreshControllerRecipe =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeyRecipe = GlobalKey();

  late TabController tabController;

  int totalPost = 0;
  int totalRecipe = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                totalPost = state.userProfile!.totalPost!;
                totalRecipe = state.userProfile!.totalRecipe!;

                onPress = true;
              });
            }
            //!
            else if (state.status == UserProfileStatus.MyPostProcessing) {
              // Helpers.shared.showDialogProgress(context);
            } else if (state.status == UserProfileStatus.MyPostFailed) {
            } else if (state.status == UserProfileStatus.MyPostSuccess) {
              // Helpers.shared.hideDialogProgress(context);
              for (var i = 0; i < state.myPost!.myPost.length; i++) {
                setState(() {
                  myPost.add(state.myPost!.myPost[i]);
                });
              }

              if (pageApprovedPost >= state.myPost!.totalPage) {
                setState(() {
                  enablePullUpPost = false;
                });
              }
              final bloc = context.read<UserProfileBloc>();
              bloc.add(const UserProfile());
            }
            //!
            else if (state.status == UserProfileStatus.MyRecipeProcessing) {
            } else if (state.status == UserProfileStatus.MyRecipeFailed) {
            } else if (state.status == UserProfileStatus.MyRecipeSuccess) {
              for (var i = 0; i < state.myRecipe!.recipe.length; i++) {
                setState(() {
                  myRecipe.add(state.myRecipe!.recipe[i]);
                });
              }

              if (pageApprovedRecipe >= state.myRecipe!.totalPage) {
                setState(() {
                  enablePullUpRecipe = false;
                });
              }
              final bloc = context.read<UserProfileBloc>();
              bloc.add(const UserProfile());
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: FoodHubColors.colorFFFFFF,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: FoodHubColors.colorFFFFFF,
            centerTitle: true,
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
              "Hồ sơ cá nhân",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: FoodHubColors.color0B0C0C,
              ),
            ),
            actions: [
              // InkWell(
              //   child: const Padding(
              //     padding: EdgeInsets.all(15),
              //     child: Icon(
              //       Icons.settings,
              //       size: 30,
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.pushNamed(context, Routes.setting);
              //   },
              // ),
            ]),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          profileHeaderWidget(
                            context,
                            1,
                            userProfile,
                            totalPost,
                            totalRecipe,
                            onPress,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Material(
                        color: FoodHubColors.colorFFFFFF,
                        child: TabBar(
                          controller: tabController,
                          labelColor: FoodHubColors.colorFC6011,
                          unselectedLabelColor: FoodHubColors.color0B0C0C,
                          indicatorWeight: 2,
                          indicatorColor: FoodHubColors.colorFC6011,
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          tabs: const [
                            Tab(text: "Bài đăng "),
                            Tab(text: "Công thức "),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        color: FoodHubColors.colorF0F5F9,
                        child: TabBarView(
                          controller: tabController,
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
                                  pageApprovedPost++;
                                });
                                final bloc = context.read<UserProfileBloc>();
                                bloc.add(MyListPost(pageApprovedPost, 1));

                                _refreshController.loadComplete();
                              },
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  myPost.clear();
                                  pageApprovedPost = 1;
                                  enablePullUpPost = true;
                                });
                                final bloc = context.read<UserProfileBloc>();
                                bloc.add(const MyListPost(1, 1));
                                _refreshController.refreshCompleted();
                              },
                              child: myPost.isEmpty
                                  ? _buildNullList()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: myPost.length,
                                      itemBuilder: (context, index) {
                                        return BuildPostScreen(
                                          posts: myPost[index],
                                          index: index,
                                          onTap: (int value) {
                                            setState(() {
                                              myPost.removeAt(index);
                                              totalPost = totalPost - 1;
                                            });
                                          },
                                        );
                                      },
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
                                  pageApprovedRecipe++;
                                });
                                final bloc = context.read<UserProfileBloc>();
                                bloc.add(MyListRecipe(pageApprovedRecipe, 1));
                                _refreshControllerRecipe.loadComplete();
                              },
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {
                                  myRecipe.clear();
                                  pageApprovedRecipe = 1;
                                  enablePullUpRecipe = true;
                                });
                                final bloc = context.read<UserProfileBloc>();
                                bloc.add(const MyListRecipe(1, 1));
                                _refreshControllerRecipe.refreshCompleted();
                              },
                              child: myRecipe.isEmpty
                                  ? _buildNullList()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: myRecipe.length,
                                      itemBuilder: (context, index) {
                                        return BuildRecipeScreen(
                                          recipe: myRecipe[index],
                                          index: index,
                                          onTap: (int value) {
                                            setState(() {
                                              myRecipe.removeAt(index);
                                              totalRecipe = totalRecipe - 1;
                                            });
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNullList() => Column(
        children: [
          const SizedBox(
            height: 10,
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
}
