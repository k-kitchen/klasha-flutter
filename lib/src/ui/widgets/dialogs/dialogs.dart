import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/shared/assets.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';

class KlashaDialogs {
  static Future<void> showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            height: 70,
            width: 80,
            child: Platform.isIOS
                ? CupertinoActivityIndicator()
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      valueColor: AlwaysStoppedAnimation(appColors.primary),
                    ),
                  ),
          ),
        );
      },
    );
  }

  static Future<void> showStatusDialog(
    BuildContext context,
    String? message, [
    bool hasError = false,
  ]) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: IntrinsicHeight(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    hasError ? KlashaAssets.ic_failed : KlashaAssets.ic_success,
                    height: 40,
                    width: 40,
                    package: KlashaStrings.packageName,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: appColors.text,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
