class ValidateCardPaymentBody {
  String currency;
  String? otp;
  String? flwRef;
  String? type;

  ValidateCardPaymentBody({
    required this.currency,
    this.otp,
    this.flwRef,
    this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['flw_ref'] = this.flwRef;
    data['type'] = this.type;
    return data;
  }
}
