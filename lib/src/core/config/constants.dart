/// contains constants used relating to the core logic
/// e.g the list of currencies
/// callbacks
/// environments (test and live)

enum CheckoutCurrency { NGN, KES, GHS }

enum Environment { TEST, LIVE }

typedef void OnCheckoutResponse<KlashaCheckoutResponse>(KlashaCheckoutResponse response);