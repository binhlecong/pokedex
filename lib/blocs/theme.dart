import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  late int _themeColor;
  late bool _isDark;
  late SharedPreferences _prefs;

  ThemeChanger() {
    _themeColor = 0;
    _isDark = false;
    _loadFromPrefs();
  }

  get getThemeIndex => _themeColor * 2 + (_isDark ? 1 : 0);
  get getDarkMode => _isDark;

  setTheme(int themeColor) async {
    _themeColor = themeColor;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('color', _themeColor);
    notifyListeners();
  }

  toggleMode() async {
    _isDark = !_isDark;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('brightness', _isDark);
    notifyListeners();
  }

  _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _themeColor = _prefs.getInt('color') ?? 0;
    _isDark = _prefs.getBool('brightness') ?? false;
    notifyListeners();
  }
}