import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/mobile_money/mobile_money_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class MobileMoneyView extends StatefulWidget {
  const MobileMoneyView({
    super.key,
    this.onCheckoutResponse,
    this.amount,
    this.email,
  });

  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final String email;
  final int amount;

  @override
  _MobileMoneyViewState createState() => _MobileMoneyViewState();
}

class _MobileMoneyViewState extends State<MobileMoneyView> {
  PageController _pageController;
  int _currentPage = 0;
  MobileMoneyResponse _mobileMoneyResponse;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String transactionReference;

  String _fullName;
  String _email;
  String _phoneNumber;

  String _networkValue = 'Dash';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 17,
                      color: appColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'GHS ${KlashaUtils.formatCurrencyInput(widget.amount.toString(), true)}',
                    style: TextStyle(
                      fontSize: 17,
                      color: appColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (_currentPage == 0)
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: appColors.grey,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                  child: Center(
                    child: DropdownButton<String>(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      icon: Transform.rotate(
                        angle: 90 * (math.pi / 180),
                        child: Icon(Icons.chevron_right_rounded),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.text,
                        fontWeight: FontWeight.w400,
                      ),
                      value: _networkValue,
                      items: <String>[
                        'Dash',
                        'Tigo',
                        'Mtn',
                        'Vodafone',
                      ].map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(
                                fontSize: 14,
                                color: appColors.text,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(() {
                          _networkValue = val;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              clipBehavior: Clip.none,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _MobileMoneyInputForm(
                  onFullNameChanged: (val) => _fullName = val,
                  onEmailChanged: (val) => _email = val,
                  onPhoneNumberChanged: (val) => _phoneNumber = val,
                  formKey: _formKey,
                ),
                _CodeDialedSection(
                  phoneNumber: _phoneNumber,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_currentPage == 0)
            PayWithKlashaButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  transactionReference = 'klasha-mobile-money-checkout-${DateTime.now().microsecondsSinceEpoch}';
                  MobileMoneyRequestBody mobileMoneyRequestBody =
                  MobileMoneyRequestBody(
                      txRef: transactionReference,
                      amount: 1000,
                      email: _email,
                      phoneNumber: _phoneNumber,
                      currency: 'GHS',
                      narration: 'mobile-money-payment',
                      network: _networkValue);

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse apiResponse = await MobileMoneyServiceImpl()
                      .mobileMoneyPay(mobileMoneyRequestBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    _mobileMoneyResponse = apiResponse.data;

                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    KlashaDialogs.showStatusDialog(context, apiResponse.message);
                    // log('something went wrong, try again');
                  }
                }
              },
            ),
          if (_currentPage == 1)
            KlashaPrimaryButton(
              text: 'I have dialed the code',
              onPressed: () async {
                KlashaDialogs.showLoadingDialog(context);

                ApiResponse apiResponse =
                    await MobileMoneyServiceImpl().verifyPayment(
                  "${_mobileMoneyResponse.data.id}",
                  "mobile_money_order_id${_mobileMoneyResponse.data.id}",
                );

                Navigator.pop(context);

                if (apiResponse.status) {
                  widget.onCheckoutResponse(
                    KlashaCheckoutResponse(
                      status: true,
                      message: 'Payment Successful',
                      transactionReference: transactionReference,
                    ),
                  );
                } else {
                  widget.onCheckoutResponse(
                    KlashaCheckoutResponse(
                      status: false,
                      message: apiResponse.message ?? 'Payment Not Successful',
                      transactionReference: transactionReference,
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _MobileMoneyInputForm extends StatelessWidget {
  const _MobileMoneyInputForm({
    super.key,
    this.onFullNameChanged,
    this.onEmailChanged,
    this.onPhoneNumberChanged,
    this.formKey,
  });

  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneNumberChanged;
  final GlobalKey<FormState> formKey;

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
          const SizedBox(
            height: 5,
          ),
          KlashaInputField(
            onChanged: onFullNameChanged,
            hintText: 'John Doe',
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\d+')),
            ],
            validator: (input) =>  KlashaUtils.validateRequiredFields(input, 'Full Name'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 20,
          ),
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
                    const SizedBox(
                      height: 5,
                    ),
                    KlashaInputField(
                      onChanged: onEmailChanged,
                      hintText: 'john@gmail.com',
                      validator: KlashaUtils.validateEmail,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
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
                    const SizedBox(
                      height: 5,
                    ),
                    KlashaInputField(
                      onChanged: onPhoneNumberChanged,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      hintText: '0123456789',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (input) =>  KlashaUtils.validateRequiredFields(input, 'Phone Number'),
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

class _CodeDialedSection extends StatelessWidget {
  const _CodeDialedSection({
    super.key,
    this.phoneNumber,
  });

  final String phoneNumber;

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
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please dial the code that was sent to the mobile number $phoneNumber',
          style: TextStyle(
            fontSize: 15,
            color: appColors.subText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
