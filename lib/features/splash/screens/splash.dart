import 'package:flutter/material.dart';
import 'package:foodhub/config/routes.dart';
import 'package:foodhub/config/size_config.dart';
import 'package:foodhub/constants/color.dart';
import 'package:foodhub/constants/constants.dart';
import 'package:foodhub/features/splash/components/splash_content.dart';
import 'package:foodhub/widgets/default_button.dart';

class SplacshScreen extends StatefulWidget {
  const SplacshScreen({Key? key}) : super(key: key);

  @override
  State<SplacshScreen> createState() => _SplacshScreenState();
}

class _SplacshScreenState extends State<SplacshScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Chào mừng bạn đến với Fooma, \nứng dụng quản lí thực phẩm.",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "Bạn có thể quản lí hiệu quả nguyên liệu. \nVà khám phá nhiều công thức mới.",
      "image": "assets/images/splash_2.png"
    },
    {
      "text":
          "Dễ dàng chia sẻ công thức riêng của mình. \nKết nối những người đam mê ẩm thực lại cùng nhau.",
      "image": "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(flex: 3),
                      DefaultButton(
                        width: double.infinity,
                        text: "TIẾP TỤC",
                        press: () {
                          Navigator.pushNamed(context, Routes.signInWelcome);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Constants.kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? FoodHubColors.colorFFFF7643
            : FoodHubColors.colorFFD8D8D8,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
