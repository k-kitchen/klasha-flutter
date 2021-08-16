import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/shared/shared.dart';

import 'base_button.dart';

class PayWithKlashaButton extends KlashaBaseButton {
  final VoidCallback onPressed;

  const PayWithKlashaButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

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
            height: 25,
            width: 25,
            fit: BoxFit.cover,
            package: KlashaStrings.packageName,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            KlashaStrings.payWith,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
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
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const KlashaPrimaryButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

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
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const KlashaOutlineButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      height: 50,
      minWidth: 140,
      onPressed: onPressed,
      color: buttonColor ?? appColors.white,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: appColors.grey,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          color: textColor ?? appColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class KlashaCloseButton extends StatelessWidget {
  const KlashaCloseButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

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
        child: Icon(
          Icons.close_rounded,
          color: appColors.primary,
        ),
      ),
    );
  }
}

class KlashaBackButton extends StatelessWidget {
  const KlashaBackButton({
    Key key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            color: appColors.white,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            'Back',
            style: TextStyle(
              fontSize: 16,
              color: appColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
