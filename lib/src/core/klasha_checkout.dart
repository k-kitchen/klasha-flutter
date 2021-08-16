import 'package:flutter/material.dart';
import 'package:klasha_checkout/src/core/config/config.dart';
import 'package:klasha_checkout/src/ui/views/base_view.dart';
import 'package:klasha_checkout/src/ui/views/checkout_view_wrapper.dart';

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
    @required String email,
    @required int amount,
    CheckoutCurrency checkoutCurrency = CheckoutCurrency.NGN,
    Environment environment = Environment.TEST,
    OnCheckoutResponse<KlashaCheckoutResponse> onComplete,
  }) {
    _validateEmailAndAmount(email, amount);
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: KlashaCheckoutBaseView(
            email: email,
            amount: amount,
            checkoutCurrency: checkoutCurrency,
            onComplete: onComplete,
            environment: environment,
          ),
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
