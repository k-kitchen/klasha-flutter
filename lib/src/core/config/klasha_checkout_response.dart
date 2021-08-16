class KlashaCheckoutResponse {
  KlashaCheckoutResponse({
    this.message,
    this.status = false,
    this.transactionReference,
  });

  /// If the transaction was not successful, this returns the message returns the cause of the unsuccessful transaction.
  final String message;

  /// The status of the transaction. A successful response returns true and false
  /// otherwise
  final bool status;

  /// Transaction reference for the just carried out transaction
  final String transactionReference;
}
