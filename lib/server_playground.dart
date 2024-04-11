import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String serverUrl = 'http://10.0.2.2:5000/create_index_cards_from_files';
  final String apiKey = '1234';
  final String userUuid = '1234';

  TextEditingController responseController = TextEditingController();

  Future<http.Response> makeRequest() async {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_uuid': userUuid,
        'openai_api_key': apiKey,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to make request: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Server Playground'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  makeRequest().then((response) {
                    print(response.body);
                    responseController.text = response.body;
                  }).catchError((error) {
                    responseController.text = 'Error: $error';
                  });
                },
                child: Text('Make Request'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: responseController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Response',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}