class AddBankCardResponse {
  AddBankCardResponse({
    this.txRef,
    this.data,
  });

  String txRef;
  Data data;

  factory AddBankCardResponse.fromJson(Map<String, dynamic> json) =>
      AddBankCardResponse(
        txRef: json["tx_ref"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.status,
    this.message,
    this.meta,
  });

  String status;
  String message;
  Meta meta;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta.toJson(),
      };
}

class Meta {
  Meta({
    this.authorization,
  });

  Authorization authorization;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        authorization: Authorization.fromJson(json["authorization"]),
      );

  Map<String, dynamic> toJson() => {
        "authorization": authorization.toJson(),
      };
}

class Authorization {
  Authorization({
    this.mode,
    this.fields,
  });

  String mode;
  List<String> fields;

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
        mode: json["mode"],
        fields: List<String>.from(json["fields"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "mode": mode,
        "fields": List<dynamic>.from(fields.map((x) => x)),
      };
}
