import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/cloudinary.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/validator.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredient_category/ingredient_category_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/location/location_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/update_ingredient/update_ingredient_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_category_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_user_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_data_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/location_entity.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class UpdateIngredientScreen extends StatefulWidget {
  const UpdateIngredientScreen({Key? key}) : super(key: key);

  @override
  State<UpdateIngredientScreen> createState() => _UpdateIngredientScreenState();
}

class _UpdateIngredientScreenState extends State<UpdateIngredientScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as IngredientUserModel;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => UpdateIngredientBloc(),
          ),
          BlocProvider(
            create: (context) =>
                IngredientCategoryBloc()..add(const IngredientCateogy()),
          ),
          BlocProvider(
            create: (_) => LocationBloc()..add(const GetLocation()),
          ),
        ],
        child: UpdateIngredientView(
          model: args,
        ));
  }
}

class UpdateIngredientView extends StatefulWidget {
  final IngredientUserModel model;
  const UpdateIngredientView({Key? key, required this.model}) : super(key: key);

  @override
  State<UpdateIngredientView> createState() => _UpdateIngredientViewState();
}

class _UpdateIngredientViewState extends State<UpdateIngredientView> {
  //int tag = 1;

  GlobalKey<FormState> _addFoodKeyForm = GlobalKey();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _unitController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  List<IngredientDataModel> listIngredientData = [];

  bool _quantity = false;
  bool _chooseQuantity = false;

  var difference;
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd');

  String formattedYMD = '';
  String formattedHMS = '';

  DateTime? timeAgo;

  int choiceNum = 0;
  DateTime pickerDate = DateTime.now();
  File? image;

  List<IngredientCategoryModel> categoryList = [];
  List<LocationModel> locationList = [];
  IngredientCategoryModel? seletedCategory;
  LocationModel? selectedLocation;
  String url = '';
  String ingredientId = "";
  String ingredientName = "";
  String categoryId = "";
  String categoryName = "";
  String locationId = "";
  String locationName = "";
  String expiredDate = "";
  String quantity = "";
  String imageUrl = "";
  String unit = "";

  bool checkImagePath = false;
  Future<void> pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        checkImagePath = true;
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      Helpers.shared.showDialogError(context, message: kCameraError);
    }
  }

  @override
  void initState() {
    ingredientId = widget.model.id;
    _nameController.text = widget.model.ingredientName;
    _quantityController.text = widget.model.quantity.toString();
    _unitController.text = widget.model.unit;
    categoryId = widget.model.categoryId;
    categoryName = widget.model.categoryName;
    locationId = widget.model.locationId;
    locationName = widget.model.locationName;
    imageUrl = widget.model.imageUrl;
    pickerDate = DateTime.parse(widget.model.expiredDate);
    switch (widget.model.unit) {
      case "Gói":
        choiceNum = 1;
        break;
      case "Hộp":
        choiceNum = 2;
        break;
      case "Lát":
        choiceNum = 3;
        break;
      case "Kg":
        choiceNum = 4;
        break;
      case "Gram":
        choiceNum = 5;
        break;
      case "L":
        choiceNum = 6;
        break;
      case "ml":
        choiceNum = 7;
        break;
      default:
        choiceNum = 8;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IngredientCategoryBloc, IngredientCategoryState>(
          listener: (context, state) {
            if (state.status == IngredientCategoryStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == IngredientCategoryStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
            } else if (state.status == IngredientCategoryStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              categoryList.clear();
              setState(() {
                categoryList = state.ingredientCategoryResponse!.item;
                for (int i = 0; i < categoryList.length; i++) {
                  if (categoryList[i].categoryId == categoryId) {
                    seletedCategory = categoryList[i];
                  }
                }
              });
            }
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state.status == LocationStatus.Processing) {
            } else if (state.status == LocationStatus.Failed) {
            } else if (state.status == LocationStatus.Success) {
              locationList.clear();
              setState(() {
                locationList = state.locationResponse!.item;
                if (locationId.isNotEmpty) {
                  for (int i = 0; i < locationList.length; i++) {
                    if (locationList[i].id == locationId) {
                      selectedLocation = locationList[i];
                    }
                  }
                } else {
                  selectedLocation = locationList.last;
                }
              });
            }
          },
        ),
        BlocListener<UpdateIngredientBloc, UpdateIngredientState>(
          listener: (context, state) {
            if (state.status == UpdateIngredientStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == UpdateIngredientStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == UpdateIngredientStatus.NothingChange) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cập nhập không thay đổi!"),
                ),
              );
              Navigator.pop(context);
            } else if (state.status == UpdateIngredientStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cập nhập nguyên liệu thành công!"),
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: KeyboardDismisser(
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
              "Chỉnh sửa nguyên liệu",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _addFoodKeyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(125), // Image radius
                          child: checkImagePath
                              ? Image.file(image!)
                              : Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: FoodHubColors.colorFC6011,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          updateImage(context);
                        },
                        child: Text(
                          "Cập nhật ảnh",
                          style: TextStyle(color: FoodHubColors.colorFFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Tên nguyên liệu',
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
                    Helpers.shared.textFieldIngredientNameRead(
                      context,
                      controllerText: _nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Vị trí',
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<LocationModel>(
                            menuMaxHeight: 300,
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            isDense: true,
                            value: selectedLocation,
                            onChanged: (newValue) {
                              setState(() {
                                selectedLocation = newValue;
                              });
                            },
                            items: locationList.map((LocationModel e) {
                              return DropdownMenuItem<LocationModel>(
                                value: e,
                                child: Text(
                                  e.locationName.toString(),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Danh mục',
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<IngredientCategoryModel>(
                            menuMaxHeight: 300,
                            dropdownColor: FoodHubColors.colorFFFFFF,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: FoodHubColors.color0B0C0C,
                            ),
                            isExpanded: true,
                            isDense: true,
                            value: seletedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                seletedCategory = newValue;
                              });
                            },
                            items:
                                categoryList.map((IngredientCategoryModel e) {
                              return DropdownMenuItem<IngredientCategoryModel>(
                                value: e,
                                child: Text(
                                  e.categoryName.toString(),
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
                    const SizedBox(
                      height: 10,
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
                      spacing: 10,
                      runSpacing: 15,
                      children: [
                        chipSelect('Gói', 1),
                        chipSelect('Hộp', 2),
                        chipSelect('Lát', 3),
                        chipSelect('Kg', 4),
                        chipSelect('Gram', 5),
                        chipSelect('L', 6),
                        chipSelect('ml', 7),
                        chipSelect('Khác', 8),
                      ],
                    ),
                    choiceNum == 8
                        ? Helpers.shared.textFieldUnit(
                            context,
                            controllerText: _unitController,
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Helpers.shared.textFieldQuantity(
                      context,
                      controllerText: _quantityController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Ngày hết hạn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: FoodHubColors.color0B0C0C),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _onShowDatePicker();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FoodHubColors.colorFFFFFF,
                        ),
                        child: Row(
                          children: [
                            Text(
                              getDate(),
                              style: TextStyle(
                                fontSize: 16,
                                color: FoodHubColors.color0B0C0C,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.date_range,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultButton(
                      width: double.infinity,
                      text: "LƯU THAY ĐỔI",
                      press: () async {
                        if (_chooseQuantity == false) {
                          setState(() {
                            _quantity = true;
                          });
                        } else {
                          setState(() {
                            _quantity = false;
                          });
                        }
                        if (_addFoodKeyForm.currentState!.validate() &&
                            _unitController.text.isNotEmpty &&
                            double.parse(_quantityController.text) > 0) {
                          final bloc = context.read<UpdateIngredientBloc>();
                          if (checkImagePath) {
                            final cloudinary = Cloudinary.full(
                              apiKey: CoudinaryFull.shared.apiKey,
                              apiSecret: CoudinaryFull.shared.apiSecret,
                              cloudName: CoudinaryFull.shared.cloudName,
                            );
                            final response = await cloudinary.uploadResource(
                              CloudinaryUploadResource(
                                filePath: image?.path,
                                fileBytes: await image?.readAsBytes(),
                                resourceType: CloudinaryResourceType.image,
                                folder: "Fooma",
                                fileName: image?.path,
                                progressCallback: (count, total) {
                                  setState(() {
                                    Helpers.shared.showDialogProgress(context);
                                  });
                                },
                              ),
                            );
                            if (response.isSuccessful) {
                              print(
                                  'Get your image from with ${response.secureUrl}');
                              setState(() {
                                imageUrl = response.secureUrl!;
                                bloc.add(CreateUpdateIngredientEvent(
                                  ingredientNotifications: [],
                                  ingredientId: ingredientId,
                                  categoryId: seletedCategory!.categoryId,
                                  ingredientName: _nameController.text,
                                  expiredDate: formatISOTime(pickerDate),
                                  quantity:
                                      double.parse(_quantityController.text),
                                  desciption: "",
                                  imageUrl: imageUrl,
                                  unit: _unitController.text,
                                  locationId: selectedLocation!.id,
                                  locationName: selectedLocation!.locationName,
                                ));
                              });
                            } else {
                              setState(() {
                                Helpers.shared.hideDialogProgress(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(kUploadImageError),
                                  ),
                                );
                              });
                            }
                          } else {
                            setState(() {
                              bloc.add(CreateUpdateIngredientEvent(
                                ingredientNotifications: [],
                                ingredientId: ingredientId,
                                categoryId: seletedCategory!.categoryId,
                                ingredientName: _nameController.text,
                                expiredDate: formatISOTime(pickerDate),
                                quantity:
                                    double.parse(_quantityController.text),
                                desciption: "",
                                imageUrl: imageUrl,
                                unit: _unitController.text,
                                locationId: selectedLocation!.id,
                                locationName: selectedLocation!.locationName,
                              ));
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int timePost(String publishedDate) {
    timeAgo = new DateFormat("yyyy-MM-dd").parse(publishedDate);

    final dayAgo = timeAgo!
        .difference(DateFormat("yyyy-MM-dd")
            .parse(formatterYMDHMS.format(DateTime.now())))
        .inDays;
    return dayAgo;
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))))) {
      return true;
    }
    return false;
  }

  String getDate() {
    return '${pickerDate.year}-${pickerDate.month.toString().padLeft(2, '0')}-${pickerDate.day.toString().padLeft(2, '0')}';
  }

  String formatISOTime(DateTime date) {
    //converts date into the following format:
// or 2019-06-04T12:08:56.235-0700
    var duration = date.timeZoneOffset;
    if (duration.isNegative)
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    else
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
  }

  void _onShowDatePicker() {
    Helpers.shared.showDatePickerApp(
      context,
      //enableChosenDay: _decideWhichDayToEnable,
      initialDate: pickerDate,
      firstDate: DateTime(1910),
      lastDate: DateTime(2100),
      resultDate: (date) {
        if (date != null) {
          setState(() {
            pickerDate = date;
          });
        }
      },
    );
  }

  Widget chipSelect(String chipName, int choice) {
    return InkWell(
      child: Container(
        width: 100,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: FoodHubColors.colorFFFFFF,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: choice != choiceNum
                    ? FoodHubColors.colorFFFFFF
                    : FoodHubColors.colorFC6011)),
        child: choice != choiceNum
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
                  color: choice != choiceNum
                      ? FoodHubColors.color0B0C0C
                      : FoodHubColors.colorFC6011,
                ),
              ),
      ),
      onTap: () {
        if (choice != 8) {
          setState(() {
            _unitController.text = chipName;
          });
        } else {
          if (widget.model.unit == "Gói" ||
              widget.model.unit == "Hộp" ||
              widget.model.unit == "Muỗng" ||
              widget.model.unit == "Kg" ||
              widget.model.unit == "Gram" ||
              widget.model.unit == "L" ||
              widget.model.unit == "ml") {
            setState(() {
              _unitController.clear();
            });
          } else {
            _unitController.text = widget.model.unit;
          }
        }
        setState(() {
          choiceNum = choice;
          _chooseQuantity = true;
        });
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
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
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
                  onTap: () async {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
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
