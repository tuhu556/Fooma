import 'package:flutter/material.dart';

class FoodHubColors {
  static final Color colorFFFFFF = HexColor("#FFFFFF");
  static final Color colorEC407A = HexColor("#EC407A");
  static final Color colorB7B7B7 = HexColor("#B7B7B7");
  static final Color colorDD323A = HexColor("#DD323A");
  static final Color color30A197 = HexColor("#30A197");
  static final Color color0B0C0C = HexColor("#0B0C0C");
  static final Color colorCC0000 = HexColor("#CC0000");
  static final Color color007A32 = HexColor("#007A32");
  static final Color color333333 = HexColor("#333333");
  static final Color colorFC6011 = HexColor("#FC6011");
  static final Color colorFC7F401 = HexColor("#FC7F40");
  static final Color colorE1E4E8 = HexColor("#E1E4E8");
  static final Color colorFFD8D8D8 = HexColor("#FFD8D8D8");
  static final Color colorFFFF7643 = HexColor("#FFFF7643");
  static final Color color1E2022 = HexColor("#1E2022");
  static final Color colorF0F5F9 = HexColor("#F0F5F9");
  static final Color colorFFC5A8 = HexColor("#FFC5A8");
  static final Color colorFFA375 = HexColor("#FFA375");
  static final Color color1f89de = HexColor("#1F89DE");
  static final Color color52616B = HexColor("#52616B");
  static final Color colorF1F1F1 = HexColor("#F1F1F1");
  static final Color colorFFCC00 = HexColor("#FFCC00");
  static final Color colorFFC107 = HexColor("#FFC107");
  static final Color colorDADCE6 = HexColor("#DADCE6");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

const kTextColor = Color(0xFF757575);
const kSecondaryColor = Color(0xFF979797);
