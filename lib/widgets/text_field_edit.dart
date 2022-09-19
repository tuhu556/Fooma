import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodhub/constants/color.dart';

enum Status {
  SUCCESS,
  ERROR,
  UNKNOW,
}

class TextFieldEdit extends StatefulWidget {
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
  final InputBorder? borderInput;
  final Padding? padding;
  final Widget? prefixIcon;
  final Border? border;
  final Color? colorBox;
  final bool? enabled;
  final bool? autoFocus;
  const TextFieldEdit({
    Key? key,
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
    this.borderInput,
    this.padding,
    this.prefixIcon,
    this.enabled = true,
    this.border,
    this.colorBox,
    this.autoFocus,
  }) : super(key: key);

  @override
  _TextFieldEditState createState() => _TextFieldEditState();
}

class _TextFieldEditState extends State<TextFieldEdit> {
  Status _isStatus = Status.UNKNOW;
  String? validationText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: (widget.label.isNotEmpty)
                ? Opacity(
                    opacity: 0.7,
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: FoodHubColors.color0B0C0C,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: widget.border,
              color: widget.colorBox ?? FoodHubColors.colorFFFFFF),
          child: TextFormField(
            autofocus: widget.autoFocus ?? false,
            onFieldSubmitted: widget.onFieldSubmitted,
            enabled: widget.enabled,
            onTap: widget.onTap,
            readOnly: widget.readOnly ?? false,
            controller: widget.controllerText,
            maxLength: widget.maxLength,
            style: widget.textStyle ??
                TextStyle(
                    fontSize: 16,
                    color: FoodHubColors.color0B0C0C,
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
              errorStyle: const TextStyle(
                color: Colors.transparent,
                height: 0,
                fontSize: 0,
                fontWeight: FontWeight.w100,
                wordSpacing: 0,
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: widget.fontWeight ?? FontWeight.normal,
                  fontSize: widget.textHintSize ?? 16,
                  color: widget.hintColor ?? FoodHubColors.colorB7B7B7),
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
        validationText != null
            ? Container(
                margin: const EdgeInsets.only(left: 14, top: 2, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    validationText ?? "",
                    style: TextStyle(
                        color: FoodHubColors.colorCC0000, fontSize: 14),
                  ),
                ),
              )
            : Container(),
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
