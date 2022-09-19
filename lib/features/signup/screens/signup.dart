import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodhub/config/routes.dart';

import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/constants.dart';
import 'package:foodhub/constants/validator.dart';
import 'package:foodhub/features/signup/bloc/signup_bloc.dart';

import 'package:foodhub/helper/helper.dart';
import 'package:foodhub/widgets/default_button.dart';
import 'package:foodhub/widgets/text_field_edit.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  GlobalKey<FormState> _signUpKeyForm = GlobalKey();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _rePasswordController = new TextEditingController();
  bool _showPass = true;
  bool _showRePass = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.Processing) {
          Helpers.shared.showDialogProgress(context);
        } else if (state.status == SignUpStatus.Duplicated) {
          Helpers.shared.hideDialogProgress(context);
          Helpers.shared
              .showDialogError(context, message: "Email đã được sử dụng!");
        } else if (state.status == SignUpStatus.Failed) {
          Helpers.shared.hideDialogProgress(context);

          Helpers.shared
              .showDialogError(context, message: state.error!.message);
        } else if (state.status == SignUpStatus.Success) {
          Helpers.shared.hideDialogProgress(context);
          Navigator.pushNamed(context, Routes.signUpSuccess);
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
          ),
          body: SafeArea(
              child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.03,
                    ),
                    Text(
                      "Đăng ký",
                      style: TextStyle(
                        color: FoodHubColors.color0B0C0C,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    signUpForm(context),
                    SizedBox(height: SizeConfig.screenHeight! * 0.02),
                    DefaultButton(
                      width: double.infinity,
                      text: "ĐĂNG KÝ",
                      press: () {
                        if (_signUpKeyForm.currentState!.validate() &&
                            _passwordController.text ==
                                _rePasswordController.text) {
                          setState(() {
                            final bloc = context.read<SignUpBloc>();
                            bloc.add(CreateSignUpEvent(
                                email: _emailController.text,
                                name: _nameController.text,
                                password: _passwordController.text));
                          });
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    Text(
                        "Bằng cách nhấp vào Đăng ký, bạn đồng ý với \nĐiều khoản, Chính sách dữ liệu của chúng tôi.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
            ),
          )),
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
      label: "Nhập mật khẩu ",
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
          return kPassNullError;
        }
        if (value != _passwordController.text) {
          return kMatchPassError;
        }
      },
      obscureText: obscureText,
    );
  }

  Form signUpForm(BuildContext context) {
    return Form(
      key: _signUpKeyForm,
      child: Column(
        children: [
          Helpers.shared.textFieldUserID(
            context,
            controllerText: _emailController,
            suffixIcon: Icon(
              Icons.mail,
              color: FoodHubColors.colorFC6011,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Helpers.shared.textFieldUserName(
            context,
            controllerText: _nameController,
            suffixIcon: Icon(
              Icons.person,
              color: FoodHubColors.colorFC6011,
            ),
          ),
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
              controllerText: _passwordController,
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
