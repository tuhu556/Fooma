import 'package:flutter/material.dart';
import 'package:foodhub/constants/color.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class DialogEditApp extends StatefulWidget {
  final String title;
  final Widget widget;
  final String cancelText;
  final String okText;
  final Function()? cancelFunction;
  final Function()? okFunction;

  const DialogEditApp({
    required this.title,
    required this.widget,
    this.cancelText = '',
    required this.okText,
    required this.cancelFunction,
    required this.okFunction,
  });

  @override
  State<DialogEditApp> createState() => _DialogEditAppState();
}

class _DialogEditAppState extends State<DialogEditApp> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double borderRadius = 10;
    return KeyboardDismisser(
      child: Center(
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
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Text(
                    widget.title,
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: widget.widget,
                ),
                const SizedBox(
                  height: 30,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // Navigator.pop(context);
                            widget.okFunction?.call();
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              color: FoodHubColors.colorFC6011,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: (widget.cancelText.isNotEmpty)
                                        ? const Radius.circular(0)
                                        : Radius.circular(borderRadius)),
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                widget.okText,
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
                      (widget.cancelText.isNotEmpty)
                          ? Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.cancelFunction?.call();
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: FoodHubColors.colorFFFFFF,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(borderRadius),
                                      ),
                                    ),
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  child: Center(
                                      child: Text(
                                    widget.cancelText,
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
      ),
    );
  }
}
