import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static String LOGIN_MOBILE_NUMBER = "login_mobile_number";



  Future<bool> keycontains(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey(key)) {
      return true;
    }
    return false;
  }

  save(String key, dynamic value) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    } else {
      sharedPrefs.setString(key, value);
    }
    return true;
  }

  getBool(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey(key)) {
      return false;
    }
    return sharedPrefs.getBool(key);
  }

  getString(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(key);
  }

  getInt(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getInt(key);
  }

  getDouble(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getDouble(key);
  }

  getObject(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.get(key);
  }
  getStringList(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getStringList(key);
  }

  remove(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key);
  }

}
