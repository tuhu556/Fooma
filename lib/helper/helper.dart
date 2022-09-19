import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/constants.dart';
import 'package:foodhub/constants/validator.dart';
import 'package:foodhub/widgets/dialog_app.dart';
import 'package:foodhub/widgets/dialog_edit_app.dart';
import 'package:foodhub/widgets/text_field_edit.dart';

class Helpers {
  Helpers._();
  static final Helpers shared = Helpers._();

  bool _isDialogLoading = false;

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void showDialogProgress(BuildContext context) {
    if (!_isDialogLoading) {
      _isDialogLoading = true;
      showDialog(
        //prevent outside touch
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //prevent Back button press
          return WillPopScope(
            onWillPop: () {
              return Future<bool>.value(false);
            },
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                child: const Center(
                  child: SpinKitWave(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void hideDialogProgress(BuildContext context) {
    if (_isDialogLoading) {
      _isDialogLoading = false;
      Navigator.pop(context);
    }
  }

  void showDialogError(
    BuildContext context, {
    String title = '',
    required String message,
    String subMessage = '',
    String okText = '',
    Function()? okFunction,
  }) {
    _baseDialogMessages(context,
        title: title.isNotEmpty ? title : "Lỗi",
        message: message,
        subMessage: subMessage,
        cancelText: '',
        okText: okText.isNotEmpty ? okText : "OK",
        cancelFunction: null,
        okFunction: okFunction);
  }

  void showDialogSuccess(
    BuildContext context, {
    String title = '',
    required String message,
    String subMessage = '',
    String okText = '',
    Function()? okFunction,
  }) {
    _baseDialogMessages(context,
        title: title.isNotEmpty ? title : "Thành công",
        message: message,
        subMessage: subMessage,
        cancelText: '',
        okText: okText.isNotEmpty ? okText : "OK",
        cancelFunction: null,
        okFunction: okFunction);
  }

  void showDialogConfirm(
    BuildContext context, {
    String title = '',
    required String message,
    String subMessage = '',
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogMessages(context,
        title: title.isNotEmpty ? title : "Xác nhận",
        message: message,
        subMessage: subMessage,
        cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
        okText: okText.isNotEmpty ? okText : "Đồng ý",
        cancelFunction: cancelFunction,
        okFunction: okFunction);
  }

  void _baseDialogMessages(
    BuildContext context, {
    required String title,
    required String message,
    String subMessage = '',
    required String cancelText,
    required String okText,
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => DialogApp(
            title: title,
            message: message,
            subMessage: subMessage,
            cancelText: cancelText,
            okText: okText,
            cancelFunction: cancelFunction,
            okFunction: okFunction));
  }

  void _baseDialogEdit(
    BuildContext context, {
    required String title,
    required Widget widget,
    required String cancelText,
    required String okText,
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => DialogEditApp(
            title: title,
            widget: widget,
            cancelText: cancelText,
            okText: okText,
            cancelFunction: cancelFunction,
            okFunction: okFunction));
  }

  void showDatePickerApp(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    bool Function(DateTime)? enableChosenDay,
    required Function(DateTime?) resultDate,
  }) async {
    final dateCurrent = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(2010),
        lastDate: lastDate ?? DateTime(2090),
        selectableDayPredicate: enableChosenDay);
    resultDate(dateCurrent);
  }

  void showTimePickerApp(
    BuildContext context, {
    TimeOfDay? initialTime,
    required Function(TimeOfDay?) resultTime,
  }) async {
    final dateCurrent = await showTimePicker(
      context: context,
      initialTime: initialTime != null ? initialTime : TimeOfDay.now(),
    );
    resultTime(dateCurrent);
  }

  Widget textFieldUserID(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Email",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      borderInput: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      keyboardType: TextInputType.emailAddress,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        RegExp regex = new RegExp(Constants.patternEmail);
        if (value == null || value.isEmpty) {
          return kEmailNullError;
        } else if (!regex.hasMatch(value)) {
          return kInvalidEmailError;
        }
      },
      suffixIcon: suffixIcon,
    );
  }

  Widget textFieldBio(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
  }) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tiểu sử của bạn";
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
      maxLength: 50,
    );
  }

  Widget textFieldContent(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
  }) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập bình luận của bạn";
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
      // maxLength: 100,
    );
  }

  Widget textFieldUserName(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
  }) {
    return TextFieldEdit(
      label: "Tên",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return kNamelNullError;
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
      maxLength: 30,
    );
  }

  Widget textFieldPassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.done,
      label: "Mật khẩu",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
      },
      suffixIcon: suffixIcon,
      obscureText: obscureText,
    );
  }

  Widget textFieldOldPassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.done,
      label: "Mật khẩu cũ",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return kPassNullError;
        }
      },
      suffixIcon: suffixIcon,
      obscureText: obscureText,
    );
  }

  Widget textFieldNameOfFood(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      Color? colorBox}) {
    return TextFieldEdit(
      label: "Tên nguyên liệu",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tên nguyên liệu";
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
    );
  }

  Widget textFieldTitleOfRepost(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      Color? colorBox}) {
    return TextFieldEdit(
      label: "Tiêu đề",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tên tiêu đề";
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
    );
  }

  Widget textFieldNameOfRecipe(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Tên công thức",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tên công thức";
        }
      },
      suffixIcon: suffixIcon,
    );
  }

  Widget textFieldNameOfPost(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Tiêu đề",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập tiêu đề";
        }
      },
      suffixIcon: suffixIcon,
      maxLength: 100,
    );
  }

  Widget textFieldIngredient(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Nguyên liệu",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {},
      suffixIcon: suffixIcon,
    );
  }

  Widget textFieldIngredientEdit(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
    Widget? prefixIcon,
    bool? autoFocus,
  }) {
    return TextFieldEdit(
      colorBox: colorBox,
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.done,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty || value == '') {
          return "Vui lòng nhập tên nguyên liệu";
        }
        return null;
      },
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      autoFocus: autoFocus,
    );
  }

  Widget textFieldIngredientNameRead(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
    Widget? prefixIcon,
    bool? autoFocus,
  }) {
    return TextFieldEdit(
      colorBox: colorBox,
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      enabled: false,
      readOnly: true,
      textStyle: TextStyle(color: Colors.grey[500]),
      textInputAction: TextInputAction.done,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty || value == '') {
          return "Vui lòng nhập tên nguyên liệu";
        }
        return null;
      },
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      autoFocus: autoFocus,
    );
  }

  Widget textFieldQuantityEdit(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
    Widget? prefixIcon,
    bool? autoFocus,
  }) {
    return TextFieldEdit(
      colorBox: colorBox,
      onChanged: onChange,
      onSave: onSave,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controllerText: controllerText,
      textInputAction: TextInputAction.done,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty || value == '') {
          return "Vui lòng nhập số lượng nguyên liệu";
        }
        return null;
      },
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      autoFocus: autoFocus,
    );
  }

  Widget textFieldUnitEdit(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      Color? colorBox,
      Widget? prefixIcon,
      bool? autoFocus}) {
    return TextFieldEdit(
      colorBox: colorBox,
      onChanged: onChange,
      onSave: onSave,
      keyboardType: TextInputType.name,
      controllerText: controllerText,
      textInputAction: TextInputAction.done,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty || value == '') {
          return "Vui lòng nhập số lượng nguyên liệu";
        }
        return null;
      },
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      autoFocus: autoFocus,
    );
  }

  Widget textFieldServes(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Khẩu phần",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: false, signed: false),
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return "Vui lòng nhập số lượng khẩu phần ";
        } else {
          RegExp regex = RegExp(Constants.patternNumber);
          if (!regex.hasMatch(value)) {
            return "Vui lòng nhập số";
          } else if (!isIntNumeric(value)) {
            return 'Vui lòng nhập đúng định dạng số';
          } else if (int.parse(value) <= 0 || int.parse(value) > 30) {
            return 'Vui lòng nhập số trong khoảng 1 -> 30';
          }
        }
      },
      suffixIcon: suffixIcon,
    );
  }

  Widget textFieldCalories(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      label: "Calories (Không bắt buộc)",
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: false, signed: false),
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        // if (value == null || value.isEmpty) {
        //   return "Vui lòng nhập số lượng calories";
        // }
        if (value != null) {
          RegExp regex = RegExp(Constants.patternNumber);
          if (!regex.hasMatch(value)) {
            return "Vui lòng nhập số";
          } else {
            return null;
          }
        }
      },
      suffixIcon: suffixIcon,
    );
  }

  Widget textFieldServe(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      Color? colorBox}) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      keyboardType: TextInputType.number,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số lượng khẩu phần';
        }
        return null;
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
    );
  }

  Widget textFieldUnit(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      Color? colorBox}) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      keyboardType: TextInputType.text,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập đơn vị';
        }
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
    );
  }

  Widget textFieldQuantity(
    BuildContext context, {
    Function(String?)? onSave,
    TextEditingController? controllerText,
    Function(String?)? onChange,
    Widget? suffixIcon,
    Color? colorBox,
  }) {
    return TextFieldEdit(
      label: 'Số lượng',
      onChanged: onChange,
      onSave: onSave,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số lượng';
        } else if (!isNumeric(value)) {
          return 'Vui lòng nhập đúng định dạng số - vd (1 hoặc 1.1)';
        } else if (double.parse(value) <= 0) {
          return 'Vui lòng nhập số lớn hơn 0';
        }
        return null;
      },
      suffixIcon: suffixIcon,
      colorBox: colorBox,
    );
  }

  Widget textSearchFilter(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon}) {
    return TextFieldEdit(
      onChanged: onChange,
      onSave: onSave,
      controllerText: controllerText,
      textInputAction: TextInputAction.next,
      borderInput: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      //keyboardType: TextInputType.none,
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {},
      suffixIcon: suffixIcon,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
    );
  }

  void showDialogEditUserName(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }

  void showDialogEditBio(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }

  void showDialogEditContent(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }

  void showDialogEditIngredientName(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }

  void showDialogEditQuantity(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }

  void showDialogEditUnit(
    BuildContext context, {
    String title = '',
    required Widget widget,
    String cancelText = '',
    String okText = '',
    Function()? cancelFunction,
    Function()? okFunction,
  }) {
    _baseDialogEdit(
      context,
      title: title.isNotEmpty ? title : "Xác nhận",
      widget: widget,
      cancelText: cancelText.isNotEmpty ? cancelText : "Hủy bỏ",
      okText: okText.isNotEmpty ? okText : "Đồng ý",
      cancelFunction: cancelFunction,
      okFunction: okFunction,
    );
  }
}
