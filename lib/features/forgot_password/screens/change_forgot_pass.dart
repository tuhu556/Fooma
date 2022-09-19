import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/constants.dart';
import 'package:foodhub/constants/validator.dart';
import 'package:foodhub/features/forgot_password/bloc/change_pass_bloc.dart';
import 'package:foodhub/features/forgot_password/screens/pass_success_screen.dart';
import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:foodhub/widgets/text_field_edit.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChangeForgotPassScreen extends StatefulWidget {
  const ChangeForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ChangeForgotPassScreen> createState() => _ChangeForgotPassScreenState();
}

class _ChangeForgotPassScreenState extends State<ChangeForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePassBloc(),
      child: const ChangeForgotPassView(),
    );
  }
}

class ChangeForgotPassView extends StatefulWidget {
  const ChangeForgotPassView({Key? key}) : super(key: key);

  @override
  State<ChangeForgotPassView> createState() => _ChangeForgotPassViewState();
}

class _ChangeForgotPassViewState extends State<ChangeForgotPassView> {
  GlobalKey<FormState> _keyForm = GlobalKey();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  bool _showPass = true;
  bool _showRePass = true;
  bool _check = true;
  late String email;
  late String keyCode;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args != null) {
      email = args['email'];
      keyCode = args['keyCode'];
    }
    return BlocListener<ChangePassBloc, ChangePassState>(
      listener: (context, state) {
        if (state.status == ChangePassStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == ChangePassStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared.showDialogError(context,
              message: "Có lỗi xảy ra, vui lòng thử lại!");
        } else if (state.status == ChangePassStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared
              .showDialogSuccess(context, message: "Đổi mật khẩu thành công");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const ChangePassSuccessScreen(),
              ),
              (route) => false);
        }
      },
      child: KeyboardDismisser(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    Image.asset("assets/images/otp.png"),
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
                      text: "TIẾP TỤC",
                      press: () {
                        if (_keyForm.currentState!.validate() && _check) {
                          setState(() {
                            final bloc = context.read<ChangePassBloc>();
                            bloc.add(CreateChangePassEvent(
                                email, keyCode, _passwordController.text));
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
    );
  }

  Widget textNewPassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      controllerText: _passwordController,
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.done,
      label: "Nhập mật khẩu mới",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        RegExp regex = RegExp(Constants.patternPassword);
        if (value == null || value.isEmpty) {
          return kPassNullError;
        } else if (!regex.hasMatch(value)) {
          return kPassError;
        }
        return null;
      },
      obscureText: obscureText,
    );
  }

  Widget textFieldRePassword(BuildContext context,
      {Function(String?)? onSave,
      TextEditingController? controllerText,
      Function(String?)? onChange,
      Widget? suffixIcon,
      bool? obscureText}) {
    return TextFieldEdit(
      controllerText: _rePasswordController,
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.done,
      label: "Nhập lại mật khẩu",
      hintColor: FoodHubColors.color0B0C0C,
      validatePassword: (value) {
        if (value == null || value.isEmpty) {
          _check = false;
          return kPassNullError;
        }
        if (value != _passwordController.text) {
          _check = false;
          return kMatchPassError;
        } else {
          _check = true;
        }
      },
      obscureText: obscureText,
    );
  }

  Form changePassForm(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          textNewPassword(context,
              controllerText: _passwordController,
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
          textFieldRePassword(context,
              controllerText: _rePasswordController,
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
        ],
      ),
    );
  }
}
