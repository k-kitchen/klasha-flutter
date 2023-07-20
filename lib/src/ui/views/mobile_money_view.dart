import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/core/core.dart';
import 'package:klasha_checkout_v2/src/core/services/mobile_money/mobile_money_service_impl.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/code_dialed_section.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/widgets.dart';

class MobileMoneyView extends StatefulWidget {
  const MobileMoneyView({
    super.key,
    required this.config,
    required this.onCheckoutResponse,
  });

  final KlashaCheckoutConfig config;
  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;

  @override
  _MobileMoneyViewState createState() => _MobileMoneyViewState();
}

class _MobileMoneyViewState extends State<MobileMoneyView> {
  late PageController pageController;
  int currentPage = 0;
  MobileMoneyResponse? mobileMoneyResponse;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? fullName, email, phoneNumber, transactionReference;

  String _networkValue = 'Dash';

  @override
  void initState() {
    super.initState();
    email = widget.config.email;
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    setState(() => currentPage = newPage);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.config.email,
                      style: TextStyle(
                        fontSize: 17,
                        color: appColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${widget.config.checkoutCurrency.name} ${KlashaUtils.formatCurrencyInput(widget.config.amount.toString(), true)}',
                      style: TextStyle(
                        fontSize: 17,
                        color: appColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (currentPage == 0)
                Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: appColors.grey),
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
                      items: <String>['Dash', 'Tigo', 'Mtn', 'Vodafone'].map(
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
                        if (val == null) return;
                        setState(() => _networkValue = val);
                      },
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: _onPageChanged,
              clipBehavior: Clip.none,
              physics: NeverScrollableScrollPhysics(),
              children: [
                UserContactForm(
                  onFullNameChanged: (val) => fullName = val,
                  onEmailChanged: (val) => email = val,
                  onPhoneNumberChanged: (val) => phoneNumber = val,
                  formKey: _formKey,
                  initialEmail: widget.config.email,
                ),
                CodeDialedSection(phoneNumber: phoneNumber),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (currentPage == 0)
            PayWithKlashaButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  transactionReference =
                      'klasha-mobile-money-checkout-${DateTime.now().microsecondsSinceEpoch}';
                  MobileMoneyRequestBody mobileMoneyRequestBody =
                      MobileMoneyRequestBody(
                    txRef: transactionReference,
                    amount: widget.config.amount,
                    email: email,
                    phoneNumber: phoneNumber,
                    currency: widget.config.checkoutCurrency.name,
                    narration: 'mobile-money-payment',
                    network: _networkValue,
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse apiResponse = await MobileMoneyServiceImpl()
                      .mobileMoneyPay(mobileMoneyRequestBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    mobileMoneyResponse = apiResponse.data;

                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    KlashaDialogs.showStatusDialog(
                      context,
                      apiResponse.message,
                      !apiResponse.status,
                    );
                  }
                }
              },
            ),
          if (currentPage == 1)
            KlashaPrimaryButton(
              text: 'I have dialed the code',
              onPressed: () async {
                if (mobileMoneyResponse?.data?.id == null) {
                  KlashaDialogs.showStatusDialog(
                    context,
                    'Something went wrong, please try again',
                  );
                  return;
                }

                KlashaDialogs.showLoadingDialog(context);

                ApiResponse apiResponse =
                    await MobileMoneyServiceImpl().verifyPayment(
                  "${mobileMoneyResponse!.data!.id}",
                  "mobile_money_order_id${mobileMoneyResponse!.data!.id}",
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
