import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/views/payment_status/payment_status_view.dart';
import 'package:klasha_checkout/src/ui/views/views.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class KlashaCheckoutBaseView extends StatefulWidget {
  const KlashaCheckoutBaseView({
    Key key,
    this.email,
    this.amount,
    this.checkoutCurrency,
    this.onComplete,
  }) : super(key: key);

  final String email;
  final int amount;
  final CheckoutCurrency checkoutCurrency;
  final OnCheckoutResponse<KlashaCheckoutResponse> onComplete;

  @override
  _KlashaCheckoutBaseViewState createState() => _KlashaCheckoutBaseViewState();
}

class _KlashaCheckoutBaseViewState extends State<KlashaCheckoutBaseView> {
  KlashaCheckoutResponse _klashaCheckoutResponse;
  int _currentIndex = 0;

  /// to be removed
  PageController _bodyPageController;

  @override
  void initState() {
    super.initState();
    _bodyPageController = PageController();
  }

  @override
  void dispose() {
    // _bodyPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
              color: appColors.primary,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex == 0)
                  SizedBox.shrink()
                else
                // back button
                  KlashaBackButton(
                    onTap: () {
                      _bodyPageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),

                // close button
                KlashaCloseButton(
                  onTap: () {
                    Navigator.pop(context);
                    _klashaCheckoutResponse = KlashaCheckoutResponse(
                      message: 'User Cancelled',
                      status: false,
                      transactionReference: '',
                    );
                  },
                ),
              ],
            ),
          ),

          // pay with klasha
          // PayWithKlasha(),

          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _klashaCheckoutResponse == null
                  ? CheckoutViewWrapper(
                email: widget.email,
                amount: widget.amount,
                checkoutCurrency: widget.checkoutCurrency,
                onCheckoutResponse: (KlashaCheckoutResponse response) {
                  _klashaCheckoutResponse = response;
                  widget.onComplete(response);
                  setState(() {});
                },
                bodyPageController: _bodyPageController,
                onPageChanged: (newIndex) {
                  setState(() {});

                  _currentIndex = newIndex;
                },
              )
                  : PaymentStatusView(
                paymentStatus: _klashaCheckoutResponse.status,
                onAction: () {
                  if (_klashaCheckoutResponse.status) {
                    Navigator.pop(context);
                  } else {
                    _klashaCheckoutResponse = null;
                  }
                  setState(() {});
                },
              ),
            ),
          ),

          SecuredByKlasha(),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
