import 'package:flutter/material.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/widgets/default_button.dart';

class ChangePassSuccessScreen extends StatelessWidget {
  const ChangePassSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.06),
                  Center(
                    child: Icon(
                      Icons.check_circle,
                      color: FoodHubColors.colorFC6011,
                      size: 120,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  Text(
                    "Đổi mật khẩu thành công",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  const Text(
                    "Xin hãy đăng nhập lại tài khoản của bạn!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.08),
                  DefaultButton(
                    width: getProportionateScreenWidth(270),
                    text: "TIẾP TỤC",
                    press: () {
                      Navigator.pushNamed(context, Routes.signIn);
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
