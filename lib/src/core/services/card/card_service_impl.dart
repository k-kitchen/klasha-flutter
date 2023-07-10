import 'package:klasha_checkout/src/core/core.dart';

class CardServiceImpl extends CardService with KlashaBaseService {
  @override
  Future<ApiResponse> addBankCard(BankCardDetailsBody bankCardDetailsBody) async {
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

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else if (decodedResponseMap == null) {
      apiResponse.message = 'Payment Successful';

    } else {
      AddBankCardResponse addBankCardResponse = AddBankCardResponse.fromJson(decodedResponseMap);
      // log('card service => add bank card response = $addBankCardResponse');

      apiResponse.data = addBankCardResponse;
      apiResponse.message = 'Charge authorization data required';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse<AuthenticateBankCardResponse>> authenticateCardPayment(AuthenticateCardPaymentBody authenticateCardPaymentBody) async {
    ApiResponse<AuthenticateBankCardResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.authenticateCardPaymentUrl;

    final requestBody = authenticateCardPaymentBody.toJson();

    Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    var decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

      apiResponse.data = AuthenticateBankCardResponse.fromJson(decodedResponseMap);

    } else {
      AuthenticateBankCardResponse authenticateBankCardResponse = AuthenticateBankCardResponse.fromJson(decodedResponseMap);
      // log('card service => authenticate bank card response = $authenticateBankCardResponse');

      apiResponse.data = authenticateBankCardResponse;
      apiResponse.message = 'Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com';
    }

    return apiResponse;
  }

  @override
  Future<ApiResponse> validateCardPayment(ValidateCardPaymentBody validateCardPaymentBody) async {
    ApiResponse<ValidateBankCardResponse> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.validateCardPaymentUrl;

    final requestBody = validateCardPaymentBody.toJson();

    Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    var decodedResponseMap = decodedResponseBody;

    if (decodedResponseMap['status'] == 'error') {
      apiResponse.status = false;
      apiResponse.message = decodedResponseMap['message'];

    } else {
      ValidateBankCardResponse validateBankCardResponse = ValidateBankCardResponse.fromJson(decodedResponseMap);
      // log('card service => validate bank card response = $validateBankCardResponse');

      apiResponse.data = validateBankCardResponse;
      apiResponse.message = 'Charge validated';
    }

    return apiResponse;
  }
}
