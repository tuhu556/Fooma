import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/home/bloc/recipe_detail_app/recipe_detail_app_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/ingredient_detail/widgets/expanded_text.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/plan/models/card.dart';
import 'package:foodhub/widgets/detail_screen.dart';
import 'package:readmore/readmore.dart';

class RecipePlanDetailScreen extends StatefulWidget {
  const RecipePlanDetailScreen({Key? key}) : super(key: key);

  @override
  State<RecipePlanDetailScreen> createState() => _RecipePlanDetailScreenState();
}

class _RecipePlanDetailScreenState extends State<RecipePlanDetailScreen> {
  @override
  Widget build(BuildContext context) {
    String recipeId = "";
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    recipeId = args['recipeId'];
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => RecipeDetailAppBloc()..add(RecipeDetail(recipeId)),
      ),
      BlocProvider(
        create: (context) =>
            IngredientUserBloc()..add(const IngredientUser("", "", "", "")),
      ),
    ], child: const RecipePlanDetailView());
  }
}

class RecipePlanDetailView extends StatefulWidget {
  const RecipePlanDetailView({Key? key}) : super(key: key);

  @override
  State<RecipePlanDetailView> createState() => _RecipePlanDetailViewState();
}

class _RecipePlanDetailViewState extends State<RecipePlanDetailView> {
  CardModel? card;
  List<RecipeCategoryAppModel> categoryList = [];
  List<RecipeIngredientAppModel> ingredientList = [];
  List<RecipeMethodAppModel> methodList = [];
  List<RecipeMethodImagesAppModel> methodImageList = [];
  List<IngredientUserModel> userIngredientList = [];
  String recipeId = "";
  String imageUrl = "";
  String recipeName = "";
  String origin = "";
  String description = "";
  String cookingMethod = "";
  String selectedDate = "";
  int preparationTime = 0;
  int cookingTime = 0;
  int serves = 0;
  double calories = 0;
  double totalRatingPoint = 0;
  String? validationContent;
  TextEditingController _descriptionController = new TextEditingController();
  String titleOfReport = '';
  List<String?> report = [
    'Ảnh không phù hợp',
    'Ngôn từ đả kích/gây thù ghét',
    'Spam',
    'Nội dung sai sự thật',
    'Khác'
  ];
  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Blank_file.xcf/640px-Blank_file.xcf.png";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    selectedDate = args['selectedDate'];
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
              userIngredientList.clear();
              setState(
                () {
                  userIngredientList = state.ingredientUserResponse!.items;
                },
              );
            }
          },
        ),
        BlocListener<RecipeDetailAppBloc, RecipeDetailAppState>(
          listener: (context, state) {
            print(state.status);
            if (state.status == RecipeDetailStatus.Processing) {
              print("Processing");
            } else if (state.status == RecipeDetailStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: "),
                ),
              );
              print("Failed");
            } else if (state.status == RecipeDetailStatus.Success) {
              print("Success");

              setState(() {
                recipeId = state.recipeAppModel!.id;
                categoryList = state.recipeAppModel!.categoryModelList;
                ingredientList = state.recipeAppModel!.ingredientModelList;
                methodList = state.recipeAppModel!.methodList;
                imageUrl = state.recipeAppModel!.thumbnailImage;
                recipeName = state.recipeAppModel!.recipeName;
                origin = state.recipeAppModel!.originName;
                description = state.recipeAppModel!.description;
                cookingMethod = state.recipeAppModel!.cookingMethodName;
                preparationTime = state.recipeAppModel!.preparationTime;
                cookingTime = state.recipeAppModel!.cookingTime;
                serves = state.recipeAppModel!.serves;
                calories = state.recipeAppModel!.calories;
                totalRatingPoint = state.recipeAppModel!.totalRatingPoint;
                card = CardModel(recipeId, recipeName, imageUrl, cookingTime,
                    calories, serves, cookingMethod);
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: FoodHubColors.colorFFC5A8,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FoodHubColors.colorFFC5A8,
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
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FoodHubColors.colorFFFFFF,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).add(const EdgeInsets.only(top: 20)),
              child: BlocBuilder<RecipeDetailAppBloc, RecipeDetailAppState>(
                builder: (context, state) {
                  if (state.status == RecipeDetailStatus.Processing) {
                    return _buildLoading();
                  } else if (state.status == RecipeDetailStatus.Failed) {
                    return _buildFailed();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              highlightColor: FoodHubColors.colorFFFFFF,
                              splashColor: FoodHubColors.colorFFFFFF,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: FoodHubColors.colorFC6011,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: FoodHubColors.colorFFFFFF,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'Thêm công thức này',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: FoodHubColors.colorFFFFFF,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(Routes.plan,
                                    arguments: {
                                      "selectedDate": selectedDate,
                                      "card": card
                                    });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: FoodHubColors.colorFC6011,
                                        height: 20,
                                        width: 3,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        origin,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: FoodHubColors.colorFC6011),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    recipeName,
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: FoodHubColors.color0B0C0C),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 8,
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: FoodHubColors.colorFC6011,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailScreen(
                                      image: imageUrl,
                                    );
                                  }));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 10,
                          children: categoryList
                              .map((chip) => Chip(
                                    key: ValueKey(chip.recipeCategoryId),
                                    label: Text(
                                      chip.recipeCategoryName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: FoodHubColors.colorFC6011,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: FoodHubColors.colorF0F5F9),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                detailCooking(
                                    Icons.access_time_filled_rounded,
                                    "Thời gian chuẩn bị",
                                    preparationTime.toString() + " phút"),
                                detailCooking(Icons.timer, "Thời gian chế biến",
                                    cookingTime.toString() + " phút"),
                                detailCooking(
                                    Icons.outdoor_grill,
                                    "Phương thức chế biến",
                                    cookingMethod.toString()),
                                detailCooking(Icons.people, "Khẩu phần",
                                    serves.toString() + " người"),
                                detailCooking(Icons.whatshot, "Calories",
                                    calories.toString()),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Mô tả:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FoodHubColors.color0B0C0C,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ExpandableText(
                          description,
                        ),
                        Text(
                          'Nguyên liệu:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ingredientList.length,
                          itemBuilder: (context, index) {
                            return ingredientField(
                              ingredientList[index]
                                      .quantity
                                      .toInt()
                                      .toString() +
                                  " " +
                                  ingredientList[index].unit.toString(),
                              ingredientList[index].ingredientName.toString(),
                              ingredientList[index].recipeIngredientDBid,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Cách làm:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: methodList.length,
                          itemBuilder: (contex, index) {
                            return stepToCook(
                                methodList[index].imageList,
                                methodList[index].step.toString(),
                                methodList[index].content);
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                color: FoodHubColors.colorFC6011,
              ),
            ),
          ),
        ],
      );

  Widget _buildFailed() => const Center(
        child: Text("Lỗi! không ổn rồi"),
      );
  Widget stepToCook(List<RecipeMethodImagesAppModel> imageList, String step,
      String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: FoodHubColors.colorFC6011,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Bước " + step,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FoodHubColors.colorFFFFFF,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: imageList.length,
          itemBuilder: (contex, index) {
            return Column(
              children: [
                GestureDetector(
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageList[index].imageMethodUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return DetailScreen(
                            image: imageList[index].imageMethodUrl,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ReadMoreText(
          description,
          style: TextStyle(color: FoodHubColors.color0B0C0C, fontSize: 16),
          trimLines: 3,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Xem thêm',
          trimExpandedText: 'Thu gọn',
          moreStyle: TextStyle(fontSize: 15, color: FoodHubColors.colorFC6011),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget detailCooking(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title + ":",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }

  Widget ingredientField(String weight, String name, String id) {
    bool check = false;
    if (userIngredientList.length > 0) {
      for (var element in userIngredientList) {
        if (element.ingredientDbid == id) {
          check = true;
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                width: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                child: Icon(
                  Icons.circle,
                  size: 10,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                weight,
                style: TextStyle(
                  color: FoodHubColors.color0B0C0C,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              check
                  ? Text(
                      name,
                      style: TextStyle(
                        color: FoodHubColors.colorFC6011,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      name,
                      style: TextStyle(
                        color: FoodHubColors.color0B0C0C,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget textInputDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: Text(
            'Nội dung',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: FoodHubColors.color0B0C0C,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FoodHubColors.colorFFFFFF),
          child: TextFormField(
            style: TextStyle(color: FoodHubColors.color0B0C0C, fontSize: 16),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(15),
              counterText: "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorStyle: TextStyle(color: Colors.transparent, height: 0),
            ),
            controller: _descriptionController,
            validator: (value) {
              if (value!.isEmpty) {
                setState(() {
                  validationContent = "Vui lòng nhập nội dung";
                });
                return "Vui lòng nhập nội dung";
              } else {
                setState(() {
                  validationContent = "";
                });
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}
