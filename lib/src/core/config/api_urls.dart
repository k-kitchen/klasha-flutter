class ApiUrls {
  // base url
  static const String baseUrl = 'https://ktests.com';

  // bank transfer urls
  static const String bankTransferUrl = '/pay/NGN/banktransfer';

  // card checkout urls
  static const String addBankCardUrl = '/pay/NGN/cardpayment';
  static const String authenticateCardPaymentUrl = '/pay/NGN/charge';
  static const String validateCardPaymentUrl = '/pay/NGN/validatepayment';

  // mpesa
  static const String mpesaUrl = '/pay/KES/cardpayment';

  // mobile money
  static const String mobileMoneyUrl = '/pay/GHS/mobilemoney';

  // verify payment
  static  String verifyPaymentUrl(String countryCode) => '/pay/$countryCode/payment/verify';

}
