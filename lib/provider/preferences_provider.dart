import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getTheme();
    _getDailyRestaurantsPreferences();
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isDailyRestaurantsActive = false;
  bool get isDailyRestaurantsActive => _isDailyRestaurantsActive;

  ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  void _getTheme() async {
    _isDarkTheme = await preferencesHelper.isDarkTheme;
    notifyListeners();
  }

  void _getDailyRestaurantsPreferences() async {
    _isDailyRestaurantsActive =
        await preferencesHelper.isDailyRestaurantsActive;
    notifyListeners();
  }

  void enableDarkTheme(bool value) {
    preferencesHelper.setDarkTheme(value);
    _getTheme();
  }

  void enableDailyRestaurants(bool value) {
    preferencesHelper.setDailyRestaurants(value);
    _getDailyRestaurantsPreferences();
  }
}
