import 'package:flutter/material.dart';


// This class provides a way to manage and switch themes (light and dark)
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  // Getter to access the current theme data
  ThemeData get themeData => _themeData;

  // Method to switch between light and dark themes
  void switchTheme() {
    if (_themeData == ThemeData.light()){
      _themeData = ThemeData.dark();
    }
    else{
      _themeData = ThemeData.light();
    }
    // Notify listeners (UI components) about the theme change
    notifyListeners();
  }
}