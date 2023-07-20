import 'package:klasha_checkout_v2/src/core/core.dart';

class CardServiceImpl extends CardService with KlashaBaseService {
  @override
  Future<ApiResponse<AddBankCardResponse>> addBankCard(
    BankCardDetailsBody bankCardDetailsBody,
  ) async {
    ApiResponse<AddBankCardResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.addBankCardUrl;

    final requestBody = bankCardDetailsBody.toJson();

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
    } else if (decodedResponseMap.isEmpty) {
      apiResponse.message = 'Payment Successful';
    } else {
      AddBankCardResponse addBankCardResponse =
          AddBankCardResponse.fromJson(decodedResponseMap);

      apiResponse.data = addBankCardResponse;
      apiResponse.message = 'Charge authorization data required';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse<AuthenticateBankCardResponse>> authenticateCardPayment(
    AuthenticateCardPaymentBody authenticateCardPaymentBody,
  ) async {
    ApiResponse<AuthenticateBankCardResponse> apiResponse =
        ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.authenticateCardPaymentUrl;

    final requestBody = authenticateCardPaymentBody.toJson();

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

      apiResponse.data =
          AuthenticateBankCardResponse.fromJson(decodedResponseMap);
    } else {
      AuthenticateBankCardResponse authenticateBankCardResponse =
          AuthenticateBankCardResponse.fromJson(decodedResponseMap);

      apiResponse.data = authenticateBankCardResponse;
      apiResponse.message = authenticateBankCardResponse.message;
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse<ValidateBankCardResponse>> validateCardPayment(
    ValidateCardPaymentBody validateCardPaymentBody,
  ) async {
    ApiResponse<ValidateBankCardResponse> apiResponse =
        ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.validateCardPaymentUrl;

    final requestBody = validateCardPaymentBody.toJson();

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
      var validateBankCardResponse =
          ValidateBankCardResponse.fromJson(decodedResponseMap);

      apiResponse.data = validateBankCardResponse;
      apiResponse.message = 'Charge validated';
    }

    return apiResponse;
  }
}
