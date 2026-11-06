import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get instance => _prefs;
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _currentLanguage = 'ar';
  Color _primaryColor = Colors.blue;
  bool _useAnimations = true;

  ThemeProvider() {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  String get currentLanguage => _currentLanguage;
  Color get primaryColor => _primaryColor;
  bool get useAnimations => _useAnimations;

  Future<void> _loadSettings() async {
    final prefs = SharedPreferencesService.instance;
    
    final themeIndex = prefs.getInt('themeMode') ?? 2;
    _themeMode = ThemeMode.values[themeIndex];
    
    _currentLanguage = prefs.getString('language') ?? 'ar';
    
    final colorValue = prefs.getInt('primaryColor') ?? Colors.blue.value;
    _primaryColor = Color(colorValue);
    
    _useAnimations = prefs.getBool('useAnimations') ?? true;
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await SharedPreferencesService.instance.setInt('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
    await SharedPreferencesService.instance.setString('language', languageCode);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await SharedPreferencesService.instance.setInt('primaryColor', color.value);
    notifyListeners();
  }

  Future<void> setUseAnimations(bool value) async {
    _useAnimations = value;
    await SharedPreferencesService.instance.setBool('useAnimations', value);
    notifyListeners();
  }
}