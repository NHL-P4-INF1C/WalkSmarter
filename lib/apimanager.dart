import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future <http.Response> sendRequest(
  Map<String, dynamic> payload, 
  String url,
  {
    bool isDevBranch = false
  }
) async
{
  try
  {
    await dotenv.load(fileName: '.env');
  }
  catch(e)
  {
    return http.Response('e', 500);
  }
  String apiUrl = '${dotenv.env["API_URL"]!}:${dotenv.env["API_PORT"]!}${isDevBranch ? '/dev_env/' : '/api/'}$url';
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
  bool isDevBranch;
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
    {
      this.isDevBranch = false
    }
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
    http.Response response = await sendRequest(payload, url, isDevBranch: isDevBranch);
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

//Temp frontend page. Everything below this comment is just example/ test code

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello, World!"),
        ),
        body: Center(
          child: Column(
            children: [
              SelectionButton(
                {'test': 'HELLO, wORLD!'}, 
                {'test': 1}, 
                'param_test')
              ],
          )
        ),
      ),
    );
  }
}

//This is an example button that makes an HTTP request using the RequestManager class

class SelectionButton extends StatefulWidget
{
  late final RequestManager requestManager;

  SelectionButton(    
    Map<String, dynamic> defaultState,
    Map<String, dynamic> payloadData,
    String url,
    {
      isDevBranch = false, 
      super.key
    }
  )
  {
    requestManager = RequestManager(
      defaultState,
      payloadData,
      url,
      isDevBranch: isDevBranch
    );
  }

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton>
{
  bool _requestMade = false;
  late Map<String, dynamic> _response;

  @override
  Widget build(BuildContext context)
  {
    //This is cursed... but it works :3
    return ElevatedButton(
      onPressed: () async {
        //Wait for the RequestManager to finish it's makeApiCall() function before going on
        _response = await widget.requestManager.makeApiCall();
        setState(() {
          _requestMade = true;
        });
      },
      child: Text(
        !_requestMade 
          //Default message setup in the constructor of the button
          ? widget.requestManager.getCurrentOutput()['response']['test'].toString()
          //Output of the API
          : _response['response'].toString(),
      ),
    );
  }
}
