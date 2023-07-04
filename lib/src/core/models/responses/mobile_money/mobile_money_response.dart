class MobileMoneyResponse {
  MobileMoneyResponse({
    this.status,
    this.message,
    this.data,
    this.meta,
    this.txRef,
  });

  String? status;
  String? message;
  MobileMoneyData? data;
  MobileMoneyMeta? meta;
  String? txRef;

  factory MobileMoneyResponse.fromJson(Map<String, dynamic> json) =>
      MobileMoneyResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null
            ? MobileMoneyData.fromJson(json["data"])
            : null,
        meta: json["meta"] != null
            ? MobileMoneyMeta.fromJson(json["meta"])
            : null,
        txRef: json["tx_ref"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "meta": meta?.toJson(),
        "tx_ref": txRef,
      };
}

class MobileMoneyData {
  MobileMoneyData({
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
    this.paymentType,
    this.fraudStatus,
    this.chargeType,
    this.createdAt,
    this.accountId,
    this.customer,
  });

  double? id;
  String? txRef;
  String? flwRef;
  String? deviceFingerprint;
  double? amount;
  double? chargedAmount;
  double? appFee;
  double? merchantFee;
  String? processorResponse;
  String? authModel;
  String? currency;
  String? ip;
  String? narration;
  String? status;
  String? paymentType;
  String? fraudStatus;
  String? chargeType;
  DateTime? createdAt;
  double? accountId;
  MobileMoneyCustomer? customer;

  factory MobileMoneyData.fromJson(Map<String, dynamic> json) =>
      MobileMoneyData(
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
        paymentType: json["payment_type"],
        fraudStatus: json["fraud_status"],
        chargeType: json["charge_type"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        accountId: json["account_id"],
        customer: json["customer"] != null
            ? MobileMoneyCustomer.fromJson(json["customer"])
            : null,
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
        "payment_type": paymentType,
        "fraud_status": fraudStatus,
        "charge_type": chargeType,
        "created_at": createdAt?.toIso8601String(),
        "account_id": accountId,
        "customer": customer?.toJson(),
      };
}

class MobileMoneyCustomer {
  MobileMoneyCustomer({
    this.id,
    this.phoneNumber,
    this.name,
    this.email,
    this.createdAt,
  });

  double? id;
  String? phoneNumber;
  String? name;
  String? email;
  DateTime? createdAt;

  factory MobileMoneyCustomer.fromJson(Map<String, dynamic> json) =>
      MobileMoneyCustomer(
        id: json["id"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        email: json["email"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
        "name": name,
        "email": email,
        "created_at": createdAt?.toIso8601String(),
      };
}

class MobileMoneyMeta {
  MobileMoneyMeta({
    this.authorization,
  });

  MobileMoneyAuthorization? authorization;

  factory MobileMoneyMeta.fromJson(Map<String, dynamic> json) =>
      MobileMoneyMeta(
        authorization: json["authorization"] != null
            ? MobileMoneyAuthorization.fromJson(json["authorization"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "authorization": authorization?.toJson(),
      };
}

class MobileMoneyAuthorization {
  MobileMoneyAuthorization({
    this.instruction,
  });

  String? instruction;

  factory MobileMoneyAuthorization.fromJson(Map<String, dynamic> json) =>
      MobileMoneyAuthorization(instruction: json["instruction"]);

  Map<String, dynamic> toJson() => {"instruction": instruction};
}
