import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';

class SecuredByKlasha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          KlashaAssets.ic_lock,
          height: 15,
          width: 15,
          fit: BoxFit.cover,
          color: appColors.text,
          package: KlashaStrings.packageName,
        ),
        const SizedBox(width: 5),
        Text(
          KlashaStrings.securedBy,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 5),
        Image.asset(
          KlashaAssets.ic_klasha,
          height: 15,
          width: 53,
          fit: BoxFit.cover,
          package: KlashaStrings.packageName,
        )
      ],
    );
  }
}
