import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/widgets.dart';

import 'package:klasha_checkout_v2/src/shared/shared.dart';

class CardInputForm extends StatelessWidget {
  const CardInputForm({
    this.onCardNumberChanged,
    this.onCardExpiryChanged,
    this.onCardCvvChanged,
    required this.formKey,
  });

  final Function(String)? onCardNumberChanged;
  final Function(String)? onCardExpiryChanged;
  final Function(String)? onCardCvvChanged;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Card',
              style: TextStyle(
                fontSize: 14,
                color: appColors.subText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            KlashaInputField(
              onChanged: onCardNumberChanged,
              hintText: '0000 0000 0000 0000',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
              ],
              validator: KlashaUtils.validateCardNum,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry',
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.subText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      KlashaInputField(
                        onChanged: onCardExpiryChanged,
                        hintText: 'MM / YY',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                          LengthLimitingTextInputFormatter(4),
                          CardMonthInputFormatter(),
                        ],
                        validator: KlashaUtils.validateDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CVV',
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.subText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      KlashaInputField(
                        onChanged: onCardCvvChanged,
                        hintText: '123',
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: KlashaUtils.validateCVC,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
