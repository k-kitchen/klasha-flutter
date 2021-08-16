import 'package:klasha_checkout/src/core/core.dart';

abstract class CardService {
  Future<ApiResponse> addBankCard(BankCardDetailsBody bankCardDetailsBody);
  Future<ApiResponse> authenticateCardPayment(AuthenticateCardPaymentBody authenticateCardPaymentBody);
  Future<ApiResponse> validateCardPayment(ValidateCardPaymentBody validateCardPaymentBody);
}
