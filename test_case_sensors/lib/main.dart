import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_sensors/Models/model.dart';
import 'package:test_case_sensors/View/view_home.dart';
import 'package:test_case_sensors/ViewModel/viewmodel.dart';
import 'View/view_provider.dart';


// Using ChangeNotifierProvider to provide ThemeProvider for the whole app
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SensorViewModel(model: SensorModel())),
        ChangeNotifierProvider(create: (context) => ThemeProvider(ThemeData.dark())),
      ],
      
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
      home: const SensorHomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}