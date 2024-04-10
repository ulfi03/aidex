import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaterialApp(
      home: MyHomePage(),
    );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  String _response = '';

  Future<void> _makeRequest() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/create_index_cards_from_files'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_uuid': '1234',
        'openai_api_key': '1234',
      }),
    );
    final decoded = json.decode(response.body);

    setState(() {
      _response = decoded.toString();
      _textFieldController.text = _response; // Update the text field with the response
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Request Example'),
      ),
      body: Column(
        children: [
          Flexible(
            child: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                hintText: 'Response',
              ),
              maxLines: null, // Allow unlimited lines
              keyboardType: TextInputType.multiline, // Enable multiline input
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _makeRequest();
            },
            child: const Text('Make Request'),
          ),
        ],
      ),
    );
}