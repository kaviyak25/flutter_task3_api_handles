import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(HttpPostDemoApp());
}

class HttpPostDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP POST Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HttpPostDemoScreen(),
    );
  }
}

class HttpPostDemoScreen extends StatefulWidget {
  @override
  _HttpPostDemoScreenState createState() => _HttpPostDemoScreenState();
}

class _HttpPostDemoScreenState extends State<HttpPostDemoScreen> {
  String responseText = '';

  Future<void> sendHttpPostRequest() async {
    var client = HttpClient();

    try {
      var request = await client
          .postUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      request.headers.set('Content-Type', 'application/json; charset=UTF-8');

      final postData = {
        'userId': 1,
        'id': null,
        'title': 'Sample Post',
        'body': 'This is the body of the sample post.',
      };

      var jsonPayload = json.encode(postData);
      request.write(jsonPayload);

      var response = await request.close();

      if (response.statusCode == HttpStatus.created) {
        final stringData = await response.transform(utf8.decoder).join();
        setState(() {
          responseText = 'Response data:\n$stringData';
        });
      } else {
        setState(() {
          responseText = 'Request failed with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'An error occurred: $e';
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP POST Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: sendHttpPostRequest,
              child: Text('Send POST Request'),
            ),
            SizedBox(height: 20),
            Text(
              responseText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
