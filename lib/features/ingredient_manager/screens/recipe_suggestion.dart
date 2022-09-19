import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/home/bloc/recipe_suggestion/recipe_suggestion_bloc.dart';
import 'package:foodhub/features/home/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:foodhub/features/home/bloc/unsave_recipe/unsave_recipe_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SuggestedRecipeCaculationScreen extends StatefulWidget {
  const SuggestedRecipeCaculationScreen({Key? key}) : super(key: key);

  @override
  State<SuggestedRecipeCaculationScreen> createState() =>
      _SuggestedRecipeCaculationScreenState();
}

class _SuggestedRecipeCaculationScreenState
    extends State<SuggestedRecipeCaculationScreen> {
  @override
  Widget build(BuildContext context) {
    int page = 1;
    int size = 20;
    String sortOption = "asc";
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => RecipeSuggestionBloc()
            ..add(RecipeSuggestion(page, size, sortOption))),
      BlocProvider(
        create: (context) =>
            IngredientUserBloc()..add(const IngredientUser("", "", "", "")),
      ),
      BlocProvider(create: (_) => SaveRecipeBloc()),
      BlocProvider(create: (_) => UnsaveRecipeBloc()),
    ], child: const SuggestedRecipeCaculationView());
  }
}

class SuggestedRecipeCaculationView extends StatefulWidget {
  const SuggestedRecipeCaculationView({Key? key}) : super(key: key);

  @override
  State<SuggestedRecipeCaculationView> createState() =>
      _SuggestedRecipeCaculationViewState();
}

class _SuggestedRecipeCaculationViewState
    extends State<SuggestedRecipeCaculationView> {
  int totalItem = 0;
  List<RecipeAppModel> recipeList = [];
  List<IngredientUserModel> ingredientUserList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiBlocListener(
      listeners: [
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
                  ingredientUserList = state.ingredientUserResponse!.items;
                },
              );
            }
          },
        ),
        BlocListener<RecipeSuggestionBloc, RecipeSuggestionState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == RecipeSuggestionStatus.Processing) {
              print("Processing");
            } else if (state.status == RecipeSuggestionStatus.Failed) {
              print("Failed");
            } else if (state.status == RecipeSuggestionStatus.Success) {
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
            "Gợi ý công thức",
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<RecipeSuggestionBloc, RecipeSuggestionState>(
                    builder: (context, state) {
                      if (state.status == RecipeSuggestionStatus.Processing) {
                        return _buildLoading();
                      } else if (state.status ==
                          RecipeSuggestionStatus.Failed) {
                        return _buildFailed();
                      } else if (state.status ==
                          RecipeSuggestionStatus.Success) {
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
                          return _buildNotFound();
                        }
                      } else {
                        return _buildNotFound();
                      }
                    },
                  ),
                ],
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
  Widget _buildNotFound() => const Center(
        child: Text("Chưa có công thức nào!"),
      );
  Widget _card(BuildContext context, int index, RecipeAppModel model) {
    int count = 0;
    double percent = 0;
    double percentValue = 0;
    List<RecipeIngredientAppModel> recipeIngredientList =
        model.ingredientModelList;
    for (int i = 0; i < recipeIngredientList.length; i++) {
      for (int j = 0; j < ingredientUserList.length; j++) {
        if (recipeIngredientList[i].recipeIngredientDBid ==
            ingredientUserList[j].ingredientDbid) {
          count++;
        }
      }
    }
    percent = ((count * 100) / recipeIngredientList.length).roundToDouble();
    percentValue = percent * 0.01;

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: Container(
          height: getProportionateScreenHeight(180),
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
                    vertical: 30,
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
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
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
                                          ),
                                        ],
                                      ).value,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                      fontSize: 14,
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
                                      fontSize: 14,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Nguyên liệu tương thích:",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: FoodHubColors.color0B0C0C),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: LinearPercentIndicator(
                                width: 200,
                                lineHeight: 15,
                                percent: percentValue,
                                animation: true,
                                animationDuration: 1000,
                                barRadius: const Radius.circular(20),
                                progressColor: FoodHubColors.colorFC6011,
                                backgroundColor: Colors.grey[120],
                                center: Text(
                                  percent.toInt().toString() + "%",
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
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
        Navigator.pushNamed(context, Routes.recipeDetail, arguments: {
          'recipeId': model.id,
        });
      },
    );
  }
}
