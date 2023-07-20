import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/widgets.dart';

class BankAccountDetailsWidget extends StatelessWidget {
  const BankAccountDetailsWidget({
    required this.bankAccountNumber,
    required this.bankName,
  });

  final String bankAccountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Make your transfer to this account',
          style: TextStyle(fontSize: 15, color: appColors.subText),
        ),
        const SizedBox(height: 20),
        KlashaOutlinedInputField(
          labeltext: 'Bank name',
          readOnly: true,
          controller: TextEditingController(text: bankName),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: KlashaOutlinedInputField(
                labeltext: 'Account Number',
                readOnly: true,
                controller: TextEditingController(text: bankAccountNumber),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: bankAccountNumber),
                ).whenComplete(
                  () => KlashaDialogs.showStatusDialog(
                    context,
                    'Account number copied',
                  ),
                );
              },
              splashColor: appColors.primaryLight,
              highlightColor: appColors.primaryLight,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: appColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.copy_rounded, color: appColors.white, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        KlashaOutlinedInputField(
          labeltext: 'Account Name',
          readOnly: true,
          controller: TextEditingController(text: 'Klasha'),
        ),
      ],
    );
  }
}
