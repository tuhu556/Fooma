import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/features/home/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:foodhub/features/home/bloc/unsave_recipe/unsave_recipe_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/saved_recipe/bloc/saved_recipe/saved_recipe_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../config/size_config.dart';
import '../../../constants/color.dart';

class FavoriteRecipeScreen extends StatefulWidget {
  const FavoriteRecipeScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipeScreen> createState() => _FavoriteRecipeScreenState();
}

class _FavoriteRecipeScreenState extends State<FavoriteRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => SavedRecipeBloc()
          ..add(
            const GetSavedRecipe(1, 100, "", 1),
          ),
      ),
      BlocProvider(create: (_) => SaveRecipeBloc()),
      BlocProvider(create: (_) => UnsaveRecipeBloc()),
    ], child: const FavoriteRecipeView());
  }
}

class FavoriteRecipeView extends StatefulWidget {
  const FavoriteRecipeView({Key? key}) : super(key: key);

  @override
  State<FavoriteRecipeView> createState() => _FavoriteRecipeViewState();
}

class _FavoriteRecipeViewState extends State<FavoriteRecipeView> {
  List<RecipeAppModel> recipeList = [];
  int totalItem = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<SavedRecipeBloc, SavedRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == SavedRecipeStatus.Processing) {
              print("Processing");
            } else if (state.status == SavedRecipeStatus.Failed) {
              print("Failed");
            } else if (state.status == SavedRecipeStatus.Success) {
              print("Success");
              recipeList.clear();
              setState(() {
                totalItem = state.recipeResponse!.totalItem;
                recipeList = state.recipeResponse!.items;
              });
            }
          },
        ),
        BlocListener<SaveRecipeBloc, SaveRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == SaveRecipeStatus.Processing) {
              print("Save Processing");
            } else if (state.status == SaveRecipeStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: không thể lưu công thức này"),
                ),
              );
              print("Save Failed");
            } else if (state.status == SaveRecipeStatus.Success) {
              print("Save Success");
            }
          },
        ),
        BlocListener<UnsaveRecipeBloc, UnsaveRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == UnSaveRecipeStatus.Processing) {
              print("UnSave Processing");
            } else if (state.status == UnSaveRecipeStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: không thể bỏ lưu công thức này"),
                ),
              );
              print("UnSave Failed");
            } else if (state.status == UnSaveRecipeStatus.Success) {
              print("UnSave Success");
            }
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
              "Công thức đã lưu",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 10),
                child: Text(
                  totalItem.toString() + " Công thức",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<SavedRecipeBloc, SavedRecipeState>(
                      builder: (context, state) {
                        if (state.status == SavedRecipeStatus.Processing) {
                          return _buildLoading();
                        } else if (state.status == SavedRecipeStatus.Failed) {
                          return _buildFailed();
                        } else if (state.status == SavedRecipeStatus.Success) {
                          if (recipeList.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipeList.length,
                              itemBuilder: (context, index) {
                                return _card(
                                  context,
                                  index,
                                  recipeList[index],
                                );
                              },
                            );
                          } else {
                            return _buildNullList();
                          }
                        } else {
                          return _buildNullList();
                        }
                      },
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

  Widget _buildLoading() => Center(
        child: CircularProgressIndicator(
          color: FoodHubColors.colorFC6011,
        ),
      );
  Widget _buildFailed() => const Center(
        child: Text("Lỗi! không ổn rồi"),
      );
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
            child: Text("Chưa có công thức nào hết trơn á!"),
          ),
        ],
      );
  Widget _card(BuildContext context, int index, RecipeAppModel model) {
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
                        image: NetworkImage(model.thumbnailImage),
                        fit: BoxFit.fitWidth),
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
                                model.recipeName.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveValue(
                                      context,
                                      defaultValue: 22.0,
                                      valueWhen: const [
                                        Condition.largerThan(
                                          name: TABLET,
                                          value: 24.0,
                                        )
                                      ],
                                    ).value,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.schedule,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  model.cookingTime.toString() + " phút",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  model.serves.toString() + " người",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Icon(
                              model.isSaved
                                  ? Icons.turned_in
                                  : Icons.turned_in_not_outlined,
                              size: 45,
                              color: model.isSaved
                                  ? FoodHubColors.colorFC6011
                                  : Colors.black54,
                            ),
                            onTap: () {
                              const saveText = "Đã lưu công thức này";
                              const cancelText = "Bỏ lưu công thức này";

                              setState(
                                () {
                                  if (model.isSaved == false) {
                                    final bloc = context.read<SaveRecipeBloc>();
                                    bloc.add(SaveRecipe(model.id));
                                    model.isSaved = !model.isSaved;

                                    const snackBar = SnackBar(
                                      content: Text(saveText),
                                      duration: Duration(milliseconds: 500),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    recipeList.removeAt(index);
                                    final bloc =
                                        context.read<UnsaveRecipeBloc>();
                                    bloc.add(UnSaveRecipe(model.id));
                                    model.isSaved = !model.isSaved;
                                    const snackBar = SnackBar(
                                      content: Text(cancelText),
                                      duration: Duration(milliseconds: 500),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    totalItem--;
                                  }
                                },
                              );
                            },
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
        Navigator.pushNamed(context, Routes.recipeDetail,
            arguments: {'recipeId': model.id});
      },
    );
  }
}
