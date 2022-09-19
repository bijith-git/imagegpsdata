import 'package:flutter/material.dart';
import 'package:googlemap/google_map.dart';
import 'package:googlemap/image_add_gps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'google map',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ImageToGps(),
    );
  }
}
