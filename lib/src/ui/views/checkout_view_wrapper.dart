import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/views/bank_transfer/bank_transfer_view.dart';
import 'package:klasha_checkout/src/ui/views/card/card_view.dart';
import 'package:klasha_checkout/src/ui/views/checkout_options/payment_options_view.dart';
import 'package:klasha_checkout/src/ui/views/mobile_money/mobile_money_view.dart';
import 'package:klasha_checkout/src/ui/views/mpesa/mpesa_view.dart';
import 'package:klasha_checkout/src/ui/views/payment_status/payment_status_view.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class CheckoutViewWrapper extends StatefulWidget {
  const CheckoutViewWrapper({
    super.key,
    this.onCheckoutResponse,
    this.email,
    this.amount,
    this.bodyPageController,
    this.onPageChanged,
    this.checkoutCurrency,
    this.environment,
  });

  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final String email;
  final int amount;
  final PageController bodyPageController;
  final Function(int) onPageChanged;
  final CheckoutCurrency checkoutCurrency;
  final Environment environment;

  @override
  _CheckoutViewWrapperState createState() => _CheckoutViewWrapperState();
}

class _CheckoutViewWrapperState extends State<CheckoutViewWrapper> {
  // PageController _bodyPageController;
  int _currentIndex = 0;

  final _paymentNames = [
    'Card',
    'Mpesa',
    'M-Money',
    'Transfer',
  ];

  final _paymentImages = [
    KlashaAssets.ic_card,
    KlashaAssets.ic_mpesa,
    KlashaAssets.ic_mpesa,
    KlashaAssets.ic_transfer,
  ];

  Widget _nextWidget;

  // @override
  // void initState() {
  //   super.initState();
  //   _bodyPageController = PageController();
  // }
  //
  // @override
  // void dispose() {
  //   _bodyPageController.dispose();
  //   super.dispose();
  // }

  void _onPageChanged(int newPage) {
    setState(
          () => _currentIndex = newPage,
    );
    widget.onPageChanged(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          // pageview
          SizedBox(
            height: 375,
            child: PageView(
              controller: widget.bodyPageController,
              onPageChanged: _onPageChanged,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                // payment options
                CheckoutOptionsView(
                  checkoutCurrency: widget.checkoutCurrency,
                  onCheckoutSelected: (checkoutName) {
                    switch (checkoutName) {
                      case 'Card':
                        _nextWidget = // card page
                        CardCheckoutView(
                            onCheckoutResponse: widget.onCheckoutResponse,
                            email: widget.email,
                            amount: widget.amount,
                            checkoutCurrency: widget.checkoutCurrency,
                        );
                        break;
                      case 'Mpesa':
                        _nextWidget = // mpesa page
                        MpesaCheckoutView(
                          onCheckoutResponse: widget.onCheckoutResponse,
                          email: widget.email,
                          amount: widget.amount,
                        );
                        break;
                      case 'Mobile Money':
                        _nextWidget = // mobile money
                        MobileMoneyView(
                          onCheckoutResponse: widget.onCheckoutResponse,
                          email: widget.email,
                          amount: widget.amount,
                        );
                        break;
                      case 'Bank Transfer':
                        _nextWidget =
                        // transfer page
                        BankTransferCheckoutView(
                          email: widget.email,
                          amount: widget.amount,
                        );
                        break;
                    }
                    setState(() => null);
                    widget.bodyPageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),

                if (_nextWidget != null) _nextWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTypeEntry extends StatelessWidget {
  const _PaymentTypeEntry({
    super.key,
    this.paymentName,
    this.assetName,
    this.onTap,
    this.isSelected,
  });

  final String paymentName;
  final String assetName;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: 80,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isSelected ? appColors.primaryLight : appColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetName,
              height: 25,
              width: 25,
              color: isSelected ? appColors.primary : appColors.subText,
              fit: BoxFit.cover,
              package: KlashaStrings.packageName,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              paymentName,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? appColors.primary : appColors.subText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
