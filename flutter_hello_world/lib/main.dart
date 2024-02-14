// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = '';

  // Future<void> fetchMessage() async {
  //   final http.Response response =
  //       await http.get(Uri.parse('http://localhost:8000/api/hello'));
  Future<void> fetchMessage() async {
    final http.Response response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/hello'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        message = data['message'];
      });
    } else {
      setState(() {
        message = 'Failed to fetch message';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Laravel Hello World'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
