import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class OTPForm extends StatelessWidget {
  const OTPForm({this.onOtpChanged, required this.message});

  final Function(String)? onOtpChanged;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appColors.subText,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(fontSize: 15, color: appColors.subText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        KlashaInputField(
          onChanged: onOtpChanged,
          hintText: 'OTP',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'\d+')),
            LengthLimitingTextInputFormatter(6),
          ],
        ),
      ],
    );
  }
}
