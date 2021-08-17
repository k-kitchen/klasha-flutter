import 'dart:convert';
import 'dart:developer';

import 'package:klasha_checkout/src/core/core.dart';

class BankTransferServiceImpl extends BankTransferService
    with KlashaBaseService {
  @override
  Future<ApiResponse<BankAccountDetails>> getBankAccountDetails(
      BankTransferBody bankTransferBody) async {
    ApiResponse<BankAccountDetails> apiResponse = ApiResponse(status: true);

    final String url = ApiUrls.baseUrl + ApiUrls.bankTransferUrl;

    final requestBody = bankTransferBody.toJson();

    Map<String, dynamic> decodedResponseBody = await getApiResponse(
      authorization: 'authorization',
      url: url,
      requestType: RequestType.post,
      requestBody: requestBody,
    );

    Map decodedResponseMap = decodedResponseBody['meta']['authorization'];

    BankAccountDetails bankAccountDetails = BankAccountDetails.fromJson(decodedResponseMap);
    // log('bank transfer service => get bank details response = $bankAccountDetails');

    apiResponse.data = bankAccountDetails;
    apiResponse.message = 'Retrieved bank details successful';

    return apiResponse;
  }
}
