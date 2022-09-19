import 'package:flutter/material.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn chưa có tài khoản? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(13)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.signUp),
          child: Text(
            "Đăng ký ngay thôi !",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(13),
                color: FoodHubColors.colorFC6011),
          ),
        ),
      ],
    );
  }
}
