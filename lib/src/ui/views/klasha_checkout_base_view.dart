import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/views/payment_status_view.dart';
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
  KlashaCheckoutResponse? checkoutResponse;
  int currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    ApiUrls.getBaseUrl(widget.environment);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHeader(context),
              checkoutResponse == null
                  ? CheckoutViewWrapper(
                      email: widget.email,
                      amount: widget.amount,
                      checkoutCurrency: widget.checkoutCurrency,
                      onCheckoutResponse: (KlashaCheckoutResponse response) {
                        checkoutResponse = response;
                        widget.onComplete(response);
                        setState(() {});
                      },
                      pageController: pageController,
                      onPageChanged: (newIndex) {
                        setState(() {});
                        currentIndex = newIndex;
                      },
                      environment: widget.environment,
                    )
                  : PaymentStatusView(
                      paymentStatus: checkoutResponse!.status,
                      onAction: () {
                        if (checkoutResponse!.status) {
                          Navigator.pop(context);
                        } else {
                          checkoutResponse = null;
                        }
                        setState(() {});
                      },
                    ),
              SecuredByKlasha(),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentIndex == 0
              ? SizedBox.shrink()
              : KlashaBackButton(
                  onTap: () {
                    pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
          KlashaCloseButton(
            onTap: () {
              Navigator.pop(context);
              checkoutResponse = KlashaCheckoutResponse(
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
