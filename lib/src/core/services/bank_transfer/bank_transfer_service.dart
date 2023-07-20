import 'package:klasha_checkout_v2/src/core/core.dart';

abstract class BankTransferService {
  Future<ApiResponse> getBankAccountDetails(BankTransferBody bankTransferBody);
}
