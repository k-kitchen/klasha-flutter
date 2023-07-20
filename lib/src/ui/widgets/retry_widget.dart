import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/buttons/buttons.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({this.onRetry});

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