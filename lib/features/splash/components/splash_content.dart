import 'package:flutter/material.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          "FOOMA",
          style: TextStyle(
            color: FoodHubColors.colorFFFF7643,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(
          text!,
          style: const TextStyle(
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 1),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
          // height: 265,
          // width: 200,
        ),
      ],
    );
  }
}
