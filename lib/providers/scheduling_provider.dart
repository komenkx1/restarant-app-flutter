import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/helper/backgroud_services.dart';
import 'package:restaurant_app/helper/date_time_helper.dart';
import 'package:restaurant_app/helper/preferance_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider extends ChangeNotifier {
  SchedulingProvider() {
    getIsScheduled();
  }
  final PreferencesHelper _preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<void> getIsScheduled() async {
    _isScheduled = await _preferencesHelper.isPreferanceActive;
    scheduledNews(_isScheduled);
    notifyListeners();
  }

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    _preferencesHelper.setActivePreferance(value);
    if (_isScheduled) {
      print('Scheduling Restaurant Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      // print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
