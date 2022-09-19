import 'package:flutter/material.dart';

import 'constants/color.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: FoodHubColors.colorF0F5F9,
    fontFamily: "SVN-Gotham",
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyText1: TextStyle(color: kTextColor),
    bodyText2: TextStyle(color: kTextColor),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: FoodHubColors.colorF0F5F9,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    //toolbarTextStyle: TextStyle(color: FoodHubColors.color0B0C0C, fontSize: 18),
    // systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
