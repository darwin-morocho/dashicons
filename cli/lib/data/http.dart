import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../domain/models/http_result.dart';

enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete,
}

class Http {
  Http(this._baseUrl, this._client);

  final String _baseUrl;
  final Client _client;

  Future<HttpResult<T>> send<T>(
    String path, {
    required T Function(int statusCode, dynamic data) parser,
    HttpMethod method = HttpMethod.get,
    String query = '',
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},

    /// if autoDecodeReponse is false on the parser callback you will receive response.bodyBytes (Uint8List)
    bool autoDecodeReponse = true,
  }) async {
    late Request request;
    late Uri url;
    Response? response;

    try {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        url = Uri.parse(path);
      } else {
        if (!path.startsWith('/')) {
          path = '/$path';
        }
        url = Uri.parse('$_baseUrl$path');
      }

      if (queryParameters.isNotEmpty) {
        url = url.replace(
          queryParameters: queryParameters,
        );
      } else if (query.isNotEmpty) {
        url = url.replace(query: query);
      }

      request = Request(method.name, url);
      headers = {
        ...headers,
        'Content-Type': 'application/json; charset=utf-8',
      };

      request.headers.addAll(headers);

      if (method != HttpMethod.get) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await _client.send(request);
      response = await Response.fromStream(streamedResponse);

      final statusCode = response.statusCode;
      final responseBody = autoDecodeReponse
          ? _parseResponseBody(response.body)
          : response.bodyBytes;
      print(responseBody);

      if (statusCode >= 200 && statusCode <= 399) {
        return HttpResult.success(
          statusCode,
          parser(
            statusCode,
            responseBody,
          ),
        );
      }

      log(response.statusCode.toString());
      log(response.body);

      return HttpResult.failed(
        statusCode,
        responseBody,
      );
    } catch (e, s) {
      print(e);
      print(s);
      return HttpResult.failed(
        response?.statusCode,
        e,
      );
    }
  }
}

dynamic _parseResponseBody(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (_) {
    return responseBody;
  }
}
