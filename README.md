# klasha_checkout_v2

A Flutter plugin for making payments via Klasha Checkout Technology

## About

Klasha Flutter SDK allows you to build a quick, simple and excellent payment experience in your Flutter app. We provide powerful and customizable UI screens and elements that can be used out-of-the-box to collect your users' payment details via the Klasha Checkout Technology.

<p align="center">
<img src="https://raw.githubusercontent.com/klasha-apps/klasha-flutter/master/screenshots/bank_transfer.png" alt="Bank Transfer Checkout" width="230px" hspace="30"/>  <img src="https://raw.githubusercontent.com/klasha-apps/klasha-flutter/master/screenshots/card.png" alt="Card Checkout" width="230px"/>
</p>

<p align="center">
<img src="https://raw.githubusercontent.com/klasha-apps/klasha-flutter/master/screenshots/mobile_money.png" alt="Mobile Money Checkout" width="230px" hspace="30"/>  <img src="https://raw.githubusercontent.com/klasha-apps/klasha-flutter/master/screenshots/mpesa.png" alt="Mpesa Checkout" width="230px"/>
</p>

## Installing

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  klasha_checkout_v2: ^1.0.1
```

## How To Use

1. In your file add the following import:

```dart
import 'package:klasha_checkout_v2/klasha_checkout.dart';
```

2. Call the `checkout` method and handle the response of the `checkout` method

```dart
KlashaCheckout.checkout(
  context,
  config: KlashaCheckoutConfig(
    email: email!,
    amount: int.parse(amount!),
    checkoutCurrency: _checkoutCurrency,
    authToken: 'your_auth_token',
    onComplete: (KlashaCheckoutResponse klashaCheckoutResponse) {
      print(klashaCheckoutResponse);
    }
  ),
);
```

## Customizations

| Property        | Description                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| email          | The email of the customer.            |
| amount           | The amount to pay in the currency selected in [checkoutCurrency], if the [checkoutCurrency] is not provided, it defaults to [CheckoutCurrency.NGN].                                |
| checkoutCurrency    | The checkout currency to use, if the [checkoutCurrency] is not provided, it defaults to [CheckoutCurrency.NGN].            |
| environment           | The environment to use, if it is not provided, it defaults to [Environment.TEST]
| onComplete           | This returns the status, message and transaction reference about the just carried out transaction.
## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/klasha-apps/klasha-flutter/issues).
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/klasha-apps/klasha-flutter/pulls).
