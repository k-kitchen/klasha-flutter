import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/buttons/buttons.dart';

class PaymentStatusView extends StatefulWidget {
  const PaymentStatusView({
    Key key,
    @required this.paymentStatus,
    this.onAction,
  }) : super(key: key);

  final VoidCallback onAction;
  final bool paymentStatus;

  @override
  _PaymentStatusViewState createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.paymentStatus
                    ? KlashaAssets.ic_success
                    : KlashaAssets.ic_failed,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
                package: KlashaStrings.packageName,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.paymentStatus
                    ? 'Your payment was \nsuccessful'
                    : 'Your payment was not \nsuccessful',
                style: TextStyle(
                  fontSize: 20,
                  color: appColors.text,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              KlashaOutlineButton(
                text: widget.paymentStatus ? 'Okay' : 'Try again',
                onPressed: widget.onAction,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
