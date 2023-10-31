import 'package:klasha_checkout_v2/klasha_checkout_v2.dart';

class KlashaCheckoutConfig {
  String email, authToken;
  int amount;
  CheckoutCurrency checkoutCurrency;
  Environment environment;
  OnCheckoutResponse<KlashaCheckoutResponse> onComplete;

  KlashaCheckoutConfig({
    required this.email,
    required this.amount,
    required this.checkoutCurrency,
    this.environment = Environment.TEST,
    required this.onComplete,
    required this.authToken,
  });
}
