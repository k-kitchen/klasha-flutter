import 'package:klasha_checkout_v2/src/core/core.dart';

abstract class MpesaService {
  Future<ApiResponse> paywithMpesa(MpesaRequestBody mpesaRequestBody);
  Future<ApiResponse> verifyPayment(String tnxId, String orderId);
}
