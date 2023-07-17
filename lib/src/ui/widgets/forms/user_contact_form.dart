import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

import '../../../shared/shared.dart';

class UserContactForm extends StatelessWidget {
  const UserContactForm({
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPhoneNumberChanged,
    required this.formKey,
    this.initialEmail,
  });

  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneNumberChanged;
  final GlobalKey<FormState> formKey;
  final String? initialEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              fontSize: 14,
              color: appColors.subText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          KlashaInputField(
            onChanged: onFullNameChanged,
            hintText: 'John Doe',
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\d+')),
            ],
            validator: (input) =>
                KlashaUtils.validateRequiredFields(input, 'Full Name'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.subText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    KlashaInputField(
                      onChanged: onEmailChanged,
                      hintText: 'john@gmail.com',
                      initialText: initialEmail,
                      validator: KlashaUtils.validateEmail,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone number',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.subText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    KlashaInputField(
                      onChanged: onPhoneNumberChanged,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      hintText: '0123456789',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (input) => KlashaUtils.validateRequiredFields(
                        input,
                        'Phone Number',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
