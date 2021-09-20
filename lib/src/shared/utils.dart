import 'package:intl/intl.dart';

class KlashaUtils {
  /// contains utils liek validations, card validations, strings utils, e.t.c
  ///
  ///
  static String validateEmail(String email) {
    const String source =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final RegExp regExp = RegExp(source);
    if (email.trim().isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(email)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  static String formatCurrencyInput(String amount,[bool ignoreSymbol = false, int decimalDigits = 2]) {
    final formatter = NumberFormat.currency(
      locale: "en_NG",
      name: 'NGN',
      symbol: ignoreSymbol ? '' : "₦",
      decimalDigits: decimalDigits,
    );
    amount = amount.replaceAll(RegExp(r'[^0-9\.]'), "");
    final amountDouble = double.tryParse(amount);
    if (amount == null || amountDouble == null) {
      return "";
    }
    return formatter.format(amountDouble);
  }

  static String validateRequiredFields(String input, String fieldName) {
    if (input.trim().isEmpty) {
      return 'Invalid $fieldName';
    } else {
      return null;
    }
  }

  static String validateCardNum(String input) {
    if (input == null || input.isEmpty) {
      return 'Invalid card number';
    }
    input = input.replaceAll(RegExp(r"[^0-9]"), '');

    return input.length >= 14 ? null : 'Invalid card number';
  }

  static String validateDate(String value) {
    if (value == null || value.isEmpty) {
      return 'Invalid expiry date';
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(/)'))) {
      final date = getExpiryDate(value);
      month = date[0];
      year = date[1];
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, value.length));
      year = -1; // Lets use an invalid year intentionally
    }

    if (!isNotExpired(year, month)) {
      return 'Invalid Expiry Date';
    }
    return null;
  }

  static String validateCVC(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invalid CVV';
    }

    return (value.length >= 3 && value.length <= 4) ? null : 'Invalid CVV';
  }

  static List<int> getExpiryDate(String value) {
    if (value == null) {
      return [-1, -1];
    }
    final split = value.split(RegExp(r'(\/)'));
    final month = int.tryParse(split[0]) ?? -1;
    if (split.length == 1) {
      return [month, -1];
    }
    final year = int.tryParse(split[split.length - 1]) ?? -1;
    return [month, year];
  }

  static bool isNotExpired(int year, int month) {
    if ((year == null || month == null) || (month > 12 || year > 2999)) {
      return false;
    }
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static bool hasYearPassed(int year) {
    final int fourDigitsYear = convertYearTo4Digits(year);
    final now = DateTime.now();
    // The year has passed if the year we are currently is more than card's year
    return fourDigitsYear < now.year;
  }

  static bool isValidMonth(int month) {
    return month != null && month > 0 && month < 13;
  }

  static bool hasMonthPassed(int year, int month) {
    if (year == null || month == null) {
      return true;
    }
    final now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static int convertYearTo4Digits(int year) {
    if (year == null) {
      return 0;
    }
    if (year < 100 && year >= 0) {
      const String prefix = "20";
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }
}
