import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/services/bank_transfer/bank_transfer_service_impl.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';
import 'package:klasha_checkout/src/ui/widgets/widgets.dart';

class BankTransferCheckoutView extends StatefulWidget {
  const BankTransferCheckoutView({
    super.key,
    required this.config,
  });

  final KlashaCheckoutConfig config;

  @override
  _BankTransferCheckoutViewState createState() =>
      _BankTransferCheckoutViewState();
}

class _BankTransferCheckoutViewState extends State<BankTransferCheckoutView> {
  late Future<ApiResponse<BankAccountDetails>> futureBankDetails;

  @override
  void initState() {
    super.initState();
    _fetchBankDetails();
  }

  void _fetchBankDetails() async {
    BankTransferBody bankTransferBody = BankTransferBody(
      txRef:
          'klasha-fund-wallet-from-bank-transfer-${DateTime.now().microsecondsSinceEpoch}',
      email: widget.config.email,
      amount: widget.config.amount,
      phoneNumber: widget.config.phone,
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
            child: FutureBuilder<ApiResponse<BankAccountDetails>>(
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
                      widgetToShow = _BankAccountDetailsView(
                        bankAccountNumber:
                            snapshot.data!.data!.transferAccount!,
                        bankName: snapshot.data!.data!.transferBank!,
                      );
                    } else {
                      widgetToShow = Center(
                        child: _RetryView(onRetry: _fetchBankDetails),
                      );
                    }
                    break;
                  default:
                    widgetToShow = Center(
                      child: _RetryView(onRetry: _fetchBankDetails),
                    );
                    break;
                }
                return widgetToShow;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BankAccountDetailsView extends StatelessWidget {
  const _BankAccountDetailsView({
    required this.bankAccountNumber,
    required this.bankName,
  });

  final String bankAccountNumber;
  final String bankName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Make your transfer to this account',
          style: TextStyle(fontSize: 15, color: appColors.subText),
        ),
        const SizedBox(height: 20),
        KlashaOutlinedInputField(
          labeltext: 'Bank name',
          readOnly: true,
          controller: TextEditingController(text: bankName),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: KlashaOutlinedInputField(
                labeltext: 'Account Number',
                readOnly: true,
                controller: TextEditingController(text: bankAccountNumber),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: bankAccountNumber),
                ).whenComplete(
                  () => KlashaDialogs.showStatusDialog(
                    context,
                    'Account number copied',
                  ),
                );
              },
              splashColor: appColors.primaryLight,
              highlightColor: appColors.primaryLight,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: appColors.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy_rounded,
                      color: appColors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        KlashaOutlinedInputField(
          labeltext: 'Account Name',
          readOnly: true,
          controller: TextEditingController(text: 'Klasha'),
        ),
      ],
    );
  }
}

class _RetryView extends StatelessWidget {
  const _RetryView({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Something went wrong'),
        const SizedBox(height: 20),
        KlashaOutlineButton(text: 'Retry', onPressed: onRetry),
      ],
    );
  }
}
