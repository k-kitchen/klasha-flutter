class KlashaCheckoutError implements Exception {

  KlashaCheckoutError(this.message);

  String message;

  @override
  String toString() {
    return "KlashaCheckout Error: ${this.message}";
  }
}
