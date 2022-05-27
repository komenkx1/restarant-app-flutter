import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const restaurantReminder = 'RESTAURANT_REMINDER';

  Future<bool> get isPreferanceActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(restaurantReminder) ?? false;
  }

  void setActivePreferance(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(restaurantReminder, value);
  }
}
