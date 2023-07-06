class BankCardDetailsBody {
  BankCardDetailsBody({
    this.cardNumber,
    this.cvv,
    this.expiryMonth,
    this.expiryYear,
    this.currency,
    this.rate,
    this.amount,
    this.sourceCurrency,
    this.rememberMe,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.redirectUrl,
    this.txRef,
  });

  String? cardNumber;
  String? cvv;
  String? expiryMonth;
  String? expiryYear;
  String? currency;
  int? rate;
  String? amount;
  String? sourceCurrency;
  bool? rememberMe;
  String? fullName;
  String? phoneNumber;
  String? email;
  String? redirectUrl;
  String? txRef;

  factory BankCardDetailsBody.fromJson(Map<String, dynamic> json) =>
      BankCardDetailsBody(
        cardNumber: json["card_number"],
        cvv: json["cvv"],
        expiryMonth: json["expiry_month"],
        expiryYear: json["expiry_year"],
        currency: json["currency"],
        rate: json["rate"],
        amount: json["amount"],
        sourceCurrency: json["sourceCurrency"],
        rememberMe: json["rememberMe"],
        fullName: json["fullname"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        redirectUrl: json["redirect_url"],
        txRef: json["tx_ref"],
      );

  Map<String, dynamic> toJson() => {
        "card_number": cardNumber,
        "cvv": cvv,
        "expiry_month": expiryMonth,
        "expiry_year": expiryYear,
        "currency": currency,
        "rate": rate,
        "amount": amount,
        "sourceCurrency": sourceCurrency,
        "rememberMe": rememberMe,
        "fullname": fullName,
        "phone_number": phoneNumber,
        "email": email,
        "redirect_url": redirectUrl,
        "tx_ref": txRef,
      };
}
