// To parse this JSON data, do
//
//     final authenticateBankCardResponse = authenticateBankCardResponseFromJson(jsonString);

import 'dart:convert';

AuthenticateBankCardResponse authenticateBankCardResponseFromJson(String str) =>
    AuthenticateBankCardResponse.fromJson(json.decode(str));

String authenticateBankCardResponseToJson(AuthenticateBankCardResponse data) =>
    json.encode(data.toJson());

class AuthenticateBankCardResponse {
  AuthenticateBankCardResponse({
    this.txRef,
    this.flwRef,
    this.message,
    this.status,
    this.data,
  });

  factory AuthenticateBankCardResponse.fromJson(Map<String, dynamic> json) =>
      AuthenticateBankCardResponse(
        txRef: json["tx_ref"],
        flwRef: json.containsKey("flw_ref") ? json["flw_ref"] : null,
        data: json.containsKey("data") ? json["data"] : null,
        message: json["message"],
        status: json["status"],
      );

  String txRef;
  String flwRef;
  String message;
  String status;
  dynamic data;

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "flw_ref": flwRef,
        "message": message,
        "status": status,
      };
}
