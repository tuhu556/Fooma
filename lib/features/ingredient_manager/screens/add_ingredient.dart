import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/features/ingredient_manager/bloc/add_ingredient/add_ingredient_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/ingredientData/ingredient_data_bloc.dart';
import 'package:foodhub/features/ingredient_manager/bloc/location/location_bloc.dart';
import 'package:foodhub/features/ingredient_manager/models/ingredient_data_entity.dart';
import 'package:foodhub/features/ingredient_manager/models/location_entity.dart';

import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  @override
  Widget build(BuildContext context) {
    String locationName = "";
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    locationName = args['locationName'];
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AddIngredientBloc(),
          ),
          BlocProvider(
            create: (_) => LocationBloc()..add(const GetLocation()),
          ),
          BlocProvider(
            create: (_) =>
                IngredientDataBloc()..add(const IngredientData(10000)),
          ),
        ],
        child: AddFoodView(
          locationName: locationName,
        ));
  }
}

class AddFoodView extends StatefulWidget {
  final String locationName;
  const AddFoodView({Key? key, required this.locationName}) : super(key: key);

  @override
  _AddFoodViewState createState() => _AddFoodViewState();
}

class _AddFoodViewState extends State<AddFoodView> {
  //int tag = 1;

  GlobalKey<FormState> _addFoodKeyForm = GlobalKey();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _unitController = new TextEditingController();
  TextEditingController _quantityController = new TextEditingController();
  List<IngredientDataModel> listIngredientData = [];
  bool _checkLocation = false;
  bool _quantity = false;
  bool _chooseQuantity = false;
  int cool = 0;
  int normal = 0;
  int freeze = 0;

  int choiceNum = 0;
  DateTime pickerDate = DateTime.now();
  String ingredientDbid = "00000000-0000-0000-0000-000000000000";
  String imageUrl =
      "https://previews.123rf.com/images/robuart/robuart1610/robuart161000499/64621560-group-of-food-vector-illustrations-flat-design-collection-of-various-food-cheese-sausage-bread-water.jpg";

  var difference;
  final DateFormat formatterYMDHMS = DateFormat('yyyy-MM-dd');

  String formattedYMD = '';
  String formattedHMS = '';
  DateTime? timeAgo;
  String locationId = "";
  LocationModel? selectedLocation;
  List<LocationModel> locationList = [];

  @override
  Widget build(BuildContext context) {
    if (widget.locationName.isEmpty) {
      _checkLocation = true;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<AddIngredientBloc, AddIngredientState>(
          listener: (context, state) {
            if (state.status == AddIngredientStatus.Processing) {
              Helpers.shared.showDialogProgress(context);
            } else if (state.status == AddIngredientStatus.Failed) {
              Helpers.shared.hideDialogProgress(context);
              Helpers.shared
                  .showDialogError(context, message: state.error!.message);
            } else if (state.status == AddIngredientStatus.Success) {
              Helpers.shared.hideDialogProgress(context);
              if (_checkLocation) {
                Navigator.popAndPushNamed(context, Routes.ingredientSection,
                    arguments: {
                      "locationName": selectedLocation!.locationName
                    });
              } else {
                Navigator.pop(context);
              }
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
                if (widget.locationName.isNotEmpty) {
                  for (int i = 0; i < locationList.length; i++) {
                    if (locationList[i].locationName == widget.locationName) {
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
        BlocListener<IngredientDataBloc, IngredientDataState>(
          listener: (context, state) {
            if (state.status == IngredientDataStatus.Processing) {
              // const snackBar = SnackBar(
              //   content: Text("Loading..."),
              //   duration: Duration(milliseconds: 500),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state.status == IngredientDataStatus.Failed) {
              // const snackBar = SnackBar(
              //   content: Text("Loading Failed"),
              //   duration: Duration(milliseconds: 500),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state.status == IngredientDataStatus.Success) {
              // const snackBar = SnackBar(
              //   content: Text("Loading Success"),
              //   duration: Duration(milliseconds: 500),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              listIngredientData.clear();
              setState(() {
                listIngredientData = state.ingredientResponse!.data;
              });
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
              "Thêm nguyên liệu mới",
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
                    const SizedBox(
                      height: 40,
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
                    inputIngredient(),
                    const SizedBox(
                      height: 20,
                    ),
                    _checkLocation
                        ? Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Vị trí',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: FoodHubColors.color0B0C0C,
                              ),
                            ),
                          )
                        : Container(),
                    _checkLocation
                        ? const SizedBox(
                            height: 10,
                          )
                        : Container(),
                    _checkLocation
                        ? Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: FoodHubColors.colorFFFFFF),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                          )
                        : Container(),
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
                    Visibility(
                      visible: _quantity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
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
                      height: 10,
                    ),
                    freeze != 0 && selectedLocation!.locationName == "Ngăn Đông"
                        ? Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                '* Số ngày hết hạn dự kiến: ' +
                                    freeze.toString() +
                                    " ngày",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.colorFC6011),
                              ),
                            ),
                          )
                        : Container(),
                    cool != 0 && selectedLocation!.locationName == "Ngăn Mát"
                        ? Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                '* Số ngày hết hạn dự kiến: ' +
                                    cool.toString() +
                                    " ngày",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.colorFC6011),
                              ),
                            ),
                          )
                        : Container(),
                    normal != 0 && selectedLocation!.locationName == "Khác"
                        ? Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                '* Số ngày hết hạn dự kiến: ' +
                                    normal.toString() +
                                    " ngày",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: FoodHubColors.colorFC6011),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Transform.translate(
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: DefaultButton(
                width: double.infinity,
                text: "THÊM",
                press: () {
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
                      _unitController.text.isNotEmpty) {
                    print("food:" + _nameController.text);
                    print("ingredientDATA:" + ingredientDbid.toString());
                    print("imageURL:" + imageUrl.toString());
                    for (int i = 0; i < listIngredientData.length; i++) {
                      if (_nameController.text.toLowerCase().trim() ==
                          listIngredientData[i].ingredientName.trim()) {
                        print("--------match!----------------");
                        ingredientDbid = listIngredientData[i].id;
                        imageUrl = listIngredientData[i].imageUrl;
                        print("id: " + listIngredientData[i].id);
                        print("url: " + listIngredientData[i].imageUrl);
                      }
                    }
                    formatISOTime(pickerDate);
                    print(formatISOTime(pickerDate));
                    print("food2:" + _nameController.text);
                    print("ingredientDATA2:" + ingredientDbid.toString());
                    print("imageURL2:" + imageUrl.toString());
                    print("quantity: " + _quantityController.text);
                    print("unit: " + _unitController.text);
                    final bloc = context.read<AddIngredientBloc>();
                    bloc.add(
                      CreateIngredientEvent(
                          ingredientDbid: ingredientDbid,
                          categoryId: "",
                          ingredientName: _nameController.text,
                          expiredDate: formatISOTime(pickerDate),
                          quantity: double.parse(_quantityController.text),
                          desciption: "",
                          imageUrl: imageUrl,
                          unit: _unitController.text,
                          locationId: selectedLocation!.id,
                          locationName: selectedLocation!.locationName,
                          ingredientNotifications: []),
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
    var duration = date.timeZoneOffset;
    if (duration.isNegative) {
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "-${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    } else {
      return (DateFormat("yyyy-MM-ddTHH:mm:ss.mmm").format(date) +
          "+${duration.inHours.toString().padLeft(2, '0')}${(duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0')}");
    }
  }

  void _onShowDatePicker() {
    Helpers.shared.showDatePickerApp(
      context,
      enableChosenDay: _decideWhichDayToEnable,
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
          setState(() {
            _unitController.clear();
          });
        }
        setState(() {
          choiceNum = choice;
          _chooseQuantity = true;
        });
      },
    );
  }

  Widget inputIngredient() => TypeAheadFormField<IngredientDataModel?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _nameController,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: FoodHubColors.colorFFFFFF),
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
            borderSide: BorderSide(color: FoodHubColors.colorFFFFFF),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        color: Colors.white,
        elevation: 4.0,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      debounceDuration: const Duration(milliseconds: 400),
      loadingBuilder: (context) => SizedBox(
            height: 50,
            child: Center(
                child: CircularProgressIndicator(
                    color: FoodHubColors.colorFC6011)),
          ),
      noItemsFoundBuilder: (context) => const SizedBox(
            height: 50,
            child: Center(
                child: Text(
              "không tìm thấy nguyên liệu",
              style: TextStyle(fontSize: 16),
            )),
          ),
      onSuggestionSelected: (IngredientDataModel? suggestion) {
        setState(() {
          _nameController.text = suggestion!.ingredientName;
          ingredientDbid = suggestion.id;
          imageUrl = suggestion.imageUrl;
          cool = suggestion.cool;
          freeze = suggestion.freeze;
          normal = suggestion.normal;
        });
      },
      validator: (value) =>
          value != null && value.isEmpty ? 'Vui lòng điền tên thực phẩm' : null,
      //onSaved: (value) => selectedCity = value,
      getImmediateSuggestions: true,
      suggestionsCallback: IngredientService.getIngredientSuggestions,
      itemBuilder: (context, IngredientDataModel? suggestion) {
        final ingredient = suggestion!;
        return ListTile(
          title: Text(ingredient.ingredientName),
        );
      });

  int timePost(String publishedDate) {
    timeAgo = new DateFormat("yyyy-MM-dd").parse(publishedDate);

    final dayAgo = timeAgo!
        .difference(DateFormat("yyyy-MM-dd")
            .parse(formatterYMDHMS.format(DateTime.now())))
        .inDays;
    return dayAgo;
  }
}
