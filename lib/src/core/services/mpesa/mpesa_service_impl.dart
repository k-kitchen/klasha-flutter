import 'package:klasha_checkout/src/core/core.dart';

class MpesaServiceImpl extends MpesaService with KlashaBaseService {
  @override
  Future<ApiResponse> paywithMpesa(MpesaRequestBody mpesaRequestBody) async {
    final ApiResponse<MpesaCheckoutResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.mpesaUrl;

    final requestBody = mpesaRequestBody.toJson();

    final Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    final Map decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else {
      final MpesaCheckoutResponse mpesaCheckoutResponse = MpesaCheckoutResponse.fromJson(decodedResponseMap);
      // log('mpesa service => mpesa payment here = $mpesaCheckoutResponse');

      apiResponse.data = mpesaCheckoutResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse> verifyPayment(String tnxId, String orderId) async {
    final ApiResponse<MpesaVerifyResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.verifyPaymentUrl('KES');

    final requestBody = {
      'tnxId': tnxId,
      'orderId': orderId,
    };

    final Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    final Map decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else {
      final MpesaVerifyResponse mpesaVerifyResponse = MpesaVerifyResponse.fromJson(decodedResponseMap);
      // log('mpesa service => mpesa verify payment here = $mpesaVerifyResponse');

      apiResponse.data = mpesaVerifyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }
}
