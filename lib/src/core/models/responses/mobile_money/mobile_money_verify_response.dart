class MobileMoneyVerifyResponse {
  MobileMoneyVerifyResponse({
    this.txRef,
    this.amount,
    this.processorResponse,
    this.message,
    this.status,
  });

  String? txRef;
  double? amount;
  String? processorResponse;
  String? message;
  String? status;

  factory MobileMoneyVerifyResponse.fromJson(Map<String, dynamic> json) =>
      MobileMoneyVerifyResponse(
        txRef: json["tx_ref"],
        amount: json["amount"],
        processorResponse: json["processor_response"],
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "tx_ref": txRef,
        "amount": amount,
        "processor_response": processorResponse,
        "message": message,
        "status": status,
      };
}
