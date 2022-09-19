import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/social/bloc/all_recipe_bloc.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/social/screens/view_recipe_screen.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../helper/helper.dart';
import '../../user_profile/model/my_post_entity.dart';
import '../bloc/all_post_bloc.dart';
import '../screens/view_post_screen.dart';

final bucketGlobal = PageStorageBucket();

class SearchPostScreen extends StatefulWidget {
  const SearchPostScreen({Key? key}) : super(key: key);

  @override
  State<SearchPostScreen> createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AllPostBloc()..add(const AllPost(1)),
        ),
        BlocProvider(
          create: (_) => AllRecipeBloc()..add(const AllRecipe(1)),
        ),
      ],
      child: const SearchPostView(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchPostView extends StatefulWidget {
  const SearchPostView({Key? key}) : super(key: key);

  @override
  State<SearchPostView> createState() => _SearchPostViewState();
}

class _SearchPostViewState extends State<SearchPostView>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _searchKeyForm = GlobalKey();
  TextEditingController _searchController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;
  var difference;

  List<String> tags = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static const historyLength = 5;

  List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;

  String selectedTerm = '';

  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  TabController? _tabController;
  int tabIndex = 0;

  List<MyPost> allPost = [];
  List<Recipe> allRecipe = [];
  List<MyPost> allPostApp = [];
  List<Recipe> allRecipeApp = [];
  List<MyPost> allPostSearch = [];
  List<Recipe> allRecipeSearch = [];

  bool search = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AllPostBloc, AllPostState>(
          listener: (context, state) {
            if (state.status == AllPostStatus.Processing) {
            } else if (state.status == AllPostStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == AllPostStatus.Success) {
              for (int i = 0; i < state.allPost!.myPost.length; i++) {
                if (state.allPost!.myPost[i].status == 1) {
                  setState(() {
                    allPost.add(state.allPost!.myPost[i]);
                    allPostApp.add(state.allPost!.myPost[i]);
                  });
                }
              }
              setState(() {
                allPost
                    .sort((a, b) => b.totalComment.compareTo(a.totalComment));
                allPost.sort((a, b) => b.totalReact.compareTo(a.totalReact));
              });
            }
          },
        ),
        BlocListener<AllRecipeBloc, AllRecipeState>(
          listener: (context, state) {
            if (state.status == AllRecipeStatus.Processing) {
            } else if (state.status == AllRecipeStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == AllRecipeStatus.Success) {
              for (int i = 0; i < state.allRecipe!.recipe.length; i++) {
                if (state.allRecipe!.recipe[i].status == 1) {
                  setState(() {
                    allRecipe.add(state.allRecipe!.recipe[i]);
                    allRecipeApp.add(state.allRecipe!.recipe[i]);
                  });
                }
              }
              setState(() {
                allRecipe
                    .sort((a, b) => b.totalComment.compareTo(a.totalComment));
                allRecipe.sort((a, b) => b.totalReact.compareTo(a.totalReact));
              });
            }
          },
        ),
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: KeyboardDismisser(
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
                body: FloatingSearchBar(
                  controller: controller,
                  transition: CircularFloatingSearchBarTransition(),
                  physics: const BouncingScrollPhysics(),
                  title: Text(
                    selectedTerm,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  hint: 'Search and find out...',
                  actions: [
                    FloatingSearchBarAction.searchToClear(),
                  ],
                  onSubmitted: (query) {
                    setState(() {
                      addSearchTerm(query);
                      selectedTerm = query;
                    });
                    if (query.isEmpty) {
                      setState(() {
                        search = true;
                      });
                    } else {
                      setState(() {
                        search = false;
                      });
                    }
                    allPostSearch.clear();
                    for (int i = 0; i < allPostApp.length; i++) {
                      if (allPostApp[i]
                          .title
                          .toLowerCase()
                          .contains(query.toLowerCase())) {
                        setState(() {
                          allPostSearch.add(allPostApp[i]);
                        });
                      }
                    }
                    allRecipeSearch.clear();
                    for (int i = 0; i < allRecipeApp.length; i++) {
                      if (allRecipeApp[i]
                          .recipeName
                          .toLowerCase()
                          .contains(query.toLowerCase())) {
                        setState(() {
                          allRecipeSearch.add(allRecipeApp[i]);
                        });
                      }
                    }
                    controller.close();
                  },
                  body: Column(
                    children: [
                      SizedBox(height: 70),
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
                            });
                          },
                          tabs: const [
                            Tab(
                              text: "Bài viết",
                            ),
                            Tab(
                              text: "Công thức",
                            ),
                            // Tab(
                            //   text: "Người dùng",
                            // ),
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
                            search
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allPost.length >= 5
                                        ? 5
                                        : allPost.length,
                                    itemBuilder: (context, index) {
                                      return myPostButton(
                                          context,
                                          const Icon(
                                            Icons.event_available_rounded,
                                            size: 22,
                                            color: Colors.black54,
                                          ),
                                          allPost[index],
                                          search);
                                    },
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allPostSearch.length,
                                    itemBuilder: (context, index) {
                                      return myPostButton(
                                          context,
                                          const Icon(
                                            Icons.event_available_rounded,
                                            size: 22,
                                            color: Colors.black54,
                                          ),
                                          allPostSearch[index],
                                          search);
                                    },
                                  ),
                            search
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allRecipe.length >= 5
                                        ? 5
                                        : allRecipe.length,
                                    itemBuilder: (context, index) {
                                      return myRecipeButton(
                                          context,
                                          const Icon(
                                            Icons.event_available_rounded,
                                            size: 22,
                                            color: Colors.black54,
                                          ),
                                          allRecipe[index],
                                          search);
                                    },
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: allRecipeSearch.length,
                                    itemBuilder: (context, index) {
                                      return myRecipeButton(
                                          context,
                                          const Icon(
                                            Icons.event_available_rounded,
                                            size: 22,
                                            color: Colors.black54,
                                          ),
                                          allRecipeSearch[index],
                                          search);
                                    },
                                  ),
                            // ListView.builder(
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount:
                            //       allPost.length >= 5 ? 5 : allPost.length,
                            //   itemBuilder: (context, index) {
                            //     return myPostButton(
                            //         context,
                            //         const Icon(
                            //           Icons.event_available_rounded,
                            //           size: 22,
                            //           color: Colors.black54,
                            //         ),
                            //         allPost[index],
                            //         search);
                            //   },
                            // ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  builder: (context, transition) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4,
                        child: Builder(
                          builder: (context) {
                            if (filteredSearchHistory.isEmpty &&
                                controller.query.isEmpty) {
                              return Container(
                                height: 56,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  'Start searching',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              );
                            } else if (filteredSearchHistory.isEmpty) {
                              return ListTile(
                                title: Text(controller.query),
                                leading: const Icon(Icons.search),
                                onTap: () {
                                  setState(() {
                                    addSearchTerm(controller.query);
                                    selectedTerm = controller.query;
                                  });

                                  controller.close();
                                },
                              );
                            } else {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: filteredSearchHistory
                                    .map(
                                      (term) => ListTile(
                                        title: Text(
                                          term,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        leading: const Icon(Icons.history),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              deleteSearchTerm(term);
                                            });
                                          },
                                        ),
                                        onTap: () {
                                          setState(() {
                                            putSearchTermFirst(term);
                                            selectedTerm = term;
                                            search = false;
                                          });
                                          if (term.isEmpty) {
                                            setState(() {
                                              search = true;
                                            });
                                          } else {
                                            allPostSearch.clear();
                                            for (int i = 0;
                                                i < allPostApp.length;
                                                i++) {
                                              if (allPostApp[i]
                                                  .title
                                                  .toLowerCase()
                                                  .contains(
                                                      term.toLowerCase())) {
                                                setState(() {
                                                  allPostSearch
                                                      .add(allPostApp[i]);
                                                });
                                              }
                                            }
                                            allRecipeSearch.clear();
                                            for (int i = 0;
                                                i < allRecipeApp.length;
                                                i++) {
                                              if (allRecipeApp[i]
                                                  .recipeName
                                                  .toLowerCase()
                                                  .contains(
                                                      term.toLowerCase())) {
                                                setState(() {
                                                  allRecipeSearch
                                                      .add(allRecipeApp[i]);
                                                });
                                              }
                                            }
                                          }
                                          controller.close();
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myPostButton(
      BuildContext context, Icon icon, MyPost post, bool search) {
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
                        image: NetworkImage(post.postImages[0].imageUrl),
                        fit: BoxFit.cover),
                  ),
                  height: getProportionateScreenHeight(115),
                  width: getProportionateScreenWidth(115),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: SizedBox(
                              child: Text(
                                post.title,
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
                          search
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: FoodHubColors.colorFC6011,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Trending",
                                      style: TextStyle(
                                          color: FoodHubColors.colorFFFFFF,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          post.content,
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
                                .format(dateFormat.parse(post.publishedDate))
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
              )
            ],
          ),
        ),
      ),
      onTap: () {
        difference = timePost(post.publishedDate);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewPostScreen(
              post: post,
              timeAgo: difference,
              index: 987456123,
              onTap: (value) {},
            ),
          ),
        );
      },
    );
  }

  Widget myRecipeButton(
      BuildContext context, Icon icon, Recipe recipe, bool search) {
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
                          search
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: FoodHubColors.colorFC6011,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Trending",
                                      style: TextStyle(
                                          color: FoodHubColors.colorFFFFFF,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                )
                              : Container(),
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
                                .format(dateFormat.parse(recipe.publishedDate))
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
              )
            ],
          ),
        ),
      ),
      onTap: () {
        difference = timePost(recipe.publishedDate);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewRecipeScreen(
              recipe: recipe,
              timeAgo: difference,
              index: 987456123,
              onTap: (value) {},
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
