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
  final double radius;
  final Color? disabledTextColor;
  final Color? borderColor;
  final Color? disabledButtonColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.disabled)
                  ? disabledButtonColor ?? appColors.primary.withOpacity(.5)
                  : buttonColor ?? appColors.primary;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.disabled)
                  ? disabledTextColor ?? appColors.white.withOpacity(.5)
                  : textColor ?? appColors.white;
            },
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: borderColor ?? appColors.grey, width: 1),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
        ),
        onPressed: onPressed,
        child: child == null
            ? Text(
                buttonText ?? '',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              )
            : child,
      ),
    );
  }
}
