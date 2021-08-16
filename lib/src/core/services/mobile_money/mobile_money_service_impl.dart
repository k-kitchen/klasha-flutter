import 'dart:developer';

import 'package:klasha_checkout/src/core/config/api_response.dart';
import 'package:klasha_checkout/src/core/core.dart';
import 'package:klasha_checkout/src/core/models/requests/mobile_money/mobile_money_request_body.dart';
import 'package:klasha_checkout/src/core/models/responses/mobile_money/mobile_money_verify_response.dart';
import 'package:klasha_checkout/src/core/services/mobile_money/mobile_money_service.dart';

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

    Map decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else {
      MobileMoneyResponse mobileMoneyResponse = MobileMoneyResponse.fromJson(decodedResponseMap);
      log('mobile money service => mobile money  payment here = $mobileMoneyResponse');

      apiResponse.data = mobileMoneyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse> verifyPayment(String tnxId, String orderId) async {
    ApiResponse<MobileMoneyVerifyResponse> apiResponse = ApiResponse(status: true);

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

    Map decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else {
      MobileMoneyVerifyResponse mobileMoneyVerifyResponse = MobileMoneyVerifyResponse.fromJson(decodedResponseMap);
      log('mobile money service => mobile money verify payment here = $mobileMoneyVerifyResponse');

      apiResponse.data = mobileMoneyVerifyResponse;
      apiResponse.message = 'Successful';
    }

    return apiResponse;
  }
}
