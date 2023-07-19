import 'package:klasha_checkout/src/core/core.dart';

class MpesaServiceImpl extends MpesaService with KlashaBaseService {
  @override
  Future<ApiResponse> paywithMpesa(MpesaRequestBody mpesaRequestBody) async {
    ApiResponse<MpesaCheckoutResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.mpesaUrl;

    final requestBody = mpesaRequestBody.toJson();

    Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    var decodedResponseMap = decodedResponseBody;

    var status = getStatus(decodedResponseMap);

    if (status.isFail) {
      apiResponse.status = false;
      apiResponse.message = status.errorMessage;
    } else {
      MpesaCheckoutResponse mpesaCheckoutResponse =
          MpesaCheckoutResponse.fromJson(decodedResponseMap);
      apiResponse.data = mpesaCheckoutResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse> verifyPayment(String tnxId, String orderId) async {
    ApiResponse<MpesaVerifyResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.verifyPaymentUrl('KES');

    final requestBody = {
      'tnxId': tnxId,
      'orderId': orderId,
    };

    Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    var decodedResponseMap = decodedResponseBody;

    var status = getStatus(decodedResponseMap);

    if (status.isFail) {
      apiResponse.status = false;
      apiResponse.message = status.errorMessage;
    } else {
      MpesaVerifyResponse mpesaVerifyResponse =
          MpesaVerifyResponse.fromJson(decodedResponseMap);
      apiResponse.data = mpesaVerifyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }
}
