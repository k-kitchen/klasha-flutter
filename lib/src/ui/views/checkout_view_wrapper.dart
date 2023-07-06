import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/ui/views/bank_transfer/bank_transfer_view.dart';
import 'package:klasha_checkout/src/ui/views/card/card_view.dart';
import 'package:klasha_checkout/src/ui/views/checkout_options/payment_options_view.dart';
import 'package:klasha_checkout/src/ui/views/mobile_money/mobile_money_view.dart';
import 'package:klasha_checkout/src/ui/views/mpesa/mpesa_view.dart';

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

  Widget _nextWidget;

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
          SizedBox(
            height: 375,
            child: PageView(
              controller: widget.bodyPageController,
              onPageChanged: _onPageChanged,
              children: [
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
