import 'package:flutter/material.dart';

import '../../shared/shared.dart';

class CheckoutOptionEntry extends StatelessWidget {
  const CheckoutOptionEntry({
    required this.name,
    required this.assetName,
    this.onTap,
  });

  final String name;
  final String assetName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: appColors.primaryLight,
        ),
        padding: EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            Image.asset(
              assetName,
              height: 25,
              width: 25,
              color: appColors.primary,
              fit: BoxFit.cover,
              package: KlashaStrings.packageName,
            ),
            const SizedBox(width: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: appColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
