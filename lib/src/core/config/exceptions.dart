class KlashaCheckoutError implements Exception {
  String message;

  KlashaCheckoutError(this.message);

  String toString() {
    return "KlashaCheckout Error: ${this.message}";
  }
}
