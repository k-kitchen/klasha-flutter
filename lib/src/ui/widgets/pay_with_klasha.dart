import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/shared/assets.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/shared/strings.dart';

class PayWithKlasha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PAY WITH',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: appColors.subText,
            ),
          ),
          Image.asset(
            'assets/images/ic_klasha.png',
            height: 22,
            width: 82,
            fit: BoxFit.cover,
            package: KlashaStrings.packageName,
          ),
        ],
      ),
    );
  }
}
