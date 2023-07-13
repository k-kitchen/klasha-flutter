import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/config/config.dart';
import 'package:klasha_checkout/src/shared/shared.dart';
import 'package:klasha_checkout/src/ui/widgets/checkout_options_entry.dart';

class CheckoutOptionsView extends StatelessWidget {
  CheckoutOptionsView({
    super.key,
    required this.onCheckoutSelected,
    required this.checkoutCurrency,
  });

  final Function(String) onCheckoutSelected;
  final CheckoutCurrency checkoutCurrency;

  List<String> _paymentNames = ['Card'];

  List<String> _paymentImages = [KlashaAssets.ic_card];

  void _filterCheckoutOptions() {
    switch (checkoutCurrency) {
      case CheckoutCurrency.NGN:
        _paymentNames.insert(1, 'Bank Transfer');
        _paymentImages.insert(1, KlashaAssets.ic_transfer);
        break;
      case CheckoutCurrency.KES:
        _paymentNames.insert(1, 'Mpesa');
        _paymentImages.insert(1, KlashaAssets.ic_mpesa);
        break;
      case CheckoutCurrency.GHS:
        _paymentNames.insert(1, 'Mobile Money');
        _paymentImages.insert(1, KlashaAssets.ic_mpesa);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterCheckoutOptions();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Text(
            'Checkout Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: appColors.subText,
            ),
          ),
          SizedBox(height: 20),
          ...List.generate(
            _paymentNames.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CheckoutOptionEntry(
                name: _paymentNames[index],
                assetName: _paymentImages[index],
                onTap: () => onCheckoutSelected(_paymentNames[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
