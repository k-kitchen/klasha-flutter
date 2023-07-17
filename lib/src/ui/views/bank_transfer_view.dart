import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/bank_transfer/bank_transfer_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/bank_account_details_widget.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/retry_widget.dart';

import '../widgets/widgets.dart';

class BankTransferCheckoutView extends StatefulWidget {
  const BankTransferCheckoutView({super.key, required this.config});

  final KlashaCheckoutConfig config;

  @override
  _BankTransferCheckoutViewState createState() =>
      _BankTransferCheckoutViewState();
}

class _BankTransferCheckoutViewState extends State<BankTransferCheckoutView> {
  Future<ApiResponse<BankAccountDetails>>? futureBankDetails;
  late PageController pageController;
  int currentPage = 0;
  var formKey = GlobalKey<FormState>();
  String? fullName, email, phoneNumber;

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

  void _fetchBankDetails() async {
    BankTransferBody bankTransferBody = BankTransferBody(
      txRef:
          'klasha-fund-wallet-from-bank-transfer-${DateTime.now().microsecondsSinceEpoch}',
      email: email,
      amount: widget.config.amount,
      phoneNumber: phoneNumber,
      narration: 'Bank Transfer to fund wallet',
      currency: widget.config.checkoutCurrency.name,
    );

    futureBankDetails =
        BankTransferServiceImpl().getBankAccountDetails(bankTransferBody);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            '${widget.config.checkoutCurrency.name} ${widget.config.amount}',
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
                Column(
                  children: [
                    UserContactForm(
                      onFullNameChanged: (val) => fullName = val,
                      onEmailChanged: (val) => email = val,
                      onPhoneNumberChanged: (val) => phoneNumber = val,
                      initialEmail: widget.config.email,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 20),
                    KlashaPrimaryButton(
                      text: 'Continue',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _fetchBankDetails();
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ],
                ),
                FutureBuilder<ApiResponse<BankAccountDetails>>(
                  future: futureBankDetails,
                  builder: (BuildContext context,
                      AsyncSnapshot<ApiResponse<BankAccountDetails>> snapshot) {
                    Widget widgetToShow;
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        widgetToShow = Center(
                          child: Container(
                            width: 25.0,
                            height: 25.0,
                            margin: const EdgeInsets.symmetric(vertical: 30.0),
                            child: CircularProgressIndicator(strokeWidth: 3.0),
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData && snapshot.data?.data != null) {
                          var data = snapshot.data!.data!;
                          widgetToShow = BankAccountDetailsWidget(
                            bankAccountNumber: data.transferAccount!,
                            bankName: data.transferBank!,
                          );
                        } else {
                          widgetToShow = Center(
                            child: RetryWidget(onRetry: _fetchBankDetails),
                          );
                        }
                        break;
                      default:
                        widgetToShow = Center(
                          child: RetryWidget(onRetry: _fetchBankDetails),
                        );
                        break;
                    }
                    return widgetToShow;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
