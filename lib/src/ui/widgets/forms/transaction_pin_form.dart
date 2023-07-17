import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

import 'package:klasha_checkout/src/shared/theme.dart';

class TransactionPinForm extends StatelessWidget {
  const TransactionPinForm({this.onTransactionPinChanged});

  final Function(String)? onTransactionPinChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Enter your transaction pin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appColors.subText,
          ),
        ),
        const SizedBox(height: 20),
        KlashaInputField(
          onChanged: onTransactionPinChanged,
          hintText: 'Pin',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
        ),
      ],
    );
  }
}