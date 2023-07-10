import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class CodeDialedSection extends StatelessWidget {
  const CodeDialedSection({required this.phoneNumber});

  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Dial Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appColors.subText,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Please dial the code that was sent to the mobile number $phoneNumber',
          style: TextStyle(fontSize: 15, color: appColors.subText),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}