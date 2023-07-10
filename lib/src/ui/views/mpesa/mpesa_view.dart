import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/mpesa/mpesa_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class MpesaCheckoutView extends StatefulWidget {

  const MpesaCheckoutView({
    super.key,
    this.onCheckoutResponse,
    this.email,
    this.amount,
  });

  final OnCheckoutResponse<KlashaCheckoutResponse> onCheckoutResponse;
  final String email;
  final int amount;

  @override
  _MpesaCheckoutViewState createState() => _MpesaCheckoutViewState();
}

class _MpesaCheckoutViewState extends State<MpesaCheckoutView> {
  PageController _pageController;
  int _currentPage = 0;
  MpesaCheckoutResponse _mpesaCheckoutResponse;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String transactionReference;

  String _fullName;
  String _email;
  String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
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
          const SizedBox(
            height: 5,
          ),
          Text(
            'KES ${KlashaUtils.formatCurrencyInput(widget.amount.toString(), true)}',
            style: TextStyle(
              fontSize: 17,
              color: appColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              clipBehavior: Clip.none,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _MpesaInputForm(
                  onFullNameChanged: (val) => _fullName = val,
                  onEmailChanged: (val) => _email = val,
                  onPhoneNumberChanged: (val) => _phoneNumber = val,
                  formKey: _formKey,
                ),
                _CodeDialedSection(
                  phoneNumber: _phoneNumber,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (_currentPage == 0)
            PayWithKlashaButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  transactionReference =  'klasha-mpesa-checkout-${DateTime.now().microsecondsSinceEpoch}';
                  MpesaRequestBody mpesaRequestBody = MpesaRequestBody(
                    currency: 'KES',
                    amount: '1000',
                    rate: 1,
                    sourceCurrency: 'KES',
                    rememberMe: false,
                    redirectUrl: 'https://dashboard.klasha.com/woocommerce',
                    phoneNumber: 'phone_number',
                    email: _email,
                    fullName: _fullName,
                    txRef: transactionReference,
                    option: 'mpesa',
                  );

                  KlashaDialogs.showLoadingDialog(context);

                  ApiResponse apiResponse =
                  await MpesaServiceImpl().paywithMpesa(mpesaRequestBody);

                  Navigator.pop(context);

                  if (apiResponse.status) {
                    _mpesaCheckoutResponse = apiResponse.data;
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    KlashaDialogs.showStatusDialog(context, apiResponse.message);
                    // log('something went wrong, try again');
                  }
                }

              },
            ),
          if (_currentPage == 1)
            KlashaPrimaryButton(
              text: 'I have dialed the code',
              onPressed: () async {
                KlashaDialogs.showLoadingDialog(context);

                ApiResponse apiResponse = await MpesaServiceImpl().verifyPayment(
                  "${_mpesaCheckoutResponse.data.id}",
                  "mpesa_order_id_${_mpesaCheckoutResponse.data.id}",
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

class _MpesaInputForm extends StatelessWidget {
  const _MpesaInputForm({
    super.key,
    this.onFullNameChanged,
    this.onEmailChanged,
    this.onPhoneNumberChanged,
    this.formKey,
  });

  final Function(String) onFullNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneNumberChanged;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              fontSize: 14,
              color: appColors.subText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          KlashaInputField(
            onChanged: onFullNameChanged,
            hintText: 'John Doe',
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\d+')),
            ],
            validator: (input) =>  KlashaUtils.validateRequiredFields(input, 'Full Name'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.subText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    KlashaInputField(
                      onChanged: onEmailChanged,
                      hintText: 'john@gmail.com',
                      validator: KlashaUtils.validateEmail,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone number',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.subText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    KlashaInputField(
                      onChanged: onPhoneNumberChanged,
                      hintText: '0123456789',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (input) =>  KlashaUtils.validateRequiredFields(input, 'Phone Number'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeDialedSection extends StatelessWidget {
  const _CodeDialedSection({
    super.key,
    this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Dial Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appColors.subText,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Please dial the code that was sent to the mobile number $phoneNumber',
          style: TextStyle(
            fontSize: 15,
            color: appColors.subText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
