import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/core/core.dart';
import 'package:klasha_checkout_v2/src/core/services/card/card_service_impl.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/forms/card_redirect_form.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/forms/transaction_verification_form.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/widgets.dart';

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
  AuthenticateBankCardResponse? authBankCardResponse;
  var cardFormKey = GlobalKey<FormState>();
  var userFormKey = GlobalKey<FormState>();
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
                  message: authBankCardResponse?.message ?? '',
                ),
                CardRedirectForm(
                  redirectUrl: authBankCardResponse?.redirectUrl ?? '',
                  flwRef: authBankCardResponse?.flwRef ?? '',
                  onClose: (value) {
                    if (value) {
                      _onSuccess();
                      return;
                    }
                    _moveToPage(5);
                  },
                ),
                TransactionVerificationForm(
                  txnRef: authBankCardResponse?.txRef ?? '',
                  onVerified: _onSuccess,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Builder(builder: (_) {
            return switch (currentPage) {
              0 => KlashaPrimaryButton(
                  text: 'Continue',
                  onPressed: () async {
                    if (userFormKey.currentState?.validate() ?? false) {
                      _moveToPage(1);
                    }
                  },
                ),
              1 => PayWithKlashaButton(onPressed: _addBankCard),
              2 => KlashaPrimaryButton(
                  text: 'Continue',
                  onPressed: _validatePin,
                ),
              3 => KlashaPrimaryButton(
                  text: 'Continue',
                  onPressed: _validateOtp,
                ),
              _ => const SizedBox(),
            };
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _addBankCard() async {
    if (cardFormKey.currentState?.validate() ?? false) {
      transactionReference =
          'klasha-add-bank-card-${DateTime.now().microsecondsSinceEpoch}';
      String? formattedCardNumber =
          cardNumber?.replaceAll(RegExp(r"[^0-9]"), '');
      String? cardExpiryYear = cardExpiry?.split(RegExp(r'(/)')).last;
      String? cardExpiryMonth = cardExpiry?.split(RegExp(r'(/)')).first;
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

      final apiResponse =
          await CardServiceImpl().addBankCard(bankCardDetailsBody);

      Navigator.pop(context);

      if (apiResponse.status &&
          apiResponse.data == null &&
          apiResponse.message == 'Payment Successful') {
        widget.onCheckoutResponse(
          KlashaCheckoutResponse(
            status: true,
            message: 'Payment Successful',
            transactionReference: transactionReference,
          ),
        );
      } else if (apiResponse.status) {
        authBankCardResponse = apiResponse.data;
        switch (apiResponse.data?.authMode) {
          case AuthMode.pin:
            _moveToPage(2);
          case AuthMode.redirect:
            _moveToPage(4);
          case AuthMode.avs_noauth:
            KlashaDialogs.showStatusDialog(
              context,
              'Card not supported',
              false,
            );
          default:
            KlashaDialogs.showStatusDialog(
              context,
              'Card not supported',
              false,
            );
        }
      } else {
        KlashaDialogs.showStatusDialog(
          context,
          apiResponse.message,
          !apiResponse.status,
        );
      }
    }
  }

  Future<void> _validatePin() async {
    AuthenticateCardPaymentBody authenticateCardPaymentBody =
        AuthenticateCardPaymentBody(
      currency: widget.config.checkoutCurrency.name,
      email: widget.config.email,
      amount: '${widget.config.amount}',
      mode: 'pin',
      pin: transactionPin,
      txRef: authBankCardResponse?.txRef,
    );

    KlashaDialogs.showLoadingDialog(context);

    ApiResponse<AuthenticateBankCardResponse> apiResponse =
        await CardServiceImpl()
            .authenticateCardPayment(authenticateCardPaymentBody);

    Navigator.pop(context);
    if (!apiResponse.status) {
      KlashaDialogs.showStatusDialog(
        context,
        apiResponse.message,
        !apiResponse.status,
      );
      return;
    }
    if (apiResponse.data?.status == 'pending') {
      authBankCardResponse = apiResponse.data;
      _moveToPage(3);
    } else if (apiResponse.data?.status != 'pending') {
      _onSuccess();
    }
  }

  Future<void> _validateOtp() async {
    ValidateCardPaymentBody validateCardPaymentBody = ValidateCardPaymentBody(
      currency: widget.config.checkoutCurrency.name,
      flwRef: authBankCardResponse?.flwRef,
      otp: otp,
      type: 'card',
    );

    KlashaDialogs.showLoadingDialog(context);

    ApiResponse<ValidateBankCardResponse> apiResponse =
        await CardServiceImpl().validateCardPayment(validateCardPaymentBody);

    Navigator.pop(context);

    if (apiResponse.status) {
      _onSuccess();
    } else {
      widget.onCheckoutResponse(
        KlashaCheckoutResponse(
          status: false,
          message: apiResponse.message ?? 'Payment Not Successful',
          transactionReference: transactionReference,
        ),
      );
    }
  }

  void _onSuccess() {
    widget.onCheckoutResponse(
      KlashaCheckoutResponse(
        status: true,
        message: 'Payment Successful',
        transactionReference:
            transactionReference ?? authBankCardResponse?.txRef ?? '',
      ),
    );
  }

  void _moveToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
