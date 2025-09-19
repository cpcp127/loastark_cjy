import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  static SharedPreferences? _prefs;

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  /// 초기화 (main 함수에서 반드시 호출)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// String 저장
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// String 불러오기
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// int 저장
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// int 불러오기
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// bool 저장
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// bool 불러오기
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// 값 삭제
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// 전체 삭제
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
