import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../constants/color.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({Key? key}) : super(key: key);

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  String? validationContent;
  double _value = 0;
  List<String?> ingredients = [];
  List<String?> step = [];
  List<String?> ingredient = [];

  GlobalKey<FormState> _addRecipeKeyForm = GlobalKey();
  TextEditingController _nameRecipeController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _servesController = new TextEditingController();
  TextEditingController _caloriesController = new TextEditingController();

  List<TextEditingController> _nameController = [];
  List<TextEditingController> _quantityController = [];
  List<TextEditingController> _unitController = [];
  List<TextEditingController> _contentStepController = [];

  bool _image = false;
  bool _timeToCook = false;
  bool _chooseQuantity = false;
  bool _quantity = false;
  bool _description = false;
  // int choiceNum = 0;

  List<bool?> _checkedValue = [false];

  List<int> choiceNum = [5];

  File? imageFile;
  File? imageFileStep;
  final picker = ImagePicker();
  String urlImg = '';
  String url = '';
  String urlStep = '';

  List<String> urlImageStep = [''];
  List<bool> imageStep = [false];
  List<bool> content = [false];
  List<bool> chooseUnit = [false];

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
        _image = false;
        print(urlImg);
      });
    } else {
      setState(() {
        _image = true;
      });
    }
  }

  chooseImageStep(ImageSource src, int index) async {
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        imageFileStep = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
    var storageImg;
    try {
      print(imageFileStep!.path);
      storageImg = FirebaseStorage.instance.ref().child(imageFileStep!.path);
      var task = storageImg.putFile(imageFileStep!);
      urlStep =
          await (await task.whenComplete(() => null)).ref.getDownloadURL();
    } catch (e) {}
    if (urlStep != '') {
      setState(() {
        urlImageStep[index] = urlStep;
        imageStep[index] = false;
      });
    } else {
      setState(() {
        imageStep[index] = true;
      });
    }
  }

  @override
  void initState() {
    _servesController.text = '0';
    _caloriesController.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Sửa công thức",
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
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20), // Image border
                                child: Container(
                                    height: 300,
                                    width: double.infinity,
                                    child: Image.network(urlImg,
                                        fit: BoxFit.cover)),
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
                                  )),
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
                    margin: EdgeInsets.only(left: 15, top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        validationContent ?? "",
                        style: TextStyle(
                            color: FoodHubColors.colorCC0000, fontSize: 14),
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
                            fontSize: 14,
                            color: FoodHubColors.color0B0C0C,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        _value.toString() + ' min',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
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
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              int currentValue =
                                  int.parse(_servesController.text);
                              setState(() {
                                currentValue++;
                                _servesController.text = (currentValue)
                                    .toString(); // incrementing value
                              });
                            },
                            child: Icon(Icons.add)),
                        InkWell(
                            onTap: () {
                              int currentValue =
                                  int.parse(_servesController.text);
                              setState(() {
                                currentValue--;
                                _servesController.text =
                                    (currentValue > 0 ? currentValue : 0)
                                        .toString(); // decrementing value
                              });
                            },
                            child: Icon(Icons.remove))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Helpers.shared.textFieldCalories(
                    context,
                    controllerText: _caloriesController,
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              int currentValue =
                                  int.parse(_caloriesController.text);
                              setState(() {
                                currentValue++;
                                _caloriesController.text = (currentValue)
                                    .toString(); // incrementing value
                              });
                            },
                            child: Icon(Icons.add)),
                        InkWell(
                            onTap: () {
                              int currentValue =
                                  int.parse(_caloriesController.text);
                              setState(() {
                                currentValue--;
                                _caloriesController.text =
                                    (currentValue > 0 ? currentValue : 0)
                                        .toString(); // decrementing value
                              });
                            },
                            child: Icon(Icons.remove))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      'Nguyên liệu',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      _nameController.removeAt(index);
                                      _quantityController.removeAt(index);
                                      _unitController.removeAt(index);
                                      choiceNum.removeAt(index);
                                      chooseUnit.removeAt(index);
                                      _checkedValue.removeAt(index);
                                      if (chooseUnit.length == 0 &&
                                          choiceNum.length == 0 &&
                                          _checkedValue.length == 0) {
                                        choiceNum.add(5);
                                        chooseUnit.add(false);
                                        _checkedValue.add(false);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Helpers.shared.textFieldNameOfFood(
                              context,
                              controllerText: _nameController[index],
                              colorBox:
                                  FoodHubColors.colorE1E4E8.withOpacity(0.3),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Opacity(
                              opacity: 0.7,
                              child: Text(
                                'Đơn vị',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: FoodHubColors.color0B0C0C,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                chipSelect('Miếng', 1, index),
                                const SizedBox(
                                  width: 10,
                                ),
                                chipSelect('KG', 2, index),
                                const SizedBox(
                                  width: 10,
                                ),
                                chipSelect('Túi', 3, index),
                                const SizedBox(
                                  width: 10,
                                ),
                                chipSelect('Khác', 4, index),
                              ],
                            ),
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
                            choiceNum[index] == 4
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Helpers.shared.textFieldUnit(
                                        context,
                                        controllerText: _unitController[index],
                                        colorBox: FoodHubColors.colorE1E4E8
                                            .withOpacity(0.3),
                                      ),
                                    ],
                                  )
                                : Container(),
                            const SizedBox(
                              height: 20,
                            ),
                            Helpers.shared.textFieldQuantity(context,
                                controllerText: _quantityController[index],
                                colorBox:
                                    FoodHubColors.colorE1E4E8.withOpacity(0.3)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checkColor: FoodHubColors.colorFFFFFF,
                                  activeColor: FoodHubColors.colorFC6011,
                                  value: _checkedValue[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _checkedValue[index] = value;
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
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: FoodHubColors.colorFC6011,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            ingredient.add('');
                            _nameController.add(TextEditingController());
                            _quantityController.add(TextEditingController());
                            _unitController.add(TextEditingController());

                            if (ingredient.length > 1) {
                              choiceNum.add(5);
                            }
                            if (ingredient.length > 1) {
                              chooseUnit.add(false);
                            }

                            if (ingredient.length > 1) {
                              _checkedValue.add(false);
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      'Các bước chế biến',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      if (imageStep.length == 0 &&
                                          urlImageStep.length == 0 &&
                                          content.length == 0) {
                                        urlImageStep.add('');
                                        imageStep.add(false);
                                        content.add(false);
                                      }
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
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              20), // Image border
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(
                                                100), // Image radius
                                            child: Image.network(
                                                urlImageStep[index],
                                                fit: BoxFit.cover),
                                          ),
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
                                                          child:
                                                              SvgPicture.asset(
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
                                'Mô tả',
                                style: TextStyle(
                                    fontSize: 14,
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
                                    "Vui lòng nhập chi tiết bước " +
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
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: FoodHubColors.colorFC6011,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            step.add('');
                            _contentStepController.add(TextEditingController());
                            if (step.length > 1) {
                              urlImageStep.add('');
                            }

                            if (step.length > 1) {
                              imageStep.add(false);
                            }

                            if (step.length > 1) {
                              content.add(false);
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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

                              if (step.length > 0) {
                                for (int i = 0; i < urlImageStep.length; i++) {
                                  if (urlImageStep[i] == '') {
                                    imageStep[i] = true;
                                  }
                                }
                              }

                              for (int i = 0;
                                  i < _contentStepController.length;
                                  i++) {
                                if (_contentStepController[i].text == '') {
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
                              }
                              if (_addRecipeKeyForm.currentState!.validate()) {}
                              for (int i = 0; i < ingredient.length; i++) {
                                print(_nameController[i].text +
                                    _quantityController[i].text +
                                    _unitController[i].text +
                                    _checkedValue[i].toString());
                              }
                              // for (int i = 0; i < step.length; i++) {
                              //   print(urlImageStep[i] +
                              //       _contentStepController[i].text);
                              // }
                            });
                          },
                          child: Text(
                            "SỬA",
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
    );
  }

  Widget chipSelect(String chipName, int choice, int index) {
    return Expanded(
      child: InkWell(
        child: Container(
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
            _unitController[index].text = chipName;
          });
        },
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
            'Mô tả',
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
                height: 1,
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
