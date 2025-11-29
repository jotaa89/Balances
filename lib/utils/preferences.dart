import 'package:hive/hive.dart';

class AppPreferences {
  static const String _prefsBoxName = 'app_preferences';
  static const String _showBalanceKey = 'show_balance';

  static Box? _prefsBox;

  static Future<void> init() async {
    _prefsBox = await Hive.openBox(_prefsBoxName);
  }

  static bool getShowBalance() {
    return _prefsBox?.get(_showBalanceKey, defaultValue: true) ?? true;
  }

  static Future<void> setShowBalance(bool value) async {
    await _prefsBox?.put(_showBalanceKey, value);
  }
}
