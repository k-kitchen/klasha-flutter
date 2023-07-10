import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/shared/shared.dart';

class KlashaBaseButton extends StatelessWidget {
  const KlashaBaseButton({
    super.key,
    this.onPressed,
    this.buttonText,
    this.buttonColor,
    this.textColor,
    this.radius = 10,
    this.disabledTextColor,
    this.disabledButtonColor,
    this.borderColor,
    this.child,
  });

  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final double? radius;
  final Color? disabledTextColor;
  final Color? borderColor;
  final Color? disabledButtonColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton(
        textColor: textColor ?? appColors.white,
        onPressed: onPressed,
        color: buttonColor ?? appColors.primary,
        disabledColor: disabledButtonColor ?? appColors.primary.withOpacity(.5),
        disabledTextColor: disabledTextColor ?? appColors.white.withOpacity(.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: borderColor ?? appColors.grey,
            width: 1,
          ),
        ),
        child: child == null
            ? Text(
                buttonText ?? '',
                style: TextStyle(
                  fontSize: 17,
                  color: textColor ?? appColors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            : child,
      ),
    );
  }
}
