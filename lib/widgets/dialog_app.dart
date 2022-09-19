import 'package:flutter/material.dart';
import 'package:foodhub/constants/color.dart';

class DialogApp extends StatelessWidget {
  final String title;
  final String message;
  final String subMessage;
  final String cancelText;
  final String okText;
  final Function()? cancelFunction;
  final Function()? okFunction;

  const DialogApp({
    required this.title,
    required this.message,
    this.subMessage = '',
    this.cancelText = '',
    required this.okText,
    required this.cancelFunction,
    required this.okFunction,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double borderRadius = 10;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.8,
          decoration: ShapeDecoration(
            color: FoodHubColors.colorFFFFFF,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    color: FoodHubColors.color0B0C0C,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                width: 34,
                height: 4,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: FoodHubColors.color52616B,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),
              ),
              (subMessage.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 30),
                      child: Text(subMessage,
                          style: TextStyle(
                            color: FoodHubColors.colorB7B7B7,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center),
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          okFunction?.call();
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: FoodHubColors.colorFC6011,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: (cancelText.isNotEmpty)
                                      ? const Radius.circular(0)
                                      : Radius.circular(borderRadius)),
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              okText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (cancelText.isNotEmpty)
                        ? Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                cancelFunction?.call();
                              },
                              child: Container(
                                decoration: ShapeDecoration(
                                  color: FoodHubColors.colorFFFFFF,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(borderRadius)),
                                  ),
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                child: Center(
                                    child: Text(
                                  cancelText,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
