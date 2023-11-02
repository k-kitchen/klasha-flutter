import 'package:klasha_checkout_v2/src/core/core.dart';

class CardServiceImpl extends CardService with KlashaBaseService {
  @override
  Future<ApiResponse<AuthenticateBankCardResponse>> addBankCard(
    BankCardDetailsBody body,
  ) async {
    ApiResponse<AuthenticateBankCardResponse> apiResponse =
        ApiResponse(status: true);
    try {
      final String url =
          ApiUrls.baseUrl + ApiUrls.addBankCardUrl(body.currency);

      final requestBody = body.toJson();

      Map<String, dynamic> decodedResponseBody = await getApiResponse(
        authorization: 'authorization',
        url: url,
        requestType: RequestType.post,
        requestBody: requestBody,
      );

      var decodedResponseMap = decodedResponseBody;

      var status = getStatus(decodedResponseMap);

      if (status.isFail) {
        throw status.errorMessage ?? 'An error occurred';
      } else if (decodedResponseMap.isEmpty) {
        apiResponse.message = 'Payment Successful';
      } else {
        AuthenticateBankCardResponse addBankCardResponse =
            AuthenticateBankCardResponse.fromJson(decodedResponseMap);

        apiResponse.data = addBankCardResponse;
        apiResponse.message = 'Charge authorization data required';
      }
    } catch (e) {
      apiResponse.status = false;
      apiResponse.message = '$e';
    }
    return apiResponse;
  }

  @override
  Future<ApiResponse<AuthenticateBankCardResponse>> authenticateCardPayment(
    AuthenticateCardPaymentBody body,
  ) async {
    ApiResponse<AuthenticateBankCardResponse> apiResponse =
        ApiResponse(status: true);
    try {
      final String url =
          ApiUrls.baseUrl + ApiUrls.authenticateCardPaymentUrl(body.currency);

      final requestBody = body.toJson();

      Map<String, dynamic> decodedResponseBody = await getApiResponse(
        authorization: 'authorization',
        url: url,
        requestType: RequestType.post,
        requestBody: requestBody,
      );

      var decodedResponseMap = decodedResponseBody;

      var status = getStatus(decodedResponseMap);

      if (status.isFail) {
        throw status.errorMessage ?? 'An error occurred';
      } else {
        AuthenticateBankCardResponse authenticateBankCardResponse =
            AuthenticateBankCardResponse.fromJson(decodedResponseMap);

        apiResponse.data = authenticateBankCardResponse;
        apiResponse.message = authenticateBankCardResponse.message;
      }

      return apiResponse;
    } catch (e, st) {
      print(st);
      apiResponse.status = false;
      apiResponse.message = '$e';
    }
    return apiResponse;
  }

  @override
  Future<ApiResponse<ValidateBankCardResponse>> validateCardPayment(
    ValidateCardPaymentBody body,
  ) async {
    ApiResponse<ValidateBankCardResponse> apiResponse =
        ApiResponse(status: true);

    try {
      final String url =
          ApiUrls.baseUrl + ApiUrls.validateCardPaymentUrl(body.currency);

      final requestBody = body.toJson();

      Map<String, dynamic> decodedResponseBody = await getApiResponse(
        authorization: 'authorization',
        url: url,
        requestType: RequestType.post,
        requestBody: requestBody,
      );

      var decodedResponseMap = decodedResponseBody;

      var status = getStatus(decodedResponseMap);

      if (status.isFail) {
        throw status.errorMessage ?? 'An error occurred';
      } else {
        var validateBankCardResponse =
            ValidateBankCardResponse.fromJson(decodedResponseMap);

        apiResponse.data = validateBankCardResponse;
        apiResponse.message = 'Charge validated';
      }
    } catch (e, st) {
      print(st);
      apiResponse.status = false;
      apiResponse.message = '$e';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse<bool>> confirmTransaction(String txnRef) async {
    ApiResponse<bool> apiResponse = ApiResponse(status: true);

    try {
      final String url = ApiUrls.baseUrl + ApiUrls.checkTransaction;

      final requestBody = {"tnxRef": txnRef};

      Map<String, dynamic> decodedResponseBody = await getApiResponse(
        authorization: 'authorization',
        url: url,
        requestType: RequestType.post,
        requestBody: requestBody,
      );

      apiResponse.data =
          decodedResponseBody['status']?.toString().toLowerCase() ==
              'successful';
    } catch (e, st) {
      print(st);
      apiResponse.status = false;
      apiResponse.message = '$e';
    }

    return apiResponse;
  }
}
