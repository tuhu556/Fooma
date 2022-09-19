import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/constants/color.dart';

enum Status {
  SUCCESS,
  ERROR,
  UNKNOW,
}

class TextFieldInput extends StatefulWidget {
  final String label;
  final String? hint;
  final String? text;
  final String? textValidateOK;
  final int? maxLength;
  final String? regex;
  final Color? hintColor;
  final double? textHintSize;
  final FontWeight? fontWeight;
  final bool? readOnly;
  final bool? obscureText;
  final TextAlign? gravity;
  final TextEditingController? controllerText;
  final TextInputType keyboardType;
  final Function(String?)? onSave;
  final GestureTapCallback? onTap;
  final Function(String?)? onChanged;
  final TextStyle? textStyle;
  final String? Function(String?)? validatePassword;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final InputBorder? border;
  final Padding? padding;
  final Widget? prefixIcon;

  final bool? enabled;
  const TextFieldInput(
      {Key? key,
      this.hint,
      this.label = '',
      this.text,
      this.textValidateOK,
      this.fontWeight,
      this.maxLength,
      this.controllerText,
      this.obscureText = false,
      this.gravity,
      this.regex,
      this.textHintSize,
      this.hintColor,
      this.keyboardType = TextInputType.text,
      this.onSave,
      this.onChanged,
      this.onTap,
      this.readOnly,
      this.textStyle,
      required this.validatePassword,
      this.textInputAction,
      this.suffixIcon,
      this.onFieldSubmitted,
      this.border,
      this.padding,
      this.prefixIcon,
      this.enabled = true})
      : super(key: key);

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  Status _isStatus = Status.UNKNOW;
  String? validationText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: (widget.label.isNotEmpty)
              ? Text(
                  widget.label,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: FoodHubColors.colorB7B7B7,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: FoodHubColors.colorB7B7B7),
              borderRadius: BorderRadius.circular(10),
              color: FoodHubColors.color007A32),
          child: TextFormField(
            onFieldSubmitted: widget.onFieldSubmitted,
            enabled: widget.enabled,
            onTap: widget.onTap,
            readOnly: widget.readOnly ?? false,
            controller: widget.controllerText,
            maxLength: widget.maxLength,
            style: widget.textStyle ??
                TextStyle(
                    fontSize: 17,
                    color: FoodHubColors.colorFFFFFF,
                    fontWeight: FontWeight.normal),
            textAlign: widget.gravity ?? TextAlign.left,
            cursorColor: FoodHubColors.colorEC407A,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              errorMaxLines: 4,
              counterText: "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorStyle: const TextStyle(color: Colors.transparent, height: 0),
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  fontSize: widget.textHintSize ?? 17,
                  color: widget.hintColor ?? FoodHubColors.colorB7B7B7),
              // ignore: unrelated_type_equality_checks
              suffixIcon: widget.suffixIcon == ''
                  ? _isStatus != Status.UNKNOW
                      ? IconButton(
                          icon: _isStatus == Status.SUCCESS
                              ? SvgPicture.asset(
                                  'assets/icons/check_validate.svg')
                              : SvgPicture.asset(
                                  'assets/icons/cancel_validate.svg'),
                          onPressed: null,
                        )
                      : null
                  : widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
            ),
            keyboardType: widget.keyboardType,
            inputFormatters: (widget.regex != null && widget.regex!.isNotEmpty)
                ? [FilteringTextInputFormatter.allow(RegExp(widget.regex!))]
                : [],
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            obscureText: widget.obscureText ?? false,
            onSaved: widget.onSave,
            validator: (value) {
              validationText = widget.validatePassword?.call(value);
              if (widget.textValidateOK != null) {
                if (validationText != null && validationText!.isNotEmpty) {
                  setState(
                    () {
                      _isStatus = Status.ERROR;
                    },
                  );
                } else {
                  setState(
                    () {
                      _isStatus = Status.SUCCESS;
                    },
                  );
                }
              }
              setState(() {});
              return validationText;
            },
            initialValue: widget.text,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.only(left: 14, top: 2, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              validationText ?? "",
              style: TextStyle(color: FoodHubColors.colorCC0000, fontSize: 14),
            ),
          ),
        ),
        Visibility(
            visible: widget.textValidateOK != null &&
                _isStatus == Status.SUCCESS &&
                widget.textValidateOK!.isNotEmpty,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.textValidateOK ?? '',
                style:
                    TextStyle(color: FoodHubColors.color30A197, fontSize: 12),
              ),
            )),
      ],
    );
  }
}
