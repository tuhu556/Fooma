import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/features/home/bloc/recipe_detail_app/recipe_detail_app_bloc.dart';
import 'package:foodhub/features/home/bloc/save_recipe/save_recipe_bloc.dart';
import 'package:foodhub/features/home/bloc/unsave_recipe/unsave_recipe_bloc.dart';
import 'package:foodhub/features/home/models/recipe_app_entity.dart';
import 'package:foodhub/features/ingredient_detail/widgets/expanded_text.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientUser/ingredient_user_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/social/bloc/interact_recipe_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:readmore/readmore.dart';

import '../../../constants/color.dart';
import '../../../helper/helper.dart';
import '../../../widgets/detail_screen.dart';
import '../../social/bloc/interact_post_bloc.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
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
      BlocProvider(
        create: (_) => InteractRecipeBloc(),
      ),
      BlocProvider(create: (_) => SaveRecipeBloc()),
      BlocProvider(create: (_) => UnsaveRecipeBloc()),
    ], child: const RecipeDetailAppView());
  }
}

class RecipeDetailAppView extends StatefulWidget {
  const RecipeDetailAppView({Key? key}) : super(key: key);

  @override
  State<RecipeDetailAppView> createState() => _RecipeDetailAppViewState();
}

class _RecipeDetailAppViewState extends State<RecipeDetailAppView> {
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
  int preparationTime = 0;
  int cookingTime = 0;
  int serves = 0;
  double calories = 0;
  double totalRatingPoint = 0;
  int totalRating = 0;
  bool isRated = true;
  bool isSaved = false;
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

  GlobalKey<FormState> _postForm = GlobalKey();
  @override
  void initState() {
    titleOfReport = 'Ảnh không phù hợp';
    imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Blank_file.xcf/640px-Blank_file.xcf.png";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            if (state.status == RecipeDetailStatus.Processing) {
            } else if (state.status == RecipeDetailStatus.Failed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Lỗi: "),
                ),
              );
            } else if (state.status == RecipeDetailStatus.Success) {
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
                totalRating = state.recipeAppModel!.totalRating;
                isRated = state.recipeAppModel!.isRated;
                isSaved = state.recipeAppModel!.isSaved;
              });
            }
          },
        ),
        BlocListener<InteractRecipeBloc, InteractRecipeState>(
          listener: (context, state) {
            if (state.status == InteractRecipeStatus.ReportRecipeProcessing) {
            } else if (state.status ==
                InteractRecipeStatus.ReportRecipeFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status ==
                InteractRecipeStatus.ReportRecipeSuccess) {
              setState(() {
                _descriptionController.clear();
                titleOfReport == report[0];
              });
              Navigator.pop(context);
              Helpers.shared.showDialogSuccess(context,
                  message: "Cảm ơn bạn đã gửi báo cáo",
                  subMessage:
                      "Chúng tôi sẽ xem xét báo cáo và thông báo cho bạn về quyết định của mình.");
            } else if (state.status ==
                InteractRecipeStatus.RatingRecipeProcessing) {
            } else if (state.status ==
                InteractRecipeStatus.RatingRecipeFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status ==
                InteractRecipeStatus.RatingRecipeSuccess) {
              // Navigator.pop(context);
              final bloc = context.read<RecipeDetailAppBloc>();
              bloc.add(RecipeDetail(recipeId));
              Helpers.shared.showDialogSuccess(
                context,
                message: "Cảm ơn bạn đã đánh giá công thức của chúng tôi",
              );
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isRated
                                ? Container()
                                : InkWell(
                                    child: const Icon(
                                      Icons.rate_review_rounded,
                                      size: 35,
                                    ),
                                    onTap: () {
                                      _showRatingDialog(recipeId, imageUrl);
                                    },
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.report_problem_rounded,
                                size: 35,
                              ),
                              onTap: () {
                                reportRecipe(context);
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: Icon(
                                isSaved
                                    ? Icons.turned_in
                                    : Icons.turned_in_not_outlined,
                                size: 38,
                                color: isSaved
                                    ? FoodHubColors.colorFC6011
                                    : Colors.black54,
                              ),
                              onTap: () {
                                const saveText = "Đã lưu công thức này";
                                const cancelText = "Bỏ lưu công thức này";

                                setState(
                                  () {
                                    if (isSaved == false) {
                                      final bloc =
                                          context.read<SaveRecipeBloc>();
                                      bloc.add(SaveRecipe(recipeId));
                                      isSaved = !isSaved;

                                      const snackBar = SnackBar(
                                        content: Text(saveText),
                                        duration: Duration(milliseconds: 500),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      final bloc =
                                          context.read<UnsaveRecipeBloc>();
                                      bloc.add(UnSaveRecipe(recipeId));
                                      isSaved = !isSaved;
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
                        const SizedBox(
                          height: 20,
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
                                  Row(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RatingStars(
                                        value: totalRatingPoint,
                                        starBuilder: (index, color) => Icon(
                                          Icons.star,
                                          color: color,
                                        ),
                                        starCount: 5,
                                        starSize: 20,
                                        maxValue: 5,
                                        starSpacing: 2,
                                        maxValueVisibility: false,
                                        valueLabelVisibility: false,
                                        animationDuration:
                                            const Duration(milliseconds: 1000),
                                        starColor: FoodHubColors.colorFC6011,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        totalRating.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: FoodHubColors.color0B0C0C),
                                      )
                                    ],
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
                                detailCooking(
                                    Icons.whatshot,
                                    "Calories",
                                    double.parse(calories.toString()) % 1 != 0
                                        ? calories.toString()
                                        : calories.toInt().toString()),
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
                              double.parse(ingredientList[index]
                                              .quantity
                                              .toString()) %
                                          1 !=
                                      0
                                  ? ingredientList[index].quantity.toString() +
                                      " " +
                                      ingredientList[index].unit.toString()
                                  : ingredientList[index]
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              text,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  void _showRatingDialog(String id, String imageUrl) {
    final _dialog = RatingDialog(
      initialRating: 0.0,
      title: Text(
        'Đánh giá công thức món ăn',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: FoodHubColors.color0B0C0C),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Hãy đánh giá công thức của chúng tôi!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: FoodHubColors.color0B0C0C),
      ),
      // your app's logo?
      image: Image.network(
        imageUrl,
        height: 200,
      ),

      submitButtonText: 'Gửi',
      commentHint: 'Viết đánh giá của bạn',
      showCloseButton: false,
      starColor: FoodHubColors.colorFC6011,
      submitButtonTextStyle: TextStyle(
          color: FoodHubColors.colorFC6011,
          fontWeight: FontWeight.bold,
          fontSize: 18),
      onSubmitted: (response) {
        final bloc = context.read<InteractRecipeBloc>();
        bloc.add(RatingRecipe(
            recipeId, response.rating.toInt(), _descriptionController.text));
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  void reportRecipe(BuildContext context2) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorF0F5F9,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter mystate) {
          return KeyboardDismisser(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _postForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Báo cáo công thức",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FoodHubColors.color0B0C0C,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: FoodHubColors.colorFFFFFF),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownButton(
                                dropdownColor: FoodHubColors.colorFFFFFF,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: FoodHubColors.color0B0C0C,
                                ),
                                isExpanded: true,
                                value: titleOfReport,
                                onChanged: (newValue) {
                                  mystate(() {
                                    titleOfReport = newValue.toString();
                                  });
                                },
                                items: report.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
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
                        const SizedBox(
                          height: 20,
                        ),
                        textInputDescription(mystate),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: FoodHubColors.colorFC6011,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              if (_postForm.currentState!.validate()) {
                                final bloc =
                                    context2.read<InteractRecipeBloc>();
                                bloc.add(ReportRecipe(recipeId, titleOfReport,
                                    _descriptionController.text));
                              }
                            },
                            child: Text(
                              "GỬI",
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.colorFFFFFF,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
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
                padding: EdgeInsets.only(top: 20, bottom: 3),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: FoodHubColors.color0B0C0C,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  check
                      ? SvgPicture.asset(
                          "assets/icons/tick.svg",
                          color: FoodHubColors.colorFC6011,
                          height: 17,
                          width: 17,
                        )
                      : Container(),
                ],
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

  Widget textInputDescription(mystate) {
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
                mystate(() {
                  validationContent = "Vui lòng nhập nội dung";
                });
                return "Vui lòng nhập nội dung";
              } else {
                mystate(() {
                  validationContent = "";
                });
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, top: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              validationContent ?? "",
              style: TextStyle(color: FoodHubColors.colorCC0000, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
