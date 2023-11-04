import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete }

late String globalAuthToken;

mixin KlashaBaseService {
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> getApiResponse({
    required String authorization,
    required RequestType requestType,
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    final _headers = _getHeaders(authorization);
    final uri = Uri.parse(url);
    http.Response? response;

    response = switch (requestType) {
      RequestType.get => await _client.get(uri, headers: _headers),
      RequestType.post => await _client.post(
          uri,
          body: jsonEncode(requestBody),
          headers: _headers,
        ),
      RequestType.put => await _client.put(
          uri,
          body: jsonEncode(requestBody),
          headers: _headers,
        ),
      RequestType.delete => await _client.delete(uri, headers: _headers),
    };

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception(getErrorMessage(response) ??
          'Request failed with status: ${response.statusCode}.');
    }
  }

  String? getErrorMessage(http.Response r, [String key = 'message']) {
    try {
      return jsonDecode(r.body)?[key];
    } catch (_) {
      return null;
    }
  }

  Map<String, String> _getHeaders(String authorization) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-auth-token': globalAuthToken,
    };
  }

  ({bool isFail, String? errorMessage}) getStatus(Map<String, dynamic> map) {
    var status =
        map['status'] ?? (map['data'] != null ? map['data']['status'] : null);

    var errorMessage =
        map['message'] ?? (map['data'] != null ? map['data']['message'] : null);

    return (
      isFail: ['error', 'failed'].contains(status),
      errorMessage: errorMessage,
    );
  }
}
