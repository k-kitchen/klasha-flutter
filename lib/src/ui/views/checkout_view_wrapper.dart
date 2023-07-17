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
    required this.config,
    required this.onCheckoutResponse,
    required this.pageController,
    required this.onPageChanged,
  });

  final KlashaCheckoutConfig config;
  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final PageController pageController;
  final Function(int) onPageChanged;

  @override
  _CheckoutViewWrapperState createState() => _CheckoutViewWrapperState();
}

class _CheckoutViewWrapperState extends State<CheckoutViewWrapper> {
  int currentIndex = 0;

  Widget? nextWidget;

  void _onPageChanged(int newPage) {
    setState(() => currentIndex = newPage);
    widget.onPageChanged(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: PageView(
        controller: widget.pageController,
        onPageChanged: _onPageChanged,
        children: [
          CheckoutOptionsView(
            checkoutCurrency: widget.config.checkoutCurrency,
            onCheckoutSelected: (type) {
              nextWidget = switch (type) {
                CheckoutType.Card => CardCheckoutView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  ),
                CheckoutType.Mpesa => MpesaCheckoutView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  ),
                CheckoutType.MobileMoney => MobileMoneyView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  ),
                CheckoutType.BankTransfer =>
                  BankTransferCheckoutView(config: widget.config),
              };
              setState(() => null);
              widget.pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          if (nextWidget != null) nextWidget!,
        ],
      ),
    );
  }
}
