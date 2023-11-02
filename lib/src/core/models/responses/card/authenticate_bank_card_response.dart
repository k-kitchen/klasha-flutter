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
    required this.authMode,
    this.redirectUrl,
  });

  String? txRef;
  String? flwRef;
  String? message;
  String? status;
  AuthMode? authMode;
  String? redirectUrl;

  factory AuthenticateBankCardResponse.fromJson(Map<String, dynamic> json) {
    final authData = json['data']?['meta']?['authorization'];
    return AuthenticateBankCardResponse(
      txRef: json["tx_ref"],
      flwRef: json.containsKey("flw_ref") ? json["flw_ref"] : null,
      message: json["message"],
      status: json["status"],
      authMode: AuthMode.fromString(authData?['mode'] ?? ''),
      redirectUrl: authData?['redirect'],
    );
  }

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "flw_ref": flwRef,
        "message": message,
        "status": status,
      };
}

enum AuthMode {
  pin,
  avs_noauth,
  redirect;

  static AuthMode? fromString(String value) {
    return AuthMode.values.where((b) => b.name == value).firstOrNull;
  }
}
