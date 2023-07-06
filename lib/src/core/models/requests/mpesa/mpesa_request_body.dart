class MpesaRequestBody {
  MpesaRequestBody({
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
    this.option,
  });

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
  String? option;

  factory MpesaRequestBody.fromJson(Map<String, dynamic> json) =>
      MpesaRequestBody(
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
        option: json["option"],
      );

  Map<String, dynamic> toJson() => {
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
    "option": option,
  };
}
