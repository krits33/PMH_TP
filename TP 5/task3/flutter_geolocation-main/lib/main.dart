import 'package:flutter/material.dart';
import 'package:flutter_geolocation/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Tracking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 116, 183)),
        useMaterial3: true,
      ),
      home: const MapPage(title: 'Live Tracking App'),
    );
  }
}
