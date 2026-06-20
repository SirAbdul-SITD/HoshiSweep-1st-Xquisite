// lib/utils/preferences.dart
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();
  static final Preferences instance = Preferences._();
  late SharedPreferences _prefs;

  static const _kPrefix = 'HOSHISWEEP_';
  static const _kSound = '${_kPrefix}sound';
  static const _kVibration = '${_kPrefix}vibration';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isSoundEnabled() => _prefs.getBool(_kSound) ?? true;
  bool isVibrationEnabled() => _prefs.getBool(_kVibration) ?? true;
  void setSound(bool v) => _prefs.setBool(_kSound, v);
  void setVibration(bool v) => _prefs.setBool(_kVibration, v);

  int getStars(int level) => _prefs.getInt('${_kPrefix}lvl_$level') ?? 0;
  bool isUnlocked(int level) =>
      level == 0 || (_prefs.getInt('${_kPrefix}lvl_${level - 1}') ?? 0) > 0;

  void saveLevelResult(int level, int stars) {
    final cur = getStars(level);
    if (stars > cur) _prefs.setInt('${_kPrefix}lvl_$level', stars);
  }

  int totalStars() {
    int t = 0;
    for (int i = 0; i < 150; i++) {
      t += getStars(i);
    }
    return t;
  }
}
