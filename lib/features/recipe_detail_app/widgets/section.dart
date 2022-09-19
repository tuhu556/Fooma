import 'package:flutter/material.dart';
import 'package:foodhub/constants/color.dart';

class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onTap;

  const Section(
    this.title,
    this.children, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: FoodHubColors.color0B0C0C,
                  ),
                ),
                InkWell(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Xem thêm',
                        style: TextStyle(
                          fontSize: 16,
                          color: FoodHubColors.colorFC6011,
                        ),
                      ),
                    ],
                  ),
                  onTap: onTap,
                )
              ],
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Wrap(
                  children: children,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
