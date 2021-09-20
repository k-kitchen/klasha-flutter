class ValidateCardPaymentBody {
  ValidateCardPaymentBody({
    this.otp,
    this.flwRef,
    this.type,
  });

  ValidateCardPaymentBody.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    flwRef = json['flw_ref'];
    type = json['type'];
  }

  String otp;
  String flwRef;
  String type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = this.otp;
    data['flw_ref'] = this.flwRef;
    data['type'] = this.type;
    return data;
  }
}
