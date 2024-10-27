import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_sensors/View/view_home.dart';
import 'View/view_provider.dart';


// Using ChangeNotifierProvider to provide ThemeProvider for the whole app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(ThemeData.light()),
      child: const MyApp(),
    ),
  );
}


// Main application class
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorHomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}