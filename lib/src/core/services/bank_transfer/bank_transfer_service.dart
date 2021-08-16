import 'package:klasha_checkout/src/core/core.dart';

abstract class BankTransferService {
  Future<ApiResponse> getBankAccountDetails(BankTransferBody bankTransferBody);
}
