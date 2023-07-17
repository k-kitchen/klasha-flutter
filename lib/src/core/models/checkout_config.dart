import 'package:klasha_checkout/klasha_checkout.dart';

class CheckoutConfig {
  String email, phone, authToken;
  int amount;
  CheckoutCurrency checkoutCurrency;
  Environment environment;
  OnCheckoutResponse<KlashaCheckoutResponse> onComplete;

  CheckoutConfig({
    required this.email,
    required this.phone,
    required this.amount,
    required this.checkoutCurrency,
    this.environment = Environment.TEST,
    required this.onComplete,
    required this.authToken,
  });
}
