// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  // Initialize the SharedPreferences instance
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Method to save data of type String
  static Future<bool> saveData({
    required String key,
    required String value,
  }) async {
    return await _sharedPreferences!.setString(key, value);
  }

  // Method to save data of type int
  static Future<bool> saveIntData({
    required String key,
    required int value,
  }) async {
    return await _sharedPreferences!.setInt(key, value);
  }

  // Method to save data of type bool
  static Future<bool> saveBoolData({
    required String key,
    required bool value,
  }) async {
    return await _sharedPreferences!.setBool(key, value);
  }

  // Method to save data of type double
  static Future<bool> saveDoubleData({
    required String key,
    required double value,
  }) async {
    return await _sharedPreferences!.setDouble(key, value);
  }

  // Method to get data of type String
  static String? getData({required String key}) {
    return _sharedPreferences!.getString(key);
  }

  // Method to get data of type int
  static int? getIntData({required String key}) {
    return _sharedPreferences!.getInt(key);
  }

  // Method to get data of type bool
  static bool? getBoolData({required String key}) {
    return _sharedPreferences!.getBool(key);
  }

  // Method to get data of type double
  static double? getDoubleData({required String key}) {
    return _sharedPreferences!.getDouble(key);
  }

  // Method to remove data
  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences!.remove(key);
  }

  // Method to clear all data
  static Future<bool> clearData() async {
    return await _sharedPreferences!.clear();
  }
}
