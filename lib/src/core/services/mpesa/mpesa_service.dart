import 'package:klasha_checkout/src/core/core.dart';

abstract class MpesaService {
  Future<ApiResponse> paywithMpesa(MpesaRequestBody mpesaRequestBody);
  Future<ApiResponse> verifyPayment(String tnxId, String orderId);
}
