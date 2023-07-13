import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete }

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
      RequestType.delete => response =
          await _client.delete(uri, headers: _headers),
    };

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Map<String, String> _getHeaders(String authorization) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-auth-token': 'GByi/gkhn5+BX4j6uI0lR7HCVo2NvTsVAQhyPko/uK4=',
    };
  }
}
