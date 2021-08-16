class MpesaCheckoutResponse {
  MpesaCheckoutResponse({
    this.txRef,
    this.data,
    this.message,
    this.status,
  });

  String txRef;
  MpesaData data;
  String message;
  String status;

  factory MpesaCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      MpesaCheckoutResponse(
        txRef: json["tx_ref"],
        data: MpesaData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class MpesaData {
  MpesaData({
    this.id,
    this.txRef,
    this.flwRef,
    this.deviceFingerprint,
    this.amount,
    this.chargedAmount,
    this.appFee,
    this.merchantFee,
    this.processorResponse,
    this.authModel,
    this.currency,
    this.ip,
    this.narration,
    this.status,
    this.authUrl,
    this.paymentType,
    this.fraudStatus,
    this.chargeType,
    this.createdAt,
    this.accountId,
    this.customer,
  });

  double id;
  String txRef;
  String flwRef;
  String deviceFingerprint;
  double amount;
  double chargedAmount;
  double appFee;
  double merchantFee;
  String processorResponse;
  String authModel;
  String currency;
  String ip;
  String narration;
  String status;
  String authUrl;
  String paymentType;
  String fraudStatus;
  String chargeType;
  DateTime createdAt;
  double accountId;
  Customer customer;

  factory MpesaData.fromJson(Map<String, dynamic> json) => MpesaData(
        id: json["id"],
        txRef: json["tx_ref"],
        flwRef: json["flw_ref"],
        deviceFingerprint: json["device_fingerprint"],
        amount: json["amount"],
        chargedAmount: json["charged_amount"],
        appFee: json["app_fee"].toDouble(),
        merchantFee: json["merchant_fee"],
        processorResponse: json["processor_response"],
        authModel: json["auth_model"],
        currency: json["currency"],
        ip: json["ip"],
        narration: json["narration"],
        status: json["status"],
        authUrl: json["auth_url"],
        paymentType: json["payment_type"],
        fraudStatus: json["fraud_status"],
        chargeType: json["charge_type"],
        createdAt: DateTime.parse(json["created_at"]),
        accountId: json["account_id"],
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tx_ref": txRef,
        "flw_ref": flwRef,
        "device_fingerprint": deviceFingerprint,
        "amount": amount,
        "charged_amount": chargedAmount,
        "app_fee": appFee,
        "merchant_fee": merchantFee,
        "processor_response": processorResponse,
        "auth_model": authModel,
        "currency": currency,
        "ip": ip,
        "narration": narration,
        "status": status,
        "auth_url": authUrl,
        "payment_type": paymentType,
        "fraud_status": fraudStatus,
        "charge_type": chargeType,
        "created_at": createdAt.toIso8601String(),
        "account_id": accountId,
        "customer": customer.toJson(),
      };
}

class Customer {
  Customer({
    this.id,
    this.phoneNumber,
    this.name,
    this.email,
    this.createdAt,
  });

  double id;
  String phoneNumber;
  String name;
  String email;
  DateTime createdAt;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
        "name": name,
        "email": email,
        "created_at": createdAt.toIso8601String(),
      };
}
