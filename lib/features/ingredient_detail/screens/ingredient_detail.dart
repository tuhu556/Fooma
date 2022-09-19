import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../constants/color.dart';
import '../../../helper/helper.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({Key? key}) : super(key: key);

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  TextEditingController _nameIngredientController = new TextEditingController();
  TextEditingController _quantityIngredientController =
      new TextEditingController();
  TextEditingController _unitIngredientController = new TextEditingController();

  DateTime pickerDate = DateTime.now();

  File? imageFile;
  final picker = ImagePicker();
  String urlImg = '';
  String url = '';

  bool _nameOfIngredient = false;
  bool _quantityOfIngredient = false;
  bool _unitOfIngredient = false;

  List<String> options = [
    'Miếng',
    'KG',
    'Túi',
    'Others',
  ];

  int choiceNum = 0;
  bool _chooseQuantity = false;

  chooseImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
    var storageImg;
    try {
      print(imageFile!.path);
      storageImg = FirebaseStorage.instance.ref().child(imageFile!.path);
      var task = storageImg.putFile(imageFile!);
      url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
    } catch (e) {}
    if (url != '') {
      setState(() {
        urlImg = url;
        print(urlImg);
      });
    }
  }

  @override
  void initState() {
    _nameIngredientController.text = "test demo";
    _quantityIngredientController.text = "10";
    urlImg =
        'https://vcdn-dulich.vnecdn.net/2021/06/18/mi6-3939-1623991225.jpg';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(150), // Image radius
                      child: Image.network(urlImg, fit: BoxFit.cover),
                    ),
                  ),
                ),
                TextButton(
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
                    )),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: _nameOfIngredient
                      ? Helpers.shared.textFieldIngredientEdit(context,
                          controllerText: _nameIngredientController,
                          suffixIcon: IconButton(
                            splashColor: FoodHubColors.colorFFFFFF,
                            splashRadius: 15,
                            onPressed: () {
                              if (_nameIngredientController.text.isEmpty) {
                                Helpers.shared.showDialogError(context,
                                    title: "Trống",
                                    message: "Vui lòng nhập tên nguyên liệu");
                              } else {
                                setState(() {
                                  _nameOfIngredient = !_nameOfIngredient;
                                });
                              }
                            },
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.check_circle,
                                color: FoodHubColors.colorFC6011,
                              ),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 8)
                                .add(const EdgeInsets.only(right: 20)),
                            child: Icon(
                              Icons.food_bank,
                              color: FoodHubColors.colorFC6011,
                            ),
                          ),
                          autoFocus: true)
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.food_bank,
                                    color: FoodHubColors.colorFC6011,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      _nameIngredientController.text,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: FoodHubColors.color0B0C0C),
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                splashColor: FoodHubColors.colorFFFFFF,
                                splashRadius: 15,
                                onPressed: () {
                                  setState(() {
                                    _nameOfIngredient = !_nameOfIngredient;
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: FoodHubColors.colorFC6011,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                cardIngredientEdit(Icons.playlist_add_check_outlined,
                    "Ngày thêm", '02-02-2022', false, () {}),
                cardIngredientEdit(
                    Icons.playlist_remove_outlined,
                    "Ngày hết hạn",
                    DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(pickerDate.toString()))
                        .toString(),
                    true, () {
                  Helpers.shared.showDatePickerApp(
                    context,
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
                }),
                _quantityOfIngredient
                    ? Card(
                        child: Helpers.shared.textFieldQuantityEdit(
                          context,
                          controllerText: _quantityIngredientController,
                          suffixIcon: IconButton(
                            splashColor: FoodHubColors.colorFFFFFF,
                            splashRadius: 15,
                            onPressed: () {
                              if (_quantityIngredientController.text.isEmpty) {
                                Helpers.shared.showDialogError(context,
                                    title: "Trống",
                                    message: "Vui lòng nhập tên nguyên liệu");
                              } else {
                                setState(() {
                                  _quantityOfIngredient =
                                      !_quantityOfIngredient;
                                });
                              }
                            },
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.check_circle,
                                color: FoodHubColors.colorFC6011,
                              ),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 8)
                                .add(const EdgeInsets.only(right: 20)),
                            child: Icon(
                              Icons.production_quantity_limits_outlined,
                              color: FoodHubColors.colorFC6011,
                            ),
                          ),
                          autoFocus: true,
                        ),
                      )
                    : cardIngredientEdit(
                        Icons.production_quantity_limits_outlined,
                        "Số lượng",
                        _quantityIngredientController.text,
                        true, () {
                        setState(() {
                          _quantityOfIngredient = !_quantityOfIngredient;
                        });
                      }),
                _unitOfIngredient
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 8, right: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.scale_outlined,
                                    color: FoodHubColors.colorFC6011,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  chipSelect('Miếng', 1),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  chipSelect('Túi', 2),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  chipSelect('Kg', 3),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  chipSelect('Gram', 4),
                                  IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: FoodHubColors.colorFC6011,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _unitOfIngredient = !_unitOfIngredient;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : cardIngredientEdit(Icons.scale_outlined, "Đơn vị",
                        _unitIngredientController.text, true, () {
                        setState(() {
                          _unitOfIngredient = !_unitOfIngredient;
                        });
                      }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Container(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: FoodHubColors.colorFC6011,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {},
              child: Text(
                "XÓA NGUYÊN LIỆU",
                style: TextStyle(
                  fontSize: 16,
                  color: FoodHubColors.colorFFFFFF,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chipSelect(String chipName, int choice) {
    return Expanded(
      child: InkWell(
        child: Container(
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
          setState(() {
            choiceNum = choice;
            _unitIngredientController.text = chipName;

            _chooseQuantity = true;
          });
        },
      ),
    );
  }

  Card cardIngredientEdit(IconData icon, String title, String vale, bool check,
      VoidCallback onPress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: FoodHubColors.colorFC6011,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FoodHubColors.color0B0C0C),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      vale,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: FoodHubColors.color0B0C0C),
                    ),
                  ],
                )
              ],
            ),
            check
                ? IconButton(
                    splashColor: FoodHubColors.colorFFFFFF,
                    splashRadius: 15,
                    onPressed: onPress,
                    icon: Icon(
                      Icons.edit,
                      color: FoodHubColors.colorFC6011,
                    ))
                : Container()
          ],
        ),
      ),
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
