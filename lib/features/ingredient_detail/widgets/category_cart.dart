import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodhub/constants/color.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconPath;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {},
        child: Container(
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: SvgPicture.asset(
                    iconPath,
                    color: FoodHubColors.color0B0C0C,
                  ),
                  color: FoodHubColors.colorF1F1F1,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
