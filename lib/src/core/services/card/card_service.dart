import 'package:klasha_checkout_v2/src/core/core.dart';

abstract class CardService {
  Future<ApiResponse> addBankCard(BankCardDetailsBody bankCardDetailsBody);

  Future<ApiResponse> authenticateCardPayment(
      AuthenticateCardPaymentBody authenticateCardPaymentBody);

  Future<ApiResponse> validateCardPayment(
      ValidateCardPaymentBody validateCardPaymentBody);

  Future<ApiResponse<bool>> confirmTransaction(String txnRef);
}
