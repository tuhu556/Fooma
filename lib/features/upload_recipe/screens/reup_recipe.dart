import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:foodhub/config/cloudinary.dart';
import 'package:foodhub/features/social/models/recipe_entity.dart';
import 'package:foodhub/features/upload_recipe/bloc/edit_recipe_bloc.dart';

import 'package:foodhub/features/upload_recipe/bloc/option_recipe_bloc.dart';
import 'package:foodhub/features/upload_recipe/bloc/upload_recipe_bloc.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_meal_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_origin_entity.dart';
import 'package:foodhub/features/upload_recipe/models/recipe_process_entity.dart';
import 'package:foodhub/features/upload_recipe/models/upload_recipe_entity.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../constants/color.dart';
import '../../../widgets/detail_screen.dart';
import '../../ingredient_manager/bloc/ingredientData/ingredient_data_bloc.dart';
import '../../ingredient_manager/models/ingredient_data_entity.dart';
import '../../social/bloc/interact_recipe_bloc.dart';
import '../../social/models/method_recipe_entity.dart';

class ReupRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  final int? index;
  final Function(int)? onTap;
  const ReupRecipeScreen({Key? key, this.recipe, this.index, this.onTap})
      : super(key: key);

  @override
  _ReupRecipeScreenState createState() => _ReupRecipeScreenState();
}

class _ReupRecipeScreenState extends State<ReupRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UploadRecipeBloc(),
        ),
        BlocProvider(
            create: (_) => OptionRecipeBloc()
              ..add(const RecipeOrigins())
              ..add(const RecipeMeals())
              ..add(const RecipeProcesss())
              ..add(const IngredientDB())),
        BlocProvider(
          create: (_) => IngredientDataBloc()..add(const IngredientData(10000)),
        ),
        BlocProvider(
          create: (_) => InteractRecipeBloc()
            ..add(
              GetMethodRecipe(widget.recipe!.id),
            ),
        ),
        BlocProvider(
          create: (_) => EditMyRecipeBloc(),
        ),
      ],
      child: UploadRecipeView(
        recipe: widget.recipe!,
        onTap: widget.onTap,
        index: widget.index!,
      ),
    );
  }
}

class UploadRecipeView extends StatefulWidget {
  final Recipe recipe;
  final String? timeAgo;
  final int? index;
  final Function(int)? onTap;
  const UploadRecipeView(
      {Key? key, required this.recipe, this.timeAgo, this.index, this.onTap})
      : super(key: key);

  @override
  State<UploadRecipeView> createState() => _UploadRecipeViewState();
}

class _UploadRecipeViewState extends State<UploadRecipeView> {
  String? validationContent;
  double _value = 0;
  List<String?> ingredients = [];
  List<String?> step = [];
  List<String?> ingredient = [];

  final GlobalKey<FormState> _addRecipeKeyForm = GlobalKey();
  final TextEditingController _nameRecipeController =
      new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _servesController = new TextEditingController();
  final TextEditingController _caloriesController = new TextEditingController();

  final List<TextEditingController> _nameOfIngredientController = [];
  final List<TextEditingController> _quantityController = [];
  final List<TextEditingController> _unitController = [];
  final List<TextEditingController> _contentStepController = [];

  bool _image = false;
  bool _timeToCook = false;
  bool _chooseQuantity = false;
  bool _quantity = false;
  final bool _description = false;
  bool _checkIngredient = false;
  bool _checkStep = false;
  bool _checkNameOfMeal = false;
  bool isLoading = false;
  String nameOfOrigin = '';
  List<String?> listOrigin = [];
  List<String> nameOfMeal = [];
  List<String?> listMeal = [];
  String nameOfProcess = '';
  List<String?> listProcess = [];

  // int choiceNum = 0;

  final List<bool> _checkedValue = [];

  List<int> choiceNum = [];

  File? imageFile;
  File? imageFileStep;
  final picker = ImagePicker();
  String urlImg = '';
  String url = '';
  String urlStep = '';

  List<String> urlImageStep = [];
  List<bool> imageStep = [];
  List<bool> content = [];
  List<bool> chooseUnit = [false];

  List<RecipeIngredients> recipeIngredients = [];
  List<RecipeMethods> recipeMethods = [];
  List<RecipeMethodImages> recipeMethodImages = [];
  List<String> ingredientDbid = [];
  List<IngredientDataModel> listIngredientData = [];

  List<RecipeOrigin> recipeOrigin = [];
  List<RecipeProcess> recipeProcess = [];
  List<RecipeMeal> recipeMeal = [];
  List<Method> methodRecipe = [];
  // chooseImage(ImageSource src) async {
  //   final pickedFile = await picker.pickImage(source: src);
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  //   Navigator.pop(context);
  //   var storageImg;
  //   try {
  //     print(imageFile!.path);
  //     storageImg = FirebaseStorage.instance.ref().child(imageFile!.path);
  //     var task = storageImg.putFile(imageFile!);
  //     url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
  //     if (url != '') {
  //       setState(() {
  //         urlImg = url;
  //         _image = false;
  //         print(urlImg);
  //       });
  //     } else {
  //       setState(() {
  //         _image = true;
  //       });
  //     }
  //     setState(() {
  //       imageFile = null;
  //     });
  //   } catch (e) {}
  //   setState(() {
  //     url = '';
  //   });
  // }

  // chooseImageStep(ImageSource src, int index) async {
  //   final pickedFile = await picker.pickImage(source: src);
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFileStep = File(pickedFile.path);
  //     });
  //   }
  //   Navigator.pop(context);
  //   var storageImg;
  //   try {
  //     print(imageFileStep!.path);
  //     storageImg = FirebaseStorage.instance.ref().child(imageFileStep!.path);
  //     var task = storageImg.putFile(imageFileStep!);
  //     urlStep =
  //         await (await task.whenComplete(() => null)).ref.getDownloadURL();
  //     if (urlStep != '') {
  //       setState(() {
  //         urlImageStep[index] = urlStep;
  //         imageStep[index] = false;
  //       });
  //     } else {
  //       setState(() {
  //         imageStep[index] = true;
  //       });
  //     }
  //     setState(() {
  //       imageFileStep = null;
  //     });
  //   } catch (e) {}
  //   setState(() {
  //     urlStep = '';
  //   });
  // }
  Future<void> chooseImage(ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: src);

    final image = Image.network(pickedImage!.path);

    print("image is $image");
    setState(() {
      isLoading = true;
    });
    Navigator.pop(context);
    final cloudinary = Cloudinary.full(
      apiKey: CoudinaryFull.shared.apiKey,
      apiSecret: CoudinaryFull.shared.apiSecret,
      cloudName: CoudinaryFull.shared.cloudName,
    );

    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: pickedImage.path,
        fileBytes: await pickedImage.readAsBytes(),
        resourceType: CloudinaryResourceType.image,
        folder: "Fooma",
        fileName: pickedImage.name,
        progressCallback: (count, total) {
          setState(() {
            isLoading = true;
          });
        },
      ),
    );
    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
      setState(() {
        urlImg = response.secureUrl!;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload image Failed!"),
          ),
        );
      });
    }
  }

  Future<void> chooseImageStep(ImageSource src, int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: src);
    final imageFileStep = Image.network(pickedImage!.path);
    setState(() {
      isLoading = true;
    });
    Navigator.pop(context);
    final cloudinary = Cloudinary.full(
      apiKey: CoudinaryFull.shared.apiKey,
      apiSecret: CoudinaryFull.shared.apiSecret,
      cloudName: CoudinaryFull.shared.cloudName,
    );
    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: pickedImage.path,
        fileBytes: await pickedImage.readAsBytes(),
        resourceType: CloudinaryResourceType.image,
        folder: "Fooma",
        fileName: pickedImage.name,
        progressCallback: (count, total) {
          setState(() {
            isLoading = true;
          });
        },
      ),
    );
    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
      setState(() {
        urlStep = response.secureUrl!;
        urlImageStep[index] = urlStep;
        isLoading = false;
        imageStep[index] = false;
      });
    } else {
      setState(() {
        isLoading = true;
        imageStep[index] = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload image Failed!"),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    setState(() {
      urlImg = widget.recipe.thumbnail;
      nameOfOrigin = widget.recipe.originName;
      _nameRecipeController.text = widget.recipe.recipeName.trim();
      _descriptionController.text = widget.recipe.description.trim();
      nameOfProcess = widget.recipe.cookingMethodName;

      _value = double.parse(widget.recipe.cookingTime.toString().trim());
      _servesController.text = widget.recipe.serves.toString().trim();
      _caloriesController.text = widget.recipe.calories.toString().trim();
    });
    for (int i = 0; i < widget.recipe.manyToManyRecipeCategories.length; i++) {
      setState(() {
        nameOfMeal.add(widget
            .recipe.manyToManyRecipeCategories[i].recipeCategoryName
            .trim());
      });
    }

    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      setState(() {
        ingredient.add('');
      });
    }
    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      setState(() {
        ingredientDbid.add(widget.recipe.ingredient[i].ingredientDbid);
      });
    }
    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      setState(() {
        _nameOfIngredientController.add(TextEditingController());
        _nameOfIngredientController[i].text =
            widget.recipe.ingredient[i].ingredientName.trim();
      });
    }
    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      setState(() {
        _quantityController.add(TextEditingController());
        _quantityController[i].text =
            widget.recipe.ingredient[i].quantity.toString().trim();
      });
    }
    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      setState(() {
        _unitController.add(TextEditingController());
        _unitController[i].text =
            widget.recipe.ingredient[i].unit.toString().trim();
      });
    }

    for (int i = 0; i < widget.recipe.ingredient.length; i++) {
      choiceNum.add(9);
      setState(() {
        choiceNum[i] = widget.recipe.ingredient[i].unit.toLowerCase().trim() ==
                "Gói".toLowerCase()
            ? 1
            : widget.recipe.ingredient[i].unit.toLowerCase().trim() ==
                    "Hộp".toLowerCase()
                ? 2
                : widget.recipe.ingredient[i].unit.toLowerCase().trim() ==
                        'Muỗng'.toLowerCase()
                    ? 3
                    : widget.recipe.ingredient[i].unit.toLowerCase().trim() ==
                            "Kg".toLowerCase()
                        ? 4
                        : widget.recipe.ingredient[i].unit
                                    .toLowerCase()
                                    .trim() ==
                                "Gram".toLowerCase()
                            ? 5
                            : widget.recipe.ingredient[i].unit
                                        .toLowerCase()
                                        .trim() ==
                                    "L".toLowerCase()
                                ? 6
                                : widget.recipe.ingredient[i].unit
                                            .toLowerCase()
                                            .trim() ==
                                        "mL".toLowerCase()
                                    ? 7
                                    : 8;
      });
    }
    for (var i in widget.recipe.ingredient) {
      setState(() {
        chooseUnit.add(false);
      });
    }
    for (var i in widget.recipe.ingredient) {
      setState(() {
        _checkedValue.add(i.isMain);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InteractRecipeBloc, InteractRecipeState>(
            listener: (context, state) {
          if (state.status == InteractRecipeStatus.DeleteProcessing) {
          } else if (state.status == InteractRecipeStatus.DeleteFailed) {
            Helpers.shared
                .showDialogError(context, message: state.error!.message);
          } else if (state.status == InteractRecipeStatus.DeleteSuccess) {
            if (widget.index != 987456123) {
              widget.onTap!(widget.index!);
            }
          }
        }),
        BlocListener<UploadRecipeBloc, UploadRecipeState>(
          listener: (context, state) {
            if (state.status == UploadRecipeStatus.Processing) {
            } else if (state.status == UploadRecipeStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == UploadRecipeStatus.Success) {
              final bloc = context.read<InteractRecipeBloc>();
              bloc.add(DeleteMyRecipe(id: widget.recipe.id));
              Helpers.shared.showDialogSuccess(
                context,
                message: "Thêm công thức thành công",
                okFunction: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            }
          },
        ),
        BlocListener<OptionRecipeBloc, OptionRecipeState>(
          listener: (context, state) {
            if (state.status == OptionRecipeStatus.Processing) {
            } else if (state.status == OptionRecipeStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == OptionRecipeStatus.Success) {
              setState(() {
                recipeOrigin = state.recipeOrigin!.recipeOrigin;
              });
              for (var i in state.recipeOrigin!.recipeOrigin) {
                if (i.originName == "Việt Nam") {
                  setState(() {
                    nameOfOrigin = i.originName;
                  });
                }
                setState(() {
                  listOrigin.add(i.originName);
                });
              }
            } else if (state.status == OptionRecipeStatus.MealProcessing) {
            } else if (state.status == OptionRecipeStatus.MealFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == OptionRecipeStatus.MealSuccess) {
              setState(() {
                recipeMeal = state.recipeMeal!.recipeMeal;
              });
              for (var i in state.recipeMeal!.recipeMeal) {
                setState(() {
                  listMeal.add(i.recipeCategoryName);
                });
              }
            } else if (state.status == OptionRecipeStatus.ProcessProcessing) {
            } else if (state.status == OptionRecipeStatus.ProcessFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == OptionRecipeStatus.ProcessSuccess) {
              setState(() {
                recipeProcess = state.recipeProcess!.recipeProcess;
              });
              for (var i in state.recipeProcess!.recipeProcess) {
                setState(() {
                  listProcess.add(i.cookingMethodName);
                });
              }
            } else if (state.status ==
                OptionRecipeStatus.IngredientProcessing) {
            } else if (state.status == OptionRecipeStatus.IngredientFailed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == OptionRecipeStatus.IngredientSuccess) {}
          },
        ),
        BlocListener<IngredientDataBloc, IngredientDataState>(
          listener: (context, state) {
            if (state.status == IngredientDataStatus.Processing) {
            } else if (state.status == IngredientDataStatus.Failed) {
            } else if (state.status == IngredientDataStatus.Success) {
              listIngredientData.clear();
              setState(() {
                listIngredientData = state.ingredientResponse!.data;
              });
            }
          },
        ),
        BlocListener<InteractRecipeBloc, InteractRecipeState>(
            listener: (context, state) {
          if (state.status == InteractRecipeStatus.MethodRecipeProcessing) {
          } else if (state.status == InteractRecipeStatus.MethodRecipeFailed) {
            Helpers.shared
                .showDialogError(context, message: state.error!.message);
          } else if (state.status == InteractRecipeStatus.MethodRecipeSuccess) {
            for (int i = 0; i < state.methodRecipe!.method.length; i++) {
              setState(() {
                methodRecipe.add(state.methodRecipe!.method[i]);
              });
            }

            for (int i = 0; i < methodRecipe.length; i++) {
              setState(() {
                step.add("");
              });
            }

            for (int i = 0; i < methodRecipe.length; i++) {
              setState(() {
                urlImageStep
                    .add(methodRecipe[i].recipeMethodImages[0].imageUrl);
              });
            }

            for (int i = 0; i < methodRecipe.length; i++) {
              setState(() {
                imageStep.add(false);
              });
            }
            for (int i = 0; i < methodRecipe.length; i++) {
              setState(() {
                _contentStepController.add(TextEditingController());
                _contentStepController[i].text = methodRecipe[i].content.trim();
              });
            }
            for (int i = 0; i < methodRecipe.length; i++) {
              setState(() {
                content.add(false);
              });
            }
          }
        }),
        BlocListener<EditMyRecipeBloc, EditMyRecipeState>(
          listener: (context, state) async {
            if (state.status == EditMyRecipeStatus.Processing) {
            } else if (state.status == EditMyRecipeStatus.Failed) {
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == EditMyRecipeStatus.Success) {
              Helpers.shared.showDialogSuccess(context,
                  message: "Sửa đổi công thức thành công", okFunction: () {
                Navigator.pop(context);
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
            "Đăng lại công thức",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: FoodHubColors.color0B0C0C),
          ),
        ),
        body: KeyboardDismisser(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Form(
                key: _addRecipeKeyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    urlImg == ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.22,
                              child: GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/images/upload.svg',
                                  fit: BoxFit.fill,
                                ),
                                onTap: () {
                                  updateImage(context);
                                },
                              ),
                            ),
                          )
                        : Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        20), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          150), // Image radius
                                      child: Image.network(urlImg,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return DetailScreen(
                                        image: urlImg,
                                      );
                                    }));
                                  },
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    child: Opacity(
                                        opacity: 0.5,
                                        child: ClipOval(
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color:
                                                    FoodHubColors.color0B0C0C),
                                            child: Center(
                                                child: SvgPicture.asset(
                                              'assets/icons/multi.svg',
                                              width: 17,
                                              height: 17,
                                              color: FoodHubColors.colorFFFFFF,
                                            )),
                                          ),
                                        )),
                                    onTap: () {
                                      Helpers.shared.showDialogConfirm(context,
                                          message:
                                              "Bạn có muốn xóa ảnh này không?",
                                          okFunction: () {
                                        setState(() {
                                          urlImg = '';
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Visibility(
                      visible: _image,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng thêm hình ảnh nguyên liệu",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Nguồn gốc',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton(
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            value: nameOfOrigin,
                            onChanged: (newValue) {
                              setState(() {
                                nameOfOrigin = newValue.toString();
                              });
                            },
                            items: listOrigin.map((e) {
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
                    Helpers.shared.textFieldNameOfRecipe(context,
                        controllerText: _nameRecipeController),
                    const SizedBox(
                      height: 20,
                    ),
                    textInputDescription(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          validationContent ?? "",
                          style: TextStyle(
                              color: FoodHubColors.colorCC0000, fontSize: 14),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Danh mục công thức',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: FoodHubColors.colorFFFFFF,
                          borderRadius: BorderRadius.circular(10)),
                      child: MultiSelectDialogField(
                        initialValue: nameOfMeal,
                        cancelText: Text(
                          "HUỶ",
                          style: TextStyle(
                              color: FoodHubColors.colorDD323A,
                              fontWeight: FontWeight.bold),
                        ),
                        confirmText: const Text(
                          "XÁC NHẬN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        selectedColor: FoodHubColors.colorFC6011,
                        selectedItemsTextStyle:
                            TextStyle(color: FoodHubColors.colorFFFFFF),
                        backgroundColor: FoodHubColors.colorFFFFFF,
                        title: Text(
                          'Chọn danh mục',
                          style: TextStyle(color: FoodHubColors.color0B0C0C),
                        ),
                        buttonIcon: Icon(
                          Icons.subdirectory_arrow_left_sharp,
                          color: FoodHubColors.color0B0C0C,
                        ),
                        buttonText: Text(
                          'Chọn danh mục cho công thức',
                          style: TextStyle(
                              fontSize: 17, color: FoodHubColors.color0B0C0C),
                        ),
                        items: listMeal
                            .map((e) => MultiSelectItem(e, e!))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          setState(() {
                            nameOfMeal.clear();
                          });
                          for (var k = 0; k < values.length; k++) {
                            setState(() {
                              nameOfMeal.add(values[k].toString());
                            });
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: _checkNameOfMeal,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng chọn bữa ăn",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Phương thức chế biến',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton(
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            value: nameOfProcess,
                            onChanged: (newValue) {
                              setState(() {
                                nameOfProcess = newValue.toString();
                              });
                            },
                            items: listProcess.map((e) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Thời gian chế biến',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: FoodHubColors.color0B0C0C,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          _value.toInt().toString() + ' min',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            color: FoodHubColors.color0B0C0C,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: CupertinoSlider(
                        min: 0,
                        max: 120,
                        value: _value,
                        divisions: 120,
                        activeColor: FoodHubColors.colorFC6011,
                        thumbColor: FoodHubColors.colorFC6011,
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                            if (value == 0) {
                              _timeToCook = true;
                            } else {
                              _timeToCook = false;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: _timeToCook,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng chọn thời gian hoàn thành món ăn",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Helpers.shared.textFieldServes(
                      context,
                      controllerText: _servesController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Helpers.shared.textFieldCalories(
                    //   context,
                    //   controllerText: _caloriesController,
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Nguyên liệu',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: FoodHubColors.color0B0C0C,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            color: FoodHubColors.colorFFFFFF,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nguyên liệu ' + (index + 1).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: FoodHubColors.color0B0C0C,
                                    ),
                                  ),
                                  InkWell(
                                    child: SvgPicture.asset(
                                        'assets/icons/delete.svg'),
                                    onTap: () {
                                      setState(() {
                                        ingredient.removeAt(index);
                                        ingredientDbid.removeAt(index);
                                        _nameOfIngredientController
                                            .removeAt(index);
                                        _quantityController.removeAt(index);
                                        _unitController.removeAt(index);
                                        choiceNum.removeAt(index);
                                        chooseUnit.removeAt(index);
                                        _checkedValue.removeAt(index);
                                      });
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TypeAheadFormField<IngredientDataModel?>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller:
                                        _nameOfIngredientController[index],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: FoodHubColors.colorFFFFFF),
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: FoodHubColors.colorFFFFFF),
                                      ),
                                      fillColor: FoodHubColors.colorE1E4E8
                                          .withOpacity(0.3),
                                      filled: true,
                                    ),
                                  ),
                                  suggestionsBoxDecoration:
                                      const SuggestionsBoxDecoration(
                                    color: Colors.white,
                                    elevation: 4.0,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  debounceDuration:
                                      const Duration(milliseconds: 400),
                                  onSuggestionSelected:
                                      (IngredientDataModel? suggestion) {
                                    setState(() {
                                      _nameOfIngredientController[index].text =
                                          suggestion!.ingredientName;
                                      ingredientDbid[index] = suggestion.id;
                                    });
                                  },
                                  validator: (value) =>
                                      value != null && value.isEmpty
                                          ? 'Vui lòng điền tên thực phẩm'
                                          : null,
                                  //onSaved: (value) => selectedCity = value,
                                  getImmediateSuggestions: true,
                                  suggestionsCallback: IngredientService
                                      .getIngredientSuggestions,
                                  itemBuilder: (context,
                                      IngredientDataModel? suggestion) {
                                    final ingredient = suggestion!;
                                    return ListTile(
                                      title: Text(ingredient.ingredientName),
                                    );
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  'Đơn vị',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.color0B0C0C,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 15,
                                runSpacing: 15,
                                children: [
                                  chipSelect('Gói', 1, index),
                                  chipSelect('Hộp', 2, index),
                                  chipSelect('Muỗng', 3, index),
                                  chipSelect('Kg', 4, index),
                                  chipSelect('Gram', 5, index),
                                  chipSelect('L', 6, index),
                                  chipSelect('mL', 7, index),
                                  chipSelect('Khác', 8, index),
                                ],
                              ),
                              choiceNum[index] == 8
                                  ? Helpers.shared.textFieldUnit(context,
                                      controllerText: _unitController[index],
                                      colorBox: FoodHubColors.colorE1E4E8
                                          .withOpacity(0.3))
                                  : Container(),
                              Visibility(
                                visible: chooseUnit[index],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Vui lòng chọn đơn vị nguyên liệu",
                                      style: TextStyle(
                                          color: FoodHubColors.colorCC0000,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Helpers.shared.textFieldQuantity(context,
                                  controllerText: _quantityController[index],
                                  colorBox: FoodHubColors.colorE1E4E8
                                      .withOpacity(0.3)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    checkColor: FoodHubColors.colorFFFFFF,
                                    activeColor: FoodHubColors.colorFC6011,
                                    value: _checkedValue[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _checkedValue[index] = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Nguyên liệu chính",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: FoodHubColors.color0B0C0C),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: ingredient.length,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: FoodHubColors.colorFC6011,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Thêm nguyên liệu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.colorFC6011,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              ingredient.add('');
                              ingredientDbid.add('');
                              _nameOfIngredientController
                                  .add(TextEditingController());
                              _quantityController.add(TextEditingController());
                              _unitController.add(TextEditingController());
                              choiceNum.add(9);
                              chooseUnit.add(false);
                              _checkedValue.add(false);
                            });
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _checkIngredient,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng thêm nguyên liệu",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Bước chế biến',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: FoodHubColors.color0B0C0C,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            color: FoodHubColors.colorFFFFFF,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bước ' + (index + 1).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: FoodHubColors.color0B0C0C,
                                    ),
                                  ),
                                  InkWell(
                                    child: SvgPicture.asset(
                                        'assets/icons/delete.svg'),
                                    onTap: () {
                                      setState(() {
                                        step.removeAt(index);
                                        urlImageStep.removeAt(index);
                                        imageStep.removeAt(index);
                                        _contentStepController.removeAt(index);
                                        content.removeAt(index);
                                      });
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              urlImageStep[index] == ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.22,
                                        child: GestureDetector(
                                          child: SvgPicture.asset(
                                            'assets/images/upload.svg',
                                            fit: BoxFit.fill,
                                          ),
                                          onTap: () {
                                            updateImageStep(context, index);
                                          },
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Image border
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(
                                                    100), // Image radius
                                                child: Image.network(
                                                    urlImageStep[index],
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return DetailScreen(
                                                  image: urlImageStep[index],
                                                );
                                              }));
                                            },
                                          ),
                                          Positioned(
                                              top: 10,
                                              right: 10,
                                              child: InkWell(
                                                child: Opacity(
                                                    opacity: 0.5,
                                                    child: ClipOval(
                                                      child: Container(
                                                        height: 25,
                                                        width: 25,
                                                        decoration: BoxDecoration(
                                                            color: FoodHubColors
                                                                .color0B0C0C),
                                                        child: Center(
                                                            child: SvgPicture
                                                                .asset(
                                                          'assets/icons/multi.svg',
                                                          width: 17,
                                                          height: 17,
                                                          color: FoodHubColors
                                                              .colorFFFFFF,
                                                        )),
                                                      ),
                                                    )),
                                                onTap: () {
                                                  Helpers.shared.showDialogConfirm(
                                                      context,
                                                      message:
                                                          "Bạn có muốn xóa ảnh này không?",
                                                      okFunction: () {
                                                    setState(() {
                                                      urlImageStep[index] = '';
                                                      imageStep[index] = false;
                                                    });
                                                  });
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                              Visibility(
                                visible: imageStep[index],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Vui lòng thêm hình ảnh",
                                      style: TextStyle(
                                          color: FoodHubColors.colorCC0000,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  'Mô tả',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: FoodHubColors.color0B0C0C),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              textInputDescriptionByStep(index),
                              Visibility(
                                visible: content[index],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Vui lòng nhập mô tả bước " +
                                          (index + 1).toString(),
                                      style: TextStyle(
                                          color: FoodHubColors.colorCC0000,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: step.length,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: FoodHubColors.colorFC6011,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Thêm bước mới',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.colorFC6011,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              step.add('');
                              _contentStepController
                                  .add(TextEditingController());
                              urlImageStep.add('');
                              imageStep.add(false);
                              content.add(false);
                            });
                          },
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _checkStep,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vui lòng thêm bước chế biến",
                            style: TextStyle(
                                color: FoodHubColors.colorCC0000,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: FoodHubColors.colorFC6011,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              setState(() {
                                if (urlImg != '') {
                                  _image = false;
                                } else {
                                  _image = true;
                                }
                                if (_value == 0) {
                                  _timeToCook = true;
                                } else {
                                  _timeToCook = false;
                                }
                                if (_chooseQuantity == false) {
                                  setState(() {
                                    _quantity = true;
                                  });
                                } else {
                                  setState(() {
                                    _quantity = false;
                                  });
                                }
                                bool _checkImgStep = true;
                                if (step.length > 0) {
                                  for (int i = 0;
                                      i < urlImageStep.length;
                                      i++) {
                                    if (urlImageStep[i] == '') {
                                      imageStep[i] = true;
                                      setState(() {
                                        _checkImgStep = false;
                                      });
                                    }
                                  }
                                  setState(() {
                                    _checkStep = false;
                                  });
                                } else {
                                  setState(() {
                                    _checkStep = true;
                                  });
                                }

                                for (int i = 0;
                                    i < _contentStepController.length;
                                    i++) {
                                  if (_contentStepController[i].text.trim() ==
                                      '') {
                                    content[i] = true;
                                  } else {
                                    content[i] = false;
                                  }
                                }

                                if (ingredient.length > 0) {
                                  for (int i = 0; i < choiceNum.length; i++) {
                                    if (choiceNum[i] == 5) {
                                      chooseUnit[i] = true;
                                    } else {
                                      chooseUnit[i] = false;
                                    }
                                  }
                                  setState(() {
                                    _checkIngredient = false;
                                  });
                                } else {
                                  setState(() {
                                    _checkIngredient = true;
                                  });
                                }

                                List<RecipeCategoriesAdd> recipeMealId = [];
                                List<ManyToManyRecipeNutritions>
                                    manyToManyRecipeNutritions = [];

                                for (int i = 0; i < recipeMeal.length; i++) {
                                  if (nameOfMeal.isNotEmpty) {
                                    for (int j = 0;
                                        j < nameOfMeal.length;
                                        j++) {
                                      if (recipeMeal[i]
                                              .recipeCategoryName
                                              .trim() ==
                                          nameOfMeal[j].trim()) {
                                        setState(() {
                                          recipeMealId.add(RecipeCategoriesAdd(
                                              recipeMeal[i].id));
                                        });
                                      }
                                    }
                                    setState(() {
                                      _checkNameOfMeal = false;
                                    });
                                  } else {
                                    setState(() {
                                      _checkNameOfMeal = true;
                                    });
                                  }
                                }

                                if (_addRecipeKeyForm.currentState!
                                    .validate()) {
                                  for (int i = 0;
                                      i < _nameOfIngredientController.length;
                                      i++) {
                                    recipeIngredients.add(
                                      RecipeIngredients(
                                        ingredientDbid[i],
                                        _nameOfIngredientController[i]
                                            .text
                                            .trim(),
                                        _unitController[i].text.trim(),
                                        double.parse(
                                            _quantityController[i].text.trim()),
                                        _checkedValue[i],
                                      ),
                                    );
                                  }
                                  for (int i = 0;
                                      i < _contentStepController.length;
                                      i++) {
                                    recipeMethods.add(
                                      RecipeMethods(
                                        i + 1,
                                        _contentStepController[i].text.trim(),
                                        [
                                          RecipeMethodImages(0, urlImageStep[i])
                                        ],
                                      ),
                                    );
                                  }
                                  String orginId = '';
                                  for (int i = 0;
                                      i < recipeOrigin.length;
                                      i++) {
                                    if (nameOfOrigin.trim() ==
                                        recipeOrigin[i].originName.trim()) {
                                      setState(() {
                                        orginId = recipeOrigin[i].id;
                                      });
                                      break;
                                    }
                                  }
                                  String cookingMethodId = '';
                                  for (int i = 0;
                                      i < recipeProcess.length;
                                      i++) {
                                    if (nameOfProcess.trim() ==
                                        recipeProcess[i]
                                            .cookingMethodName
                                            .trim()) {
                                      setState(() {
                                        cookingMethodId = recipeProcess[i].id;
                                      });
                                      break;
                                    }
                                  }

                                  if (!_checkIngredient &&
                                      !_checkNameOfMeal &&
                                      !_checkStep &&
                                      !_image &&
                                      !_timeToCook &&
                                      _checkImgStep) {
                                    final bloc =
                                        context.read<UploadRecipeBloc>();
                                    bloc.add(
                                      UploadRecipe(
                                        originId: orginId,
                                        cookingMethodId: cookingMethodId,
                                        recipeName:
                                            _nameRecipeController.text.trim(),
                                        description:
                                            _descriptionController.text.trim(),
                                        preparationTime: _value.toInt(),
                                        cookingTime: _value.toInt(),
                                        serves: int.parse(
                                            _servesController.text.trim()),
                                        calories: _caloriesController.text ==
                                                    "" ||
                                                _caloriesController.text.isEmpty
                                            ? 0
                                            : double.parse(_caloriesController
                                                .text
                                                .trim()),
                                        hashtag: "String",
                                        manyToManyRecipeCategories:
                                            recipeMealId,
                                        manyToManyRecipeNutritions:
                                            manyToManyRecipeNutritions,
                                        recipeImages: [
                                          RecipeImages(0, urlImg, true)
                                        ],
                                        recipeIngredients: recipeIngredients,
                                        recipeMethods: recipeMethods,
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                            child: Text(
                              "ĐĂNG",
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.colorFFFFFF,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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

  Widget chipSelect(String chipName, int choice, int index) {
    return InkWell(
      child: Container(
        width: 80,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: FoodHubColors.colorE1E4E8.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: choice != choiceNum
                    ? FoodHubColors.colorE1E4E8.withOpacity(0.3)
                    : FoodHubColors.colorFC6011)),
        child: choice != choiceNum[index]
            ? Opacity(
                opacity: 0.7,
                child: Text(
                  chipName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: FoodHubColors.color0B0C0C,
                  ),
                ),
              )
            : Text(
                chipName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: choice != choiceNum[index]
                      ? FoodHubColors.color0B0C0C
                      : FoodHubColors.colorFC6011,
                ),
              ),
      ),
      onTap: () {
        setState(() {
          choiceNum[index] = choice;
          _chooseQuantity = true;
          chooseUnit[index] == false;
          if (choice != 8) {
            _unitController[index].text = chipName;
          } else {
            _unitController[index].clear();
          }
        });
      },
    );
  }

  Widget textInputDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: Text(
            'Mô tả',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
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
                  validationContent = "Vui lòng nhập mô tả";
                });
                return "Vui lòng nhập mô tả";
              } else {
                setState(() {
                  validationContent = "";
                });
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 8,
          ),
        ),
      ],
    );
  }

  Column textInputDescriptionByStep(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FoodHubColors.colorE1E4E8.withOpacity(0.3)),
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
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng nhập chi tiết các bước";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            controller: _contentStepController[index],
          ),
        ),
      ],
    );
  }

  void updateImageStep(context, int index) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorFC6011,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.15,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chụp ảnh mới",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImageStep(ImageSource.camera, index);
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: FoodHubColors.colorFFFFFF,
              ),
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_album_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chọn ảnh từ thư viện",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImageStep(ImageSource.gallery, index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateImage(context) {
    showModalBottomSheet(
      backgroundColor: FoodHubColors.colorFC6011,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.15,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chụp ảnh mới",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImage(ImageSource.camera);
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: FoodHubColors.colorFFFFFF,
              ),
              Expanded(
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_album_outlined,
                        color: FoodHubColors.colorFFFFFF,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Chọn ảnh từ thư viện",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.colorFFFFFF),
                      ),
                    ],
                  ),
                  onTap: () {
                    chooseImage(ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
