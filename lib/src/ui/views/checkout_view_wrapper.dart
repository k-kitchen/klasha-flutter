import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/ui/views/bank_transfer_view.dart';
import 'package:klasha_checkout/src/ui/views/card_checkout_view.dart';
import 'package:klasha_checkout/src/ui/views/checkout_options_view.dart';
import 'package:klasha_checkout/src/ui/views/mobile_money_view.dart';
import 'package:klasha_checkout/src/ui/views/mpesa_view.dart';

class CheckoutViewWrapper extends StatefulWidget {
  const CheckoutViewWrapper({
    super.key,
    required this.onCheckoutResponse,
    required this.email,
    required this.amount,
    required this.bodyPageController,
    required this.onPageChanged,
    required this.checkoutCurrency,
    required this.environment,
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

  Widget? nextWidget;

  void _onPageChanged(int newPage) {
    setState(() => _currentIndex = newPage);
    widget.onPageChanged(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.bodyPageController,
      onPageChanged: _onPageChanged,
      children: [
        CheckoutOptionsView(
          checkoutCurrency: widget.checkoutCurrency,
          onCheckoutSelected: (checkoutName) {
            switch (checkoutName) {
              case 'Card':
                nextWidget = CardCheckoutView(
                  onCheckoutResponse: widget.onCheckoutResponse,
                  email: widget.email,
                  amount: widget.amount,
                  checkoutCurrency: widget.checkoutCurrency,
                );
                break;
              case 'Mpesa':
                nextWidget = MpesaCheckoutView(
                  onCheckoutResponse: widget.onCheckoutResponse,
                  email: widget.email,
                  amount: widget.amount,
                );
                break;
              case 'Mobile Money':
                nextWidget = MobileMoneyView(
                  onCheckoutResponse: widget.onCheckoutResponse,
                  email: widget.email,
                  amount: widget.amount,
                );
                break;
              case 'Bank Transfer':
                nextWidget = BankTransferCheckoutView(
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
        if (nextWidget != null) nextWidget!,
      ],
    );
  }
}
