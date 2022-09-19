import 'package:flutter/material.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/features/forgot_password/components/pinput.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../../widgets/default_button.dart';

class CodeSignUpScreen extends StatefulWidget {
  const CodeSignUpScreen({Key? key}) : super(key: key);

  @override
  State<CodeSignUpScreen> createState() => _CodeSignUpScreenScreenState();
}

class _CodeSignUpScreenScreenState extends State<CodeSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.08),
                  Image.asset("assets/images/otp.png"),
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  Text(
                    "Mã xác nhận",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(25),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Vui lòng điền mã đã được gửi vào mail của bạn!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  //const PinPut(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  DefaultButton(
                    width: getProportionateScreenWidth(250),
                    text: "TIẾP TỤC",
                    press: () {
                      Navigator.pushNamed(context, Routes.changeForgotPass);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
