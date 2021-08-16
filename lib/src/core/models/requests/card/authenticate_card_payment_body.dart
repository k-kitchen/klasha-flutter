class AuthenticateCardPaymentBody {
  String mode;
  String pin;
  String txRef;
  String city;
  String address;
  String state;
  String country;
  String zipcode;

  AuthenticateCardPaymentBody({
    this.mode,
    this.pin,
    this.txRef,
    this.city,
    this.address,
    this.state,
    this.country,
    this.zipcode,
  });

  AuthenticateCardPaymentBody.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    pin = json['pin'];
    txRef = json['tx_ref'];
    city = json['city'];
    address = json['address'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    data['pin'] = this.pin;
    data['tx_ref'] = this.txRef;
    data['city'] = this.city;
    data['address'] = this.address;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    return data;
  }
}
