import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/models/checkout_config.dart';
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

  final CheckoutConfig config;
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
            onCheckoutSelected: (checkoutName) {
              switch (checkoutName) {
                case 'Card':
                  nextWidget = CardCheckoutView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  );
                  break;
                case 'Mpesa':
                  nextWidget = MpesaCheckoutView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  );
                  break;
                case 'Mobile Money':
                  nextWidget = MobileMoneyView(
                    config: widget.config,
                    onCheckoutResponse: widget.onCheckoutResponse,
                  );
                  break;
                case 'Bank Transfer':
                  nextWidget = BankTransferCheckoutView(config: widget.config);
                  break;
              }
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
