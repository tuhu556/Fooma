import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/constants.dart';
import 'package:foodhub/constants/validator.dart';
import 'package:foodhub/features/forgot_password/screens/pass_success_screen.dart';
import 'package:foodhub/features/password_setting/bloc/change_password/change_password_bloc.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:foodhub/widgets/text_field_edit.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  bool _showPass = true;
  bool _showOldPass = true;
  bool _showRePass = true;
  bool _check = true;
  bool _check2 = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.status == ChangePasswordStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == ChangePasswordStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared
              .showDialogError(context, message: "Mật khẩu cũ không đúng");
        } else if (state.status == ChangePasswordStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogSuccess(context,
              message: "Đổi mật khẩu thành công", okFunction: () {
            Navigator.pop(context);
          });
        }
      },
      child: KeyboardDismisser(
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
            title: Text(
              "Đổi mật khẩu",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: FoodHubColors.color0B0C0C),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      Text(
                        "Đổi mật khẩu mới",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(25),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Mật khẩu của bạn phải khác mật khẩu trước đó",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      changePassForm(context),
                      SizedBox(height: SizeConfig.screenHeight! * 0.04),
                      DefaultButton(
                        width: double.infinity,
                        text: "XÁC NHẬN",
                        press: () {
                          if (_keyForm.currentState!.validate() &&
                              _check &&
                              _check2) {
                            setState(() {
                              final bloc = context.read<ChangePasswordBloc>();
                              bloc.add(ChangePassword(
                                  _oldPasswordController.text,
                                  _newPasswordController.text));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldReNewPassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      controllerText: _rePasswordController,
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.done,
      label: "Nhập lại mật khẩu mới",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          _check = false;
          return kPassNullError;
        } else if (value != _newPasswordController.text) {
          _check = false;
          return kMatchPassError;
        } else {
          _check = true;
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  Widget textNewPassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      controllerText: _newPasswordController,
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.done,
      label: "Nhập mật khẩu mới",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        RegExp regex = RegExp(Constants.patternPassword);
        if (value == null || value.isEmpty) {
          _check2 = false;
          return kPassNullError;
        } else if (value == _oldPasswordController.text) {
          _check2 = false;
          return kMatchOldPassError;
        } else if (!regex.hasMatch(value)) {
          return kPassError;
        } else {
          _check2 = true;
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  Widget changePassForm(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Helpers.shared.textFieldOldPassword(context,
            controllerText: _oldPasswordController,
            suffixIcon: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _showOldPass
                    ? Icon(
                        Icons.visibility,
                        color: FoodHubColors.colorFC6011,
                      )
                    : Icon(Icons.visibility_off,
                        color: FoodHubColors.colorFC6011),
              ),
              onTap: () {
                setState(() {
                  _showOldPass = !_showOldPass;
                });
              },
            ),
            obscureText: _showOldPass),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        textNewPassword(context,
            controllerText: _newPasswordController,
            suffixIcon: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _showPass
                    ? Icon(
                        Icons.visibility,
                        color: FoodHubColors.colorFC6011,
                      )
                    : Icon(Icons.visibility_off,
                        color: FoodHubColors.colorFC6011),
              ),
              onTap: () {
                setState(() {
                  _showPass = !_showPass;
                });
              },
            ),
            obscureText: _showPass),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        textFieldReNewPassword(context,
            controllerText: _newPasswordController,
            suffixIcon: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _showRePass
                    ? Icon(
                        Icons.visibility,
                        color: FoodHubColors.colorFC6011,
                      )
                    : Icon(Icons.visibility_off,
                        color: FoodHubColors.colorFC6011),
              ),
              onTap: () {
                setState(() {
                  _showRePass = !_showRePass;
                });
              },
            ),
            obscureText: _showRePass),
        SizedBox(height: SizeConfig.screenHeight! * 0.04),
      ],
    );
  }
}
