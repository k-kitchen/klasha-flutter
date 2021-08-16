class BankTransferBody {
  BankTransferBody({
    this.txRef,
    this.amount,
    this.email,
    this.phoneNumber,
    this.currency,
    this.narration,
  });

  String txRef;
  int amount;
  String email;
  String phoneNumber;
  String currency;
  String narration;

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "amount": amount,
        "email": email,
        "phone_number": phoneNumber,
        "currency": currency,
        "narration": narration,
      };
}
