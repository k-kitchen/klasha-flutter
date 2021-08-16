import 'package:klasha_checkout/src/core/config/api_response.dart';
import 'package:klasha_checkout/src/core/core.dart';

abstract class MobileMoneyService {
  Future<ApiResponse> mobileMoneyPay(MobileMoneyRequestBody mobileMoneyRequestBody);
  Future<ApiResponse> verifyPayment(String tnxId, String orderId);
}