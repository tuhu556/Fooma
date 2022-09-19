import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/features/favorite_post/bloc/favorite_post_bloc.dart';
import 'package:foodhub/features/favorite_post/models/favorite_recipe_entity.dart';
import 'package:foodhub/features/favorite_post/screens/favorite_post_detail.dart';
import 'package:foodhub/features/favorite_post/screens/favorite_recipe_detail.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config/size_config.dart';
import '../../../constants/color.dart';
import '../bloc/favorite_recipe_bloc.dart';
import '../models/favorite_post_entity.dart';

class FavoritePostScreen extends StatefulWidget {
  const FavoritePostScreen({Key? key}) : super(key: key);

  @override
  State<FavoritePostScreen> createState() => _FavoritePostScreenState();
}

class _FavoritePostScreenState extends State<FavoritePostScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MyFavoritePostBloc()..add(const MyFavoritePost()),
        ),
        BlocProvider(
          create: (_) => MyFavoriteRecipeBloc()..add(const MyFavoriteRecipe()),
        )
      ],
      child: const FavoritePostView(),
    );
  }
}

class FavoritePostView extends StatefulWidget {
  const FavoritePostView({Key? key}) : super(key: key);

  @override
  State<FavoritePostView> createState() => _FavoritePostViewState();
}

class _FavoritePostViewState extends State<FavoritePostView> {
  final List<bool> _check = [];
  final List<bool> _checkRecipe = [];
  List<FavoritePost> favoritePost = [];
  List<Recipe> favoriteRecipe = [];
  final DateFormat formatterYMD = DateFormat('yyyy-MM-dd');

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherKey = GlobalKey();

  TabController? _tabController;

  final RefreshController _refreshRecipeController =
      RefreshController(initialRefresh: false);
  final GlobalKey _refresherRecipeKey = GlobalKey();

  int tabIndex = 0;
  int totalPost = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyFavoritePostBloc, MyFavoritePostState>(
          listener: (context, state) {
            if (state.status == MyFavoritePostStatus.Processing) {
            } else if (state.status == MyFavoritePostStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.Success) {
              favoritePost.clear();
              _check.clear();
              setState(() {
                totalPost = state.myFavoritePost!.totalItem;
                favoritePost = state.myFavoritePost!.favoritePost;
                for (int i = 0; i < favoritePost.length; i++) {
                  _check.add(true);
                }
              });
            } else if (state.status == MyFavoritePostStatus.SaveProcessing) {
            } else if (state.status == MyFavoritePostStatus.SaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.SaveSuccess) {
            } else if (state.status == MyFavoritePostStatus.UnSaveProcessing) {
            } else if (state.status == MyFavoritePostStatus.UnSaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoritePostStatus.UnSaveSuccess) {}
          },
        ),
        BlocListener<MyFavoriteRecipeBloc, MyFavoriteRecipeState>(
          listener: (context, state) {
            if (state.status == MyFavoriteRecipeStatus.Processing) {
            } else if (state.status == MyFavoriteRecipeStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoriteRecipeStatus.Success) {
              favoriteRecipe.clear();
              _checkRecipe.clear();
              setState(() {
                totalPost = state.myFavoriteRecipe!.totalItem;
                favoriteRecipe = state.myFavoriteRecipe!.favoriteRecipe;
                for (int i = 0; i < favoriteRecipe.length; i++) {
                  _checkRecipe.add(true);
                }
              });
            } else if (state.status == MyFavoriteRecipeStatus.SaveProcessing) {
            } else if (state.status == MyFavoriteRecipeStatus.SaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoriteRecipeStatus.SaveSuccess) {
            } else if (state.status ==
                MyFavoriteRecipeStatus.UnSaveProcessing) {
            } else if (state.status == MyFavoriteRecipeStatus.UnSaveFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == MyFavoriteRecipeStatus.UnSaveSuccess) {}
          },
        ),
      ],
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
              "Nội dung đã lưu",
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
                      ? favoritePost.length.toString() + " Bài viết"
                      : favoriteRecipe.length.toString() + " Công thức",
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
            length: 2,
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
                        labelColor: FoodHubColors.colorFC6011,
                        unselectedLabelColor: FoodHubColors.color0B0C0C,
                        indicatorWeight: 2,
                        indicatorColor: FoodHubColors.colorFC6011,
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        onTap: (index) {
                          setState(() {
                            tabIndex = index;
                            if (index == 0) {
                              setState(() {
                                totalPost = favoritePost.length;
                              });
                            } else if (index == 1) {
                              setState(() {
                                totalPost = favoriteRecipe.length;
                              });
                            }
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 20,
                          vertical: 10,
                        ),
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SmartRefresher(
                              key: _refresherKey,
                              controller: _refreshController,
                              // enablePullUp: true,
                              physics: const BouncingScrollPhysics(),
                              footer: const ClassicFooter(
                                loadStyle: LoadStyle.ShowWhenLoading,
                                completeDuration: Duration(milliseconds: 500),
                              ),
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                final bloc = context.read<MyFavoritePostBloc>();
                                bloc.add(const MyFavoritePost());
                                _refreshController.refreshCompleted();
                              },
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 25)
                                          .add(const EdgeInsets.only(
                                    bottom: 20,
                                  )),
                                  child: favoritePost.isEmpty
                                      ? _buildNullList()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: favoritePost.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return myPostButton(
                                              context,
                                              const Icon(
                                                Icons.event_available_rounded,
                                                size: 22,
                                                color: Colors.black54,
                                              ),
                                              _check[index],
                                              index,
                                              favoritePost[index],
                                            );
                                          },
                                        ),
                                ),
                              ),
                            ),
                            SmartRefresher(
                              key: _refresherRecipeKey,
                              controller: _refreshRecipeController,
                              // enablePullUp: true,
                              physics: const BouncingScrollPhysics(),
                              footer: const ClassicFooter(
                                loadStyle: LoadStyle.ShowWhenLoading,
                                completeDuration: Duration(milliseconds: 500),
                              ),
                              onRefresh: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                final bloc =
                                    context.read<MyFavoriteRecipeBloc>();
                                bloc.add(const MyFavoriteRecipe());
                                _refreshRecipeController.refreshCompleted();
                              },
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 25)
                                          .add(const EdgeInsets.only(
                                    bottom: 20,
                                  )),
                                  child: favoriteRecipe.isEmpty
                                      ? _buildNullList()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: favoriteRecipe.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return myRecipeButton(
                                              context,
                                              const Icon(
                                                Icons.event_available_rounded,
                                                size: 22,
                                                color: Colors.black54,
                                              ),
                                              _checkRecipe[index],
                                              index,
                                              favoriteRecipe[index],
                                            );
                                          },
                                        ),
                                ),
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
  Widget myPostButton(BuildContext context, Icon icon, bool _isSave, int index,
      FavoritePost post) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Container(
          // height: getProportionateScreenHeight(145),
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
                        image: NetworkImage(post.postResponse.postImages.isEmpty
                            ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                            : post.postResponse.postImages[0].imageUrl),
                        fit: BoxFit.cover),
                  ),
                  height: getProportionateScreenHeight(110),
                  width: getProportionateScreenWidth(110),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: Text(
                                post.postResponse.title,
                                maxLines: 2,
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
                          InkWell(
                            child: Icon(
                              _isSave
                                  ? Icons.turned_in_outlined
                                  : Icons.turned_in_not_outlined,
                              size: 40,
                              color: _isSave
                                  ? FoodHubColors.colorFC6011
                                  : Colors.black54,
                            ),
                            onTap: () {
                              const saveText = "Đã lưu bài viết này";
                              const cancelText = "Bỏ lưu bài viết này";

                              setState(() {
                                _isSave = !_isSave;
                                _check[index] = !_check[index];
                                // setState(() {
                                //   post[index].                                });
                                if (_isSave) {
                                  final bloc =
                                      context.read<MyFavoritePostBloc>();
                                  bloc.add(SavePost(post.postId));
                                  const snackBar = SnackBar(
                                    content: Text(saveText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    favoritePost.removeAt(index);
                                    _check.removeAt(index);
                                    totalPost--;
                                  });
                                  final bloc =
                                      context.read<MyFavoritePostBloc>();
                                  bloc.add(UnSavePost(post.postId));
                                  const snackBar = SnackBar(
                                    content: Text(cancelText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Đã lưu từ ',
                          style: TextStyle(
                            fontSize: 16,
                            color: FoodHubColors.color0B0C0C,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'bài viết của ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: post.postResponse.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                          Expanded(
                            child: Text(
                              DateFormat("yyyy-MM-dd")
                                  .format(DateTime.parse(
                                      post.postResponse.publishedDate))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ),
                        ],
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FavoritePostDetail(
              post: post,
              index: index,
              onTap: (int value) {
                setState(() {
                  favoritePost.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget myRecipeButton(
      BuildContext context, Icon icon, bool _isSave, int index, Recipe recipe) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Container(
          // height: getProportionateScreenHeight(145),
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
                        image: NetworkImage(recipe.thumbnail.isEmpty
                            ? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                            : recipe.thumbnail),
                        fit: BoxFit.cover),
                  ),
                  height: getProportionateScreenHeight(110),
                  width: getProportionateScreenWidth(110),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: Text(
                                recipe.recipeName,
                                maxLines: 2,
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
                          InkWell(
                            child: Icon(
                              _isSave
                                  ? Icons.turned_in_outlined
                                  : Icons.turned_in_not_outlined,
                              size: 40,
                              color: _isSave
                                  ? FoodHubColors.colorFC6011
                                  : Colors.black54,
                            ),
                            onTap: () {
                              const saveText = "Đã lưu bài viết này";
                              const cancelText = "Bỏ lưu bài viết này";

                              setState(() {
                                _isSave = !_isSave;
                                _checkRecipe[index] = !_checkRecipe[index];
                                // setState(() {
                                //   post[index].                                });
                                if (_isSave) {
                                  final bloc =
                                      context.read<MyFavoriteRecipeBloc>();
                                  bloc.add(SaveRecipe(recipe.id));
                                  const snackBar = SnackBar(
                                    content: Text(saveText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    favoriteRecipe.removeAt(index);
                                    _checkRecipe.removeAt(index);
                                    totalPost--;
                                  });
                                  final bloc =
                                      context.read<MyFavoriteRecipeBloc>();
                                  bloc.add(UnSaveRecipe(recipe.id));
                                  const snackBar = SnackBar(
                                    content: Text(cancelText),
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Đã lưu từ ',
                          style: TextStyle(
                            fontSize: 16,
                            color: FoodHubColors.color0B0C0C,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'bài viết của ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: recipe.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                          Expanded(
                            child: Text(
                              DateFormat("yyyy-MM-dd")
                                  .format(DateTime.parse(recipe.createDate))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          ),
                        ],
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FavoriteRecipeDetailScreen(
              recipe: recipe,
              index: index,
              onTap: (int value) {
                setState(() {
                  favoriteRecipe.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
