import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/buttons/buttons.dart';

class PaymentStatusView extends StatefulWidget {
  const PaymentStatusView({
    super.key,
    required this.paymentStatus,
    this.onAction,
    this.message,
  });

  final VoidCallback? onAction;
  final bool paymentStatus;
  final String? message;

  @override
  _PaymentStatusViewState createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            widget.paymentStatus
                ? KlashaAssets.ic_success
                : KlashaAssets.ic_failed,
            height: 64,
            width: 64,
            fit: BoxFit.cover,
            package: KlashaStrings.packageName,
          ),
          const SizedBox(height: 20),
          Text(
            widget.paymentStatus
                ? 'Your payment was \nsuccessful'
                : 'Your payment failed',
            style: TextStyle(
              fontSize: 20,
              color: appColors.text,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 10),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 12,
                color: appColors.subText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 30),
          KlashaOutlineButton(
            text: widget.paymentStatus ? 'Okay' : 'Try again',
            onPressed: widget.onAction,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
