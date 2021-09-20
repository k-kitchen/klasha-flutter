/// contains constants used relating to the core logic
/// e.g the list of currencies
/// callbacks
/// environments (test and live)

enum CheckoutCurrency { NGN, KES, GHS }

enum Environment { TEST, LIVE }

typedef OnCheckoutResponse<KlashaCheckoutResponse> = void Function(KlashaCheckoutResponse response);