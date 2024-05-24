import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future <http.Response> sendRequest(
  Map<String, dynamic> payload, 
  String url,
) async
{
  await dotenv.load(fileName: '.env');
  String apiUrl = '${dotenv.env["API_URL"]!}:${dotenv.env["API_PORT"]!}/api/$url';
  try 
  {
    return await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>
      {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>
      {
        'payload': payload
      }),
    ).timeout(const Duration(seconds: 5));
  } 
  catch (e) 
  {
    return http.Response(e.toString(), 500);
  }
}

class RequestManager
{
  String url;
  late Map<String, dynamic> payload;
  late Map<String, dynamic> output =
  {
    'response': 0
  };

  RequestManager(
    Map<String, dynamic> defaultState, 
    Map<String, dynamic> payloadData, 
    this.url, 
  )
  {
    payload = payloadData; 
    output['response'] = defaultState;
  }

  Future<Map<String, dynamic>> makeApiCall() async
  { 
    await updateStatus();
    return output;
  }

  Map<String, dynamic> getCurrentOutput()
  {
    return output;
  }

  void setPayload(Map<String, dynamic> payload)
  {
    this.payload = payload;
  }

  Future<void> updateStatus() async
  {
    http.Response response = await sendRequest(payload, url);
    String jsonString = response.body; 
    if (response.statusCode == 200) 
    {
      try 
      {
        output = jsonDecode(jsonString);
      } 
      catch (e) 
      {
        output['response'] = "Failed to decode package: ${e.toString()}";
      }
    } 
    else 
    {
      output['response'] = "Failed to connect to API. status code: ${response.statusCode}, response: $jsonString";
    }
  }
}