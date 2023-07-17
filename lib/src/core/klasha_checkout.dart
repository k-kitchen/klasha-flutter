import 'package:flutter/material.dart';
import 'package:klasha_checkout/klasha_checkout.dart';
import 'package:klasha_checkout/src/ui/views/klasha_checkout_base_view.dart';

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
    required String email,
    required int amount,
    CheckoutCurrency checkoutCurrency = CheckoutCurrency.NGN,
    Environment environment = Environment.TEST,
    required OnCheckoutResponse<KlashaCheckoutResponse> onComplete,
    required String authToken,
  }) {
    _validateEmailAndAmount(email, amount);
    globalAuthToken = authToken;
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return KlashaCheckoutBaseView(
          email: email,
          amount: amount,
          checkoutCurrency: checkoutCurrency,
          onComplete: onComplete,
          environment: environment,
        );
      },
    );
  }

  static _validateEmailAndAmount(String email, int amount) {
    if (email == null) {
      throw KlashaCheckoutError('An email needs to be provided');
    }
    if (amount == null) {
      throw KlashaCheckoutError('An amount needs to be provided');
    }
  }
}
