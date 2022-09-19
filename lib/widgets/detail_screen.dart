import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/color.dart';

class DetailScreen extends StatelessWidget {
  final String image;

  const DetailScreen({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true, // Set it to false
              minScale: 0.5,
              maxScale: 10,
              child: Image.network(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                child: Opacity(
                    opacity: 0.5,
                    child: ClipOval(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration:
                            BoxDecoration(color: FoodHubColors.color0B0C0C),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/icons/multi.svg',
                            color: FoodHubColors.colorFFFFFF,
                          )),
                        ),
                      ),
                    )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
