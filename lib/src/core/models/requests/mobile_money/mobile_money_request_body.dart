class MobileMoneyRequestBody {
  MobileMoneyRequestBody({
    this.txRef,
    this.amount,
    this.email,
    this.phoneNumber,
    this.currency,
    this.narration,
    this.network,
  });

  String txRef;
  int amount;
  String email;
  String phoneNumber;
  String currency;
  String narration;
  String network;

  factory MobileMoneyRequestBody.fromJson(Map<String, dynamic> json) =>
      MobileMoneyRequestBody(
        txRef: json["tx_ref"],
        amount: json["amount"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        currency: json["currency"],
        narration: json["narration"],
        network: json["network"],
      );

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "amount": amount,
        "email": email,
        "phone_number": phoneNumber,
        "currency": currency,
        "narration": narration,
        "network": network,
      };
}
