import 'package:flutter/material.dart';
import 'panorama_screen.dart';

void main() {
  runApp(ARPanoramaApp());
}

class ARPanoramaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Panorama',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PanoramaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}