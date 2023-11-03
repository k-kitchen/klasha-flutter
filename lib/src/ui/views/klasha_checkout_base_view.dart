import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/core/core.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/views/payment_status_view.dart';
import 'package:klasha_checkout_v2/src/ui/views/views.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/widgets.dart';

class KlashaCheckoutBaseView extends StatefulWidget {
  const KlashaCheckoutBaseView(this.config, {super.key});

  final KlashaCheckoutConfig config;

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
    ApiUrls.setBaseUrl(widget.config.environment);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ConstrainedBox(
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
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildHeader(context),
                checkoutResponse == null
                    ? CheckoutViewWrapper(
                        config: widget.config,
                        onCheckoutResponse: (KlashaCheckoutResponse response) {
                          checkoutResponse = response;
                          widget.config.onComplete(response);
                          if(mounted)setState(() {});
                        },
                        pageController: pageController,
                        onPageChanged: (newIndex) {
                          if(mounted)setState(() {});
                          currentIndex = newIndex;
                        },
                      )
                    : PaymentStatusView(
                        paymentStatus: checkoutResponse!.status,
                        message: checkoutResponse?.message,
                        onAction: () {
                          if (checkoutResponse!.status) {
                            Navigator.pop(context);
                          } else {
                            checkoutResponse = null;
                          }
                          setState(() {});
                        },
                      ),
                const SizedBox(height: 15),
                SecuredByKlasha(),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
              ],
            ),
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
          checkoutResponse != null || currentIndex == 0
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
              // checkoutResponse = KlashaCheckoutResponse(
              //   message: 'User Cancelled',
              //   status: false,
              //   transactionReference: '',
              // );
            },
          ),
        ],
      ),
    );
  }
}
