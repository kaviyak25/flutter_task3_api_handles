import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String responseData = ''; // To store the response data

  void fetchData() async {
    var client = HttpClient();
    try {
      HttpClientRequest request = await client
          .getUrl(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      // Optionally set up headers...
      // Optionally write to the request object...
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final stringData = await response.transform(utf8.decoder).join();
        setState(() {
          responseData = stringData; // Update the state with response data
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP Request App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Response Data:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              responseData, // Display the response data here
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
