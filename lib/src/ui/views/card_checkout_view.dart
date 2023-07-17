import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/card/card_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class CardCheckoutView extends StatefulWidget {
  const CardCheckoutView({
    super.key,
    required this.onCheckoutResponse,
    required this.config,
  });

  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final KlashaCheckoutConfig config;

  @override
  _CardCheckoutViewState createState() => _CardCheckoutViewState();
}

class _CardCheckoutViewState extends State<CardCheckoutView> {
  late PageController pageController;
  int currentPage = 0;
  String? cardNumber, cardExpiry, cardCvv, transactionPin, otp;
  AddBankCardResponse? addBankCardResponse;
  AuthenticateBankCardResponse? authBankCardResponse;
  var cardFormKey = GlobalKey<FormState>();
  var userFormKey = GlobalKey<FormState>();
  String? otpMessage = '';
  String? fullName, email, phoneNumber, transactionReference;

  @override
  void initState() {
    super.initState();
    email = widget.config.email;
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.config.email,
            style: TextStyle(
              fontSize: 17,
              color: appColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${widget.config.checkoutCurrency.name} ${widget.config.amount.toString()}',
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
                  initialEmail: widget.config.email,
                  formKey: userFormKey,
                ),
                CardInputForm(
                  onCardNumberChanged: (val) => cardNumber = val,
                  onCardExpiryChanged: (val) => cardExpiry = val,
                  onCardCvvChanged: (val) => cardCvv = val,
                  formKey: cardFormKey,
                ),
                TransactionPinForm(
                  onTransactionPinChanged: (val) => transactionPin = val,
                ),
                OTPForm(
                  onOtpChanged: (val) => otp = val,
                  message: otpMessage ?? '',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (currentPage == 1)
            PayWithKlashaButton(
              onPressed: () async {
                if (cardFormKey.currentState?.validate() ?? false) {
                  transactionReference =
                      'klasha-add-bank-card-${DateTime.now().microsecondsSinceEpoch}';
                  String? formattedCardNumber =
                      cardNumber?.replaceAll(RegExp(r"[^0-9]"), '');
                  String? cardExpiryYear =
                      cardExpiry?.split(RegExp(r'(\/)')).last;
                  String? cardExpiryMonth =
                      cardExpiry?.split(RegExp(r'(\/)')).first;
                  BankCardDetailsBody bankCardDetailsBody = BankCardDetailsBody(
                    cardNumber: formattedCardNumber,
                    expiryMonth: cardExpiryMonth,
                    expiryYear: cardExpiryYear,
                    cvv: cardCvv,
                    currency: widget.config.checkoutCurrency.name,
                    amount: widget.config.amount.toString(),
                    rate: 1,
                    sourceCurrency: widget.config.checkoutCurrency.name,
                    rememberMe: false,
                    redirectUrl: 'https://dashboard.klasha.com/woocommerce',
                    phoneNumber: phoneNumber,
                    email: widget.config.email,
                    fullName: fullName,
                    txRef: transactionReference,
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse<AddBankCardResponse> apiResponse =
                      await CardServiceImpl().addBankCard(bankCardDetailsBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    addBankCardResponse = apiResponse.data;
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (apiResponse.status &&
                      apiResponse.data == null &&
                      apiResponse.message == 'Payment Successful') {
                    widget.onCheckoutResponse(
                      KlashaCheckoutResponse(
                        status: true,
                        message: 'Payment Successful',
                        transactionReference: transactionReference,
                      ),
                    );
                  } else {
                    KlashaDialogs.showStatusDialog(
                        context, apiResponse.message);
                  }
                }
              },
            ),
          if (currentPage != 1)
            KlashaPrimaryButton(
              text: 'Continue',
              onPressed: () async {
                if (currentPage == 0) {
                  if (userFormKey.currentState?.validate() ?? false) {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
                // authenticate payment
                if (currentPage == 2) {
                  AuthenticateCardPaymentBody authenticateCardPaymentBody =
                      AuthenticateCardPaymentBody(
                    mode: 'pin',
                    pin: transactionPin,
                    txRef: addBankCardResponse?.txRef,
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse<AuthenticateBankCardResponse> apiResponse =
                      await CardServiceImpl()
                          .authenticateCardPayment(authenticateCardPaymentBody);

                  Navigator.pop(context);

                  if (apiResponse.status ||
                      apiResponse.data?.status == 'pending') {
                    otpMessage = apiResponse.data?.message;
                    authBankCardResponse = apiResponse.data;
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else if (apiResponse.data?.status != 'pending' &&
                      apiResponse.status) {
                    /// payment is successful
                    ///
                    widget.onCheckoutResponse(
                      KlashaCheckoutResponse(
                        status: true,
                        message: 'Payment Successful',
                        transactionReference: transactionReference,
                      ),
                    );
                  } else if (!apiResponse.status) {
                    KlashaDialogs.showStatusDialog(
                      context,
                      apiResponse.message,
                    );
                  }
                }

                // validate payment
                if (currentPage == 3) {
                  ValidateCardPaymentBody validateCardPaymentBody =
                      ValidateCardPaymentBody(
                    flwRef: authBankCardResponse?.flwRef,
                    otp: otp,
                    type: 'card',
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse<ValidateBankCardResponse> apiResponse =
                      await CardServiceImpl()
                          .validateCardPayment(validateCardPaymentBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    widget.onCheckoutResponse(
                      KlashaCheckoutResponse(
                        status: true,
                        message: 'Payment Successful',
                        transactionReference: transactionReference,
                      ),
                    );
                  } else {
                    // KlashaDialogs.showStatusDialog(context, apiResponse.message);
                    widget.onCheckoutResponse(
                      KlashaCheckoutResponse(
                        status: false,
                        message:
                            apiResponse.message ?? 'Payment Not Successful',
                        transactionReference: transactionReference,
                      ),
                    );
                  }
                }
              },
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
