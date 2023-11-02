class AuthenticateCardPaymentBody {
  String currency;
  String? mode;
  String? pin;
  String? txRef;
  String? amount;
  String? email;

  AuthenticateCardPaymentBody({
    required this.currency,
    this.mode,
    required this.pin,
    required this.txRef,
    required this.amount,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    data['pin'] = this.pin;
    data['tx_ref'] = this.txRef;
    data['amount'] = this.amount;
    data['email'] = this.email;
    return data;
  }
}
