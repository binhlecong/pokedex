import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  late bool _isDark;
  late SharedPreferences _prefs;

  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: const Color(0xffa30000),
    disabledColor: Colors.redAccent,
    highlightColor: const Color(0xffff7700),
    brightness: Brightness.dark,
    hintColor: const Color(0xffefd28d),
    dividerColor: Colors.black54,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.red,
    primaryColor: const Color(0xfffa003f),
    disabledColor: Colors.redAccent,
    highlightColor: const Color(0xffffcf00),
    brightness: Brightness.light,
    hintColor: const Color(0xfffeefe5),
    dividerColor: Colors.white54,
  );

  ThemeChanger() {
    _isDark = false;
    _loadFromPrefs();
  }

  get getDarkMode => _isDark;
  get getTheme => _isDark ? darkTheme : lightTheme;

  toggleMode() async {
    _isDark = !_isDark;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('brightness', _isDark);
    notifyListeners();
  }

  setModeLight() async {
    _isDark = false;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('brightness', _isDark);
    notifyListeners();
  }

  setModeDark() async {
    _isDark = true;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('brightness', _isDark);
    notifyListeners();
  }

  _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isDark = _prefs.getBool('brightness') ?? false;
    notifyListeners();
  }
}
