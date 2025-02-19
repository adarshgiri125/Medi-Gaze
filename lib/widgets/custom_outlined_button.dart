
import 'package:flutter/material.dart';
import 'package:medigaze/core/app_export.dart';
import 'package:medigaze/theme/custom_text_style.dart';
import 'package:medigaze/widgets/base_button.dart';

class CustomOutlinedButton extends BaseButton {
  CustomOutlinedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.label,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    Alignment? alignment,
    double? height,
    double? width,
    EdgeInsets? margin,
    required String text,
    this.textStyle,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          alignment: alignment,
          width: width,
          margin: margin,
        );

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final Widget? label;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildOutlinedButtonWidget,
          )
        : buildOutlinedButtonWidget;
  }

  @override
  Widget get buildOutlinedButtonWidget => Container(
        height: this.height ?? 40.v,
        width: this.width ?? double.maxFinite,
        margin: margin,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: OutlinedButton(
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.black)), // Set border color
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              )),
            ),
            onPressed: isDisabled ?? false ? null : onPressed ?? () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leftIcon ?? const SizedBox.shrink(),
                Text(
                  text,
                  style:
                      (textStyle ?? CustomTextStyles.titleSmallOpenSansOnError)
                          .copyWith(
                    color: textStyle?.color ?? Colors.blue, // Set text color
                  ),
                ),
                rightIcon ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
}
