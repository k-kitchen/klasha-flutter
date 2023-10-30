import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';

import 'base_button.dart';

class PayWithKlashaButton extends KlashaBaseButton {
  final VoidCallback onPressed;

  const PayWithKlashaButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return KlashaBaseButton(
      onPressed: onPressed,
      borderColor: appColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            KlashaAssets.ic_lock,
            height: 23,
            width: 23,
            fit: BoxFit.cover,
            package: KlashaStrings.packageName,
          ),
          const SizedBox(width: 6),
          Text(
            KlashaStrings.payWith,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          Image.asset(
            KlashaAssets.ic_klasha_white,
            height: 15,
            width: 53,
            fit: BoxFit.cover,
            package: KlashaStrings.packageName,
          ),
        ],
      ),
    );
  }
}

class KlashaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;

  const KlashaPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return KlashaBaseButton(
      onPressed: onPressed,
      buttonText: text,
      borderColor: borderColor ?? appColors.primary,
      buttonColor: buttonColor,
      textColor: textColor,
    );
  }
}

class KlashaOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;

  const KlashaOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor ?? appColors.white,
          border: Border.all(color: appColors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            color: textColor ?? appColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class KlashaCloseButton extends StatelessWidget {
  const KlashaCloseButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appColors.primaryLight,
        ),
        child: Icon(Icons.close_rounded, color: appColors.primary),
      ),
    );
  }
}

class KlashaBackButton extends StatelessWidget {
  const KlashaBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios_rounded, color: appColors.white),
          SizedBox(width: 3),
          Text(
            'Back',
            style: TextStyle(fontSize: 16, color: appColors.white),
          ),
        ],
      ),
    );
  }
}
