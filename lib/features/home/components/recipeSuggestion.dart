import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/home/bloc/recipe_suggestion/recipe_suggestion_bloc.dart';
import 'package:foodhub/features/home/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:foodhub/features/home/bloc/unsave_recipe/unsave_recipe_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecipeSuggestionScreen extends StatefulWidget {
  final int page;
  final int size;
  final String sortOption;
  const RecipeSuggestionScreen(
      {Key? key,
      required this.page,
      required this.size,
      required this.sortOption})
      : super(key: key);

  @override
  State<RecipeSuggestionScreen> createState() => _RecipeSuggestionScreenState();
}

class _RecipeSuggestionScreenState extends State<RecipeSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => RecipeSuggestionBloc()
            ..add(
                RecipeSuggestion(widget.page, widget.size, widget.sortOption))),
      BlocProvider(create: (_) => SaveRecipeBloc()),
      BlocProvider(create: (_) => UnsaveRecipeBloc()),
    ], child: const RecipeSuggetionView());
  }
}

class RecipeSuggetionView extends StatefulWidget {
  const RecipeSuggetionView({Key? key}) : super(key: key);

  @override
  State<RecipeSuggetionView> createState() => _RecipeSuggetionViewState();
}

class _RecipeSuggetionViewState extends State<RecipeSuggetionView> {
  @override
  Widget build(BuildContext context) {
    List<RecipeAppModel> recipeList = [];
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<RecipeSuggestionBloc, RecipeSuggestionState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == RecipeSuggestionStatus.Processing) {
              print("Processing");
            } else if (state.status == RecipeSuggestionStatus.Failed) {
              print("Failed");
            } else if (state.status == RecipeSuggestionStatus.Success) {
              print("Success");
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
      child: BlocBuilder<RecipeSuggestionBloc, RecipeSuggestionState>(
        builder: (context, state) {
          if (state.status == RecipeSuggestionStatus.Processing) {
            return _buildLoading();
          } else if (state.status == RecipeSuggestionStatus.Failed) {
            return _buildFailed();
          } else if (state.status == RecipeSuggestionStatus.Success) {
            recipeList.clear();
            recipeList = state.recipeResponse!.items;
            if (recipeList.isEmpty) {
              return _buildNothing();
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipeList.length,
                itemBuilder: (context, index) {
                  return recipeCard(
                    context,
                    index,
                    recipeList[index],
                  );
                },
              );
            }
          } else {
            return Container();
          }
        },
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
  Widget _buildNothing() => Column(
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
            child: Text("Chưa có nguyên liệu để gợi ý công thức!"),
          ),
        ],
      );
  Widget recipeCard(BuildContext context, int index, RecipeAppModel model) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(500),
            width: getProportionateScreenWidth(260),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 8),
                ),
              ],
              color: FoodHubColors.colorFFC5A8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      model.thumbnailImage,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: FoodHubColors.colorFC6011,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      fit: BoxFit.fitWidth,
                      height: getProportionateScreenHeight(ResponsiveValue(
                        context,
                        defaultValue: 200.0,
                        valueWhen: const [
                          Condition.smallerThan(
                            name: MOBILE,
                            value: 190.0,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: 220.0,
                          )
                        ],
                      ).value!),
                      width: 275,
                    )),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.01,
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          height: getProportionateScreenHeight(45),
                          child: Text(
                            model.recipeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 25.0,
                                  valueWhen: const [
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 27.0,
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
                  height: SizeConfig.screenHeight! * 0.015,
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: getProportionateScreenHeight(55),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Text(
                            model.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 16.0,
                                  valueWhen: const [
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 18.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Khẩu phần: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            model.serves.toString() + " người",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.01,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Thời gian chuẩn bị: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            model.preparationTime.toString() + ' phút',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.01,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Thời gian chế biến: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            model.cookingTime.toString() + " phút",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 18.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                      name: MOBILE,
                                      value: 15.0,
                                    ),
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: 20.0,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: getProportionateScreenHeight(50),
                          width: getProportionateScreenWidth(50),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 1, color: FoodHubColors.colorFFA375),
                            color: FoodHubColors.colorFFA375,
                          ),
                          child: Icon(
                            model.isSaved
                                ? Icons.check_circle_outline
                                : Icons.add_circle_outline,
                            size: 30,
                            color: FoodHubColors.colorFC6011,
                          ),
                        ),
                        onTap: () {
                          const saveText = "Đã lưu công thức này";
                          const cancelText = "Bỏ lưu công thức này";

                          setState(() {
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
                              final bloc = context.read<UnsaveRecipeBloc>();
                              bloc.add(UnSaveRecipe(model.id));
                              model.isSaved = !model.isSaved;
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
                      const SizedBox(
                        width: 10,
                      ),
                      DefaultButton(
                        width: getProportionateScreenHeight(180),
                        text: "XEM CÔNG THỨC",
                        press: () {
                          Navigator.pushNamed(context, Routes.recipeDetail,
                              arguments: {'recipeId': model.id});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.01,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
