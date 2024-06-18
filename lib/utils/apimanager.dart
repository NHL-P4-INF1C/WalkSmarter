import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'pocketbase.dart';

var pb = PocketBaseSingleton().instance;

Future<String?> getHashToken() async {
  try {
    await pb.admins.authWithPassword(
        dotenv.env["ADMIN_EMAIL"]!, dotenv.env["ADMIN_PASSWORD"]!);
    final result = await pb.collection('api').getList(
          page: 1,
          perPage: 1,
          sort: '-created',
        );

    if (result.items.isNotEmpty) {
      final hash = result.items.first.data['hash'];
      if (hash is String) {
        return hash;
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<http.Response> sendRequest(
  Map<String, dynamic> payload,
  String url,
) async {
  String apiUrl = '${dotenv.env["API_URL"]!}/api/$url';

  try {
    String? token;
    if (dotenv.env["DEV_ENV"] == null) {
      token = await getHashToken() ?? '';
      if (token.isEmpty) {
        // Returning a fake status code to trick the rest of the manager into outputting this response. It's ugly, but it works
        return http.Response(
            '{"response": "Failed to connect to PocketBase: Failed to get API token"}',
            600);
      }
    } else {
      token = dotenv.env["DEV_ENV"]!;
    }

    return await http
        .post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'jwt': token,
          },
          body: jsonEncode(<String, dynamic>{'payload': payload}),
        )
        .timeout(const Duration(seconds: 10));
  } catch (e) {
    print(e);
    return http.Response(e.toString(), 500);
  }
}

class RequestManager {
  String url;
  late Map<String, dynamic> payload;
  late Map<String, dynamic> output = {};

  RequestManager(
    Map<String, dynamic> payloadData,
    this.url,
  ) {
    payload = payloadData;
  }

  Future<Map<String, dynamic>> makeApiCall() async {
    await updateStatus();
    return output;
  }

  Map<String, dynamic> getCurrentOutput() {
    return output;
  }

  void setPayload(Map<String, dynamic> payload) {
    this.payload = payload;
  }

  Future<void> updateStatus() async {
    http.Response response = await sendRequest(payload, url);
    String jsonString = response.body;
    if (response.statusCode == 200) {
      try {
        output = jsonDecode(jsonString);
      } catch (e) {
        output['response'] = "Failed to decode package: ${e.toString()}";
      }
      output['statusCode'] = response.statusCode;
    } else if (response.statusCode == 600) {
      output = jsonDecode(jsonString);
      output['statusCode'] = 404;
    } else {
      output['response'] = "Failed to connect to API, response: $jsonString";
      output['statusCode'] = response.statusCode;
    }
  }
}
