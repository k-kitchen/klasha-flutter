import 'package:flutter/material.dart';
import 'package:klasha_checkout_v2/klasha_checkout.dart';
import 'package:klasha_checkout_v2/src/ui/views/klasha_checkout_base_view.dart';

/// Make payment using the KlashaCheckout payment options.
class KlashaCheckout {
  /// Make payment using the KlashaCheckout payment options.
  ///
  /// [context] -> The widget's BuildContext
  ///
  /// [email] -> The email of the customer
  ///
  /// [amount] -> The amount to pay in the currency selected in [checkoutCurrency], if the [checkoutCurrency] is not provided, it defaults to [CheckoutCurrency.NGN]
  ///
  /// [checkoutCurrency] -> The checkout currency to use, if the [checkoutCurrency] is not provided, it defaults to [CheckoutCurrency.NGN]
  ///
  /// [environment] -> The environment to use, if it is not provided, it defaults to [Environment.TEST]
  ///
  /// [onComplete] -> This returns the status and information about the just carried out transaction
  ///
  static void checkout(
    BuildContext context, {
    required KlashaCheckoutConfig config,
  }) {
    _validateEmail(config.email);
    globalAuthToken = config.authToken;
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) => KlashaCheckoutBaseView(config),
    );
  }

  static _validateEmail(String email) {
    if (email.isEmpty) {
      throw KlashaCheckoutError('An email needs to be provided');
    }
  }
}
