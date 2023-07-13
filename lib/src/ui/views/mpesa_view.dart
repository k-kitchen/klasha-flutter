import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/mpesa/mpesa_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/user_contact_form.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/code_dialed_section.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class MpesaCheckoutView extends StatefulWidget {
  const MpesaCheckoutView({
    super.key,
    required this.onCheckoutResponse,
    required this.email,
    required this.amount,
  });

  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final String email;
  final int amount;

  @override
  _MpesaCheckoutViewState createState() => _MpesaCheckoutViewState();
}

class _MpesaCheckoutViewState extends State<MpesaCheckoutView> {
  late PageController pageController;
  int currentPage = 0;
  MpesaCheckoutResponse? mpesaCheckoutResponse;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? fullName, email, phoneNumber, transactionReference;

  @override
  void initState() {
    super.initState();
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
          Text(
            widget.email,
            style: TextStyle(
              fontSize: 17,
              color: appColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'KES ${KlashaUtils.formatCurrencyInput(widget.amount.toString(), true)}',
            style: TextStyle(
              fontSize: 17,
              color: appColors.text,
              fontWeight: FontWeight.w600,
            ),
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
                      'klasha-mpesa-checkout-${DateTime.now().microsecondsSinceEpoch}';
                  MpesaRequestBody mpesaRequestBody = MpesaRequestBody(
                    currency: 'KES',
                    amount: '1000',
                    rate: 1,
                    sourceCurrency: 'KES',
                    rememberMe: false,
                    redirectUrl: 'https://dashboard.klasha.com/woocommerce',
                    phoneNumber: 'phone_number',
                    email: email,
                    fullName: fullName,
                    txRef: transactionReference,
                    option: 'mpesa',
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse apiResponse =
                      await MpesaServiceImpl().paywithMpesa(mpesaRequestBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    mpesaCheckoutResponse = apiResponse.data;
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    KlashaDialogs.showStatusDialog(
                      context,
                      apiResponse.message,
                    );
                  }
                }
              },
            ),
          if (currentPage == 1)
            KlashaPrimaryButton(
              text: 'I have dialed the code',
              onPressed: () async {
                if (mpesaCheckoutResponse?.data?.id == null) {
                  KlashaDialogs.showStatusDialog(
                    context,
                    'Something went wrong, please try again',
                  );
                  return;
                }
                KlashaDialogs.showLoadingDialog(context);

                ApiResponse apiResponse =
                    await MpesaServiceImpl().verifyPayment(
                  "${mpesaCheckoutResponse!.data!.id}",
                  "mpesa_order_id_${mpesaCheckoutResponse!.data!.id}",
                );

                Navigator.pop(context);

                widget.onCheckoutResponse(
                  KlashaCheckoutResponse(
                    status: apiResponse.status,
                    message: apiResponse.status
                        ? 'Payment Successful'
                        : apiResponse.message ?? 'Payment Not Successful',
                    transactionReference: transactionReference,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
