import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/home/bloc/recipe_app/recipe_app_bloc.dart';
import 'package:foodhub/features/home/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:foodhub/features/home/bloc/unsave_recipe/unsave_recipe_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/plan/models/card.dart';
import 'package:foodhub/features/search_recipe/bloc/category_recipe/category_recipe_bloc.dart';
import 'package:foodhub/features/search_recipe/bloc/method_recipe/method_recipe_bloc.dart';
import 'package:foodhub/features/search_recipe/bloc/origin_recipe/origin_recipe_bloc.dart';
import 'package:foodhub/features/search_recipe/model/category_recipe_entity.dart';
import 'package:foodhub/features/search_recipe/model/method_recipe_entity.dart';
import 'package:foodhub/features/search_recipe/model/origin_recipe_repository.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tiengviet/tiengviet.dart';

class ResultSearchRecipePlanScreen extends StatefulWidget {
  const ResultSearchRecipePlanScreen({Key? key}) : super(key: key);

  @override
  State<ResultSearchRecipePlanScreen> createState() =>
      _ResultSearchRecipePlanScreenState();
}

class _ResultSearchRecipePlanScreenState
    extends State<ResultSearchRecipePlanScreen> {
  String search = "";
  int page = 1;
  int size = 50;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    search = args['search'];
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => RecipeAppBloc()
          ..add(RecipeApp(page, 20, "", search, "", "", "", 500, 1)),
      ),
      BlocProvider(
          create: (_) => CategoryRecipeBloc()..add(CategoryRecipe(page, size))),
      BlocProvider(
          create: (_) => MethodRecipeBloc()..add(MethodRecipe(page, size))),
      BlocProvider(
          create: (_) => OriginRecipeBloc()..add(OriginRecipe(page, size))),
    ], child: const ResultSearchRecipePlanView());
  }
}

class ResultSearchRecipePlanView extends StatefulWidget {
  const ResultSearchRecipePlanView({Key? key}) : super(key: key);

  @override
  State<ResultSearchRecipePlanView> createState() =>
      _ResultSearchRecipePlanViewState();
}

class _ResultSearchRecipePlanViewState
    extends State<ResultSearchRecipePlanView> {
  int page = 1;
  int size = 50;
  bool _onTap = false;

  bool _isPress = false;
  bool _timeToCook = false;
  double _value = 120;
  int valueTime = 120;
  String category = "";
  CardModel? card;
  List<RecipeAppModel> recipeList = [];
  List<RecipeCategoryModel> categoryList = [];
  List<RecipeCategoryModel> categorySelectedList = [];
  List<MethodRecipeModel> methodList = [];
  List<OriginModel> originList = [];
  OriginModel? selectedOrigin;
  MethodRecipeModel? selectedMethod;
  //-----------------------
  String search = "";
  String selectedOriginId = "";
  String selectedCategoryId = "";
  String selectedMethodId = "";
  String selectedDate = "";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    search = args['search'];
    selectedDate = args['selectedDate'];
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<RecipeAppBloc, RecipeAppState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == RecipeAppStatus.Processing) {
              print("Processing");
            } else if (state.status == RecipeAppStatus.Failed) {
              print("Failed");
            } else if (state.status == RecipeAppStatus.Success) {
              print("Success");
              recipeList.clear();
              setState(() {
                recipeList = state.recipeResponse!.items;
              });
            }
          },
        ),
        BlocListener<CategoryRecipeBloc, CategoryRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == CategoryStatus.Processing) {
              print("Category Processing");
            } else if (state.status == CategoryStatus.Failed) {
              print("Category Failed");
            } else if (state.status == CategoryStatus.Success) {
              print("Category Success");
              categoryList.clear;
              setState(() {
                categoryList = state.categoryResponse!.items;
              });
            }
          },
        ),
        BlocListener<MethodRecipeBloc, MethodRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == MethodStatus.Processing) {
              print("Method Processing");
            } else if (state.status == MethodStatus.Failed) {
              print("Method Failed");
            } else if (state.status == MethodStatus.Success) {
              print("Method Success");
              methodList.clear;
              setState(() {
                methodList = state.methodResponse!.items;
                methodList.insert(0, MethodRecipeModel("", "Tất cả"));
                selectedMethod = methodList[0];
              });
            }
          },
        ),
        BlocListener<OriginRecipeBloc, OriginRecipeState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == OriginStatus.Processing) {
              print("Origin Processing");
            } else if (state.status == OriginStatus.Failed) {
              print("Origin Failed");
            } else if (state.status == OriginStatus.Success) {
              print("Origin Success");
              originList.clear;
              setState(() {
                originList = state.originResponse!.items;
                originList.insert(0, OriginModel("", "Tất cả"));
                selectedOrigin = originList[0];
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: FoodHubColors.colorF0F5F9,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FoodHubColors.colorF0F5F9,
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
            "Kết quả",
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
                  Icons.tune,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.06,
                  ),
                  BlocBuilder<RecipeAppBloc, RecipeAppState>(
                    builder: (context, state) {
                      if (state.status == RecipeAppStatus.Processing) {
                        return _buildLoading();
                      } else if (state.status == RecipeAppStatus.Failed) {
                        return _buildFailed();
                      } else if (state.status == RecipeAppStatus.Success) {
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
        child: Text("Không tìm thấy kết quả :<"),
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
                                    Icons.whatshot,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  model.calories.toString(),
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
                              Icons.add_circle_outline_rounded,
                              size: 45,
                              color: FoodHubColors.colorFC6011,
                            ),
                            onTap: () {
                              setState(() {
                                card = CardModel(
                                    model.id,
                                    model.recipeName,
                                    model.thumbnailImage,
                                    model.cookingTime,
                                    model.calories,
                                    model.serves,
                                    model.cookingMethodName);
                              });
                              Navigator.of(context).pushNamed(Routes.plan,
                                  arguments: {
                                    'selectedDate': selectedDate,
                                    'card': card
                                  });
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
        Navigator.pushNamed(context, Routes.recipePlanDetail,
            arguments: {'recipeId': model.id, 'selectedDate': selectedDate});
      },
    );
  }

  void filterScreen(context) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorF0F5F9,
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context2) {
        return BlocProvider.value(
          value: BlocProvider.of<RecipeAppBloc>(context),
          child: StatefulBuilder(builder: (context, setState) {
            return FractionallySizedBox(
              heightFactor: 0.8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    const Text(
                      "Bộ lọc tìm kiếm",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Thời gian chế biến',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                              color: FoodHubColors.color0B0C0C,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          valueTime.toString() + ' min',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            color: FoodHubColors.color0B0C0C,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.maxFinite,
                      child: CupertinoSlider(
                        min: 0,
                        max: 120,
                        value: _value,
                        divisions: 12,
                        activeColor: FoodHubColors.colorFC6011,
                        thumbColor: FoodHubColors.colorFC6011,
                        onChanged: (value) {
                          setState(
                            () {
                              _value = value;
                              valueTime = _value.toInt();
                              if (value == 0) {
                                _timeToCook = true;
                              } else {
                                _timeToCook = false;
                              }
                            },
                          );
                        },
                        //label: "$_value",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Vùng ẩm thực',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<OriginModel>(
                            menuMaxHeight: 250,
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            isDense: true,
                            value: selectedOrigin,
                            onChanged: (newValue) {
                              setState(() {
                                selectedOrigin = newValue;
                              });
                            },
                            items: originList.map((OriginModel e) {
                              return DropdownMenuItem<OriginModel>(
                                value: e,
                                child: Text(
                                  e.originName.toString(),
                                  style: TextStyle(
                                    color: FoodHubColors.color0B0C0C,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.04,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Phương thức chế biến',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<MethodRecipeModel>(
                            menuMaxHeight: 250,
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            value: selectedMethod,
                            onChanged: (newValue) {
                              setState(() {
                                selectedMethod = newValue;
                              });
                            },
                            items: methodList.map((MethodRecipeModel e) {
                              return DropdownMenuItem<MethodRecipeModel>(
                                value: e,
                                child: Text(
                                  e.methodName.toString(),
                                  style: TextStyle(
                                    color: FoodHubColors.color0B0C0C,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                              );
                            }).toList(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Danh mục',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    ChipsChoice<RecipeCategoryModel>.multiple(
                      value: categorySelectedList,
                      onChanged: (val) =>
                          setState(() => categorySelectedList = val),
                      choiceItems: C2Choice.listFrom<RecipeCategoryModel,
                          RecipeCategoryModel>(
                        source: categoryList,
                        value: (i, v) => v,
                        label: (i, v) => v.categoryName,
                        tooltip: (i, v) => v.id,
                      ),
                      choiceActiveStyle: const C2ChoiceStyle(
                        showCheckmark: false,
                        color: Colors.white,
                        borderColor: Colors.orange,
                        backgroundColor: Colors.deepOrange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      choiceStyle: const C2ChoiceStyle(
                        showCheckmark: false,
                        color: Colors.deepOrange,
                        backgroundColor: Colors.white,
                        borderColor: Colors.deepOrange,
                        borderRadius:
                            BorderRadius.all(const Radius.circular(20)),
                      ),
                      wrapped: true,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.01,
                    ),
                    const Divider(
                      color: Colors.black26,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DefaultButton(
                          text: "THIẾT LẬP LẠI",
                          press: () {
                            setState(
                              () {
                                categorySelectedList.clear();
                                selectedOrigin = originList[0];
                                selectedMethod = methodList[0];
                                final bloc = context.read<RecipeAppBloc>();
                                bloc.add(RecipeApp(page, size, "", search, "",
                                    "", "", 500, 1));
                                Navigator.pop(context);
                              },
                            );
                          },
                          width: 200,
                        ),
                        DefaultButton(
                          text: "ÁP DỤNG",
                          press: () {
                            setState(() {
                              selectedMethodId = selectedMethod!.id;
                              selectedOriginId = selectedOrigin!.id;
                              categorySelectedList.clear();
                              if (categorySelectedList.isNotEmpty) {
                                for (var element in categorySelectedList) {
                                  category =
                                      category + "+" + element.id.toString();
                                }
                                selectedCategoryId = category.substring(1);
                              }
                              print("search:" + search);
                              print("1 " + _value.toInt().toString());
                              print("2 " + selectedOriginId);
                              print("3 " + selectedMethodId);
                              print("4 " + selectedCategoryId);
                              final bloc = context.read<RecipeAppBloc>();
                              bloc.add(RecipeApp(
                                  page,
                                  size,
                                  "",
                                  search,
                                  selectedCategoryId,
                                  selectedOriginId,
                                  selectedMethodId,
                                  _value.toInt(),
                                  1));
                            });
                            Navigator.pop(context);
                          },
                          width: 200,
                        ),
                      ],
                    ),
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
}
