import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/views/payment_status/payment_status_view.dart';
import 'package:klasha_checkout/src/ui/views/views.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class KlashaCheckoutBaseView extends StatefulWidget {
  const KlashaCheckoutBaseView({
    super.key,
    required this.email,
    required this.amount,
    required this.checkoutCurrency,
    required this.onComplete,
    required this.environment,
  });

  final String email;
  final int amount;
  final CheckoutCurrency checkoutCurrency;
  final OnCheckoutResponse<KlashaCheckoutResponse> onComplete;
  final Environment environment;

  @override
  _KlashaCheckoutBaseViewState createState() => _KlashaCheckoutBaseViewState();
}

class _KlashaCheckoutBaseViewState extends State<KlashaCheckoutBaseView> {
  KlashaCheckoutResponse? _klashaCheckoutResponse;
  int _currentIndex = 0;

  late PageController _bodyPageController;

  @override
  void initState() {
    super.initState();
    _bodyPageController = PageController();
    ApiUrls.getBaseUrl(widget.environment);
  }

  @override
  void dispose() {
    // _bodyPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(context),
          AnimatedSwitcher(
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
                    environment: widget.environment,
                  )
                : PaymentStatusView(
                    paymentStatus: _klashaCheckoutResponse!.status,
                    onAction: () {
                      if (_klashaCheckoutResponse!.status) {
                        Navigator.pop(context);
                      } else {
                        _klashaCheckoutResponse = null;
                      }
                      setState(() {});
                    },
                  ),
          ),
          SecuredByKlasha(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Container buildHeader(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentIndex == 0
              ? SizedBox.shrink()
              : KlashaBackButton(
                  onTap: () {
                    _bodyPageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
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
    );
  }
}
