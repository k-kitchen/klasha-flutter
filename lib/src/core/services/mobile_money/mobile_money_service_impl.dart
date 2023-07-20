import 'package:klasha_checkout_v2/src/core/core.dart';
import 'package:klasha_checkout_v2/src/core/models/responses/mobile_money/mobile_money_verify_response.dart';
import 'package:klasha_checkout_v2/src/core/services/mobile_money/mobile_money_service.dart';

class MobileMoneyServiceImpl extends MobileMoneyService with KlashaBaseService {
  @override
  Future<ApiResponse> mobileMoneyPay(
      MobileMoneyRequestBody mobileMoneyRequestBody) async {
    ApiResponse<MobileMoneyResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.mobileMoneyUrl;

    final requestBody = mobileMoneyRequestBody.toJson();

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
      MobileMoneyResponse mobileMoneyResponse =
          MobileMoneyResponse.fromJson(decodedResponseMap);
      apiResponse.data = mobileMoneyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse> verifyPayment(String tnxId, String orderId) async {
    ApiResponse<MobileMoneyVerifyResponse> apiResponse =
        ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.verifyPaymentUrl('GHS');

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
      MobileMoneyVerifyResponse mobileMoneyVerifyResponse =
          MobileMoneyVerifyResponse.fromJson(decodedResponseMap);
      apiResponse.data = mobileMoneyVerifyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }
}
