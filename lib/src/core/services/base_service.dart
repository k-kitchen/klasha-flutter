import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete }

mixin KlashaBaseService {
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> getApiResponse({
    @required String authorization,
    RequestType requestType,
    String url,
    Map<String, dynamic> requestBody,
  }) async {
    final _headers = _getHeaders(authorization);
    final uri = Uri.parse(url);
    http.Response response;

    switch (requestType) {
      case RequestType.get:
        if (url != null) {
          response = await _client.get(
            uri,
            headers: _headers,
          );
        }
        break;
      case RequestType.post:
        if (url != null && requestBody != null) {
          response = await _client.post(
            uri,
            body: jsonEncode(requestBody),
            headers: _headers,
          );
        }
        break;
      case RequestType.put:
        // TODO(timilehinjegede): Handle put request type.
        break;
      case RequestType.delete:
        // TODO(timilehinjegede): Handle delete request type.
        break;
      default:
        throw Exception('Request Type not implemented');
    }

    final int statusCode = response.statusCode;
    log('base service => response body = ${response.body}; response status code = ${response.statusCode}');

    if (statusCode == HttpStatus.ok) {
      // log('base service, http ok if check passed');
      return jsonDecode(response.body);
    } else {
      // log('base service, http ok if check NOT passed');
    }
  }

  Map<String, String> _getHeaders(String authorization) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.acceptHeader: 'application/x-www-form-urlencoded',
      'x-auth-token': 'GByi/gkhn5+BX4j6uI0lR7HCVo2NvTsVAQhyPko/uK4=',
    };
  }
}
