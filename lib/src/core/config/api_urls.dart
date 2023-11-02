import 'package:klasha_checkout_v2/klasha_checkout_v2.dart';

class ApiUrls {
  // base url
  static late String baseUrl;

  // bank transfer urls
  static const String bankTransferUrl = '/pay/NGN/banktransfer';

  // card checkout urls
  static String addBankCardUrl(String currency) => '/pay/$currency/cardpayment';

  static String authenticateCardPaymentUrl(String currency) =>
      '/pay/$currency/charge';

  static String validateCardPaymentUrl(String currency) =>
      '/pay/$currency/validatepayment';

  static const String checkTransaction = '/nucleus/tnx/merchant/status';

  // mpesa
  static const String mpesaUrl = '/pay/KES/cardpayment';

  // mobile money
  static const String mobileMoneyUrl = '/pay/GHS/mobilemoney';

  // verify payment
  static String verifyPaymentUrl(String countryCode) =>
      '/pay/$countryCode/payment/verify';

  static void setBaseUrl(Environment environment) {
    switch (environment) {
      case Environment.TEST:
        baseUrl = 'https://dev.kcookery.com';
        break;
      case Environment.LIVE:
        baseUrl = 'https://gate.klasapps.com';
        break;
    }
  }
}
