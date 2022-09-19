import 'package:flutter/material.dart';
import 'package:foodhub/constants/color.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedSize(
        duration: const Duration(milliseconds: 500),
        child: ConstrainedBox(
          constraints: widget.isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 60.0),
          child: Text(
            widget.text,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
      widget.isExpanded == true
          ? TextButton(
              child: Text(
                'Show less',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: FoodHubColors.colorFC6011,
                ),
              ),
              onPressed: () => setState(() => widget.isExpanded = false))
          : Container(),
      widget.isExpanded
          ? ConstrainedBox(constraints: const BoxConstraints())
          : TextButton(
              child: Text(
                'Show more',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: FoodHubColors.colorFC6011,
                ),
              ),
              onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
