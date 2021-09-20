import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/config/config.dart';
import 'package:klasha_checkout/src/shared/shared.dart';

class CheckoutOptionsView extends StatelessWidget {
  CheckoutOptionsView({
    Key key,
    this.onCheckoutSelected,
    this.checkoutCurrency,
  }) : super(key: key);

  final Function(String) onCheckoutSelected;
  final CheckoutCurrency checkoutCurrency;

  final List<String> _paymentNames = [
    'Card',
  ];

  final List<String> _paymentImages = [
    KlashaAssets.ic_card,
  ];

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
        children: [
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
              child: _CheckoutOptionEntry(
                name: _paymentNames[index],
                assetName: _paymentImages[index],
                onTap: () {
                  onCheckoutSelected(_paymentNames[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutOptionEntry extends StatelessWidget {
  const _CheckoutOptionEntry({
    Key key,
    this.name,
    this.assetName,
    this.onTap,
  }) : super(key: key);

  final String name;
  final String assetName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: appColors.primaryLight,
        ),
        padding: EdgeInsets.only(left: 15.0),
        child: Row(
          children: [
            Image.asset(
              assetName,
              height: 25,
              width: 25,
              color: appColors.primary,
              fit: BoxFit.cover,
              package: KlashaStrings.packageName,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: appColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
