import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/src/core/config/config.dart';
import 'package:klasha_checkout_v2/src/shared/shared.dart';
import 'package:klasha_checkout_v2/src/ui/widgets/checkout_options_entry.dart';

enum CheckoutType {
  Card('Card', KlashaAssets.ic_card),
  Mpesa('Mpesa', KlashaAssets.ic_mpesa),
  BankTransfer('Bank Transfer', KlashaAssets.ic_transfer),
  MobileMoney('Mobile Money', KlashaAssets.ic_mpesa);

  final String name;
  final String icon;

  const CheckoutType(this.name, this.icon);
}

class CheckoutOptionsView extends StatelessWidget {
  CheckoutOptionsView({
    super.key,
    required this.onCheckoutSelected,
    required this.checkoutCurrency,
  });

  final Function(CheckoutType) onCheckoutSelected;
  final CheckoutCurrency checkoutCurrency;

  final _paymentTypes = <CheckoutType>[];

  void _filterCheckoutOptions() {
    switch (checkoutCurrency) {
      case CheckoutCurrency.NGN:
        _paymentTypes.addAll([CheckoutType.Card, CheckoutType.BankTransfer]);
        break;
      case CheckoutCurrency.KES:
        _paymentTypes.addAll([CheckoutType.Card, CheckoutType.Mpesa]);
        break;
      case CheckoutCurrency.GHS:
        _paymentTypes.addAll([CheckoutType.MobileMoney]);
        break;
      case CheckoutCurrency.USD:
        _paymentTypes.addAll([CheckoutType.Card]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterCheckoutOptions();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
            _paymentTypes.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CheckoutOptionEntry(
                name: _paymentTypes[index].name,
                assetName: _paymentTypes[index].icon,
                onTap: () => onCheckoutSelected(_paymentTypes[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
