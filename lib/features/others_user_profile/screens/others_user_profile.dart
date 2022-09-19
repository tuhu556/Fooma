import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/others_user_profile/bloc/others_user_profile_bloc.dart';
import 'package:foodhub/features/others_user_profile/widgets/profile_header_widget.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/user_profile/model/my_post_entity.dart';
import 'package:foodhub/features/user_profile/model/user_profile_entity.dart';
import 'package:foodhub/widgets/build_post_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helper/helper.dart';
import '../../../widgets/build_recipe_screen.dart';

class OthersUserProfileScreen extends StatefulWidget {
  const OthersUserProfileScreen({Key? key}) : super(key: key);

  @override
  _OthersUserProfileScreenState createState() =>
      _OthersUserProfileScreenState();
}

class _OthersUserProfileScreenState extends State<OthersUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) => OthersUserProfileBloc()
        ..add(OthersUserProfile(args))
        ..add(OthersListPost(args, 1, 1))
        ..add(OthersListRecipe(args, 1, 1)),
      child: const OthersUserProfileView(),
    );
  }
}

class OthersUserProfileView extends StatefulWidget {
  const OthersUserProfileView({Key? key}) : super(key: key);

  @override
  State<OthersUserProfileView> createState() => _OthersUserProfileViewState();
}

class _OthersUserProfileViewState extends State<OthersUserProfileView>
    with TickerProviderStateMixin {
  final TextEditingController _descriptionController =
      new TextEditingController();
  String? validationContent;
  int tab = 0;

  UserProfileResponse userProfile =
      new UserProfileResponse(totalPost: 0, totalRecipe: 0, role: "USER");

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
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKey = GlobalKey();
  int pageApprovedPost = 1;

  int pageApprovedRecipe = 1;
  final RefreshController _refreshControllerRecipe =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKeyRecipe = GlobalKey();

  late TabController tabController;
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
    return BlocListener<OthersUserProfileBloc, OthersUserProfileState>(
      listener: (context, state) {
        if (state.status == OthersUserProfileStatus.Processing) {
        } else if (state.status == OthersUserProfileStatus.Failed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == OthersUserProfileStatus.Success) {
          setState(() {
            userProfile = state.othersUserProfile!;
            onPress = true;
          });
        }
        //!
        else if (state.status == OthersUserProfileStatus.MyPostProcessing) {
          // Helpers.shared.showDialogProgress(context);
        } else if (state.status == OthersUserProfileStatus.MyPostFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == OthersUserProfileStatus.MyPostSuccess) {
          // Helpers.shared.hideDialogProgress(context);
          for (var i = 0; i < state.othersPost!.myPost.length; i++) {
            setState(() {
              myPost.add(state.othersPost!.myPost[i]);
            });
          }
          if (pageApprovedPost >= state.othersPost!.totalPage) {
            setState(() {
              enablePullUpPost = false;
            });
          }
        }
        //!
        else if (state.status == OthersUserProfileStatus.MyRecipeProcessing) {
        } else if (state.status == OthersUserProfileStatus.MyRecipeFailed) {
          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == OthersUserProfileStatus.MyRecipeSuccess) {
          for (var i = 0; i < state.othersRecipe!.recipe.length; i++) {
            setState(() {
              myRecipe.add(state.othersRecipe!.recipe[i]);
            });
          }
          if (pageApprovedRecipe >= state.othersRecipe!.totalPage) {
            setState(() {
              enablePullUpRecipe = false;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: FoodHubColors.colorFFFFFF,
        appBar: AppBar(
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
          automaticallyImplyLeading: false,
          backgroundColor: FoodHubColors.colorFFFFFF,
          centerTitle: true,
          title: Text(
            "Hồ sơ",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: FoodHubColors.color0B0C0C,
            ),
          ),
        ),
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
                          profileOthersHeaderWidget(
                              context, 1, userProfile, onPress),
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
                          tabs: [
                            Tab(
                              text: "Bài đăng (" +
                                  userProfile.totalPost.toString() +
                                  ")",
                            ),
                            Tab(
                              text: "Công thức (" +
                                  userProfile.totalRecipe.toString() +
                                  ")",
                            ),
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
                                final bloc =
                                    context.read<OthersUserProfileBloc>();
                                bloc.add(OthersListPost(
                                    userProfile.id!, pageApprovedPost, 1));
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
                                final bloc =
                                    context.read<OthersUserProfileBloc>();
                                bloc.add(OthersListPost(userProfile.id!, 1, 1));
                                _refreshController.refreshCompleted();
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myPost.length,
                                itemBuilder: (context, index) {
                                  return BuildPostScreen(
                                    posts: myPost[index],
                                    index: index,
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
                                final bloc =
                                    context.read<OthersUserProfileBloc>();
                                bloc.add(OthersListRecipe(
                                    userProfile.id!, pageApprovedRecipe, 1));
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
                                final bloc =
                                    context.read<OthersUserProfileBloc>();
                                bloc.add(
                                    OthersListRecipe(userProfile.id!, 1, 1));
                                _refreshControllerRecipe.refreshCompleted();
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myRecipe.length,
                                itemBuilder: (context, index) {
                                  return BuildRecipeScreen(
                                    recipe: myRecipe[index],
                                    index: index,
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
}
