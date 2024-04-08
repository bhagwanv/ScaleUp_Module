import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  final String LOGIN_MOBILE_NUMBER = "login_mobile_number";
  final String USER_ID = "user_id";
  final String TOKEN = "token";
  final String LEADE_ID = "lead_id";
  final int COMPANY_ID = 2;
  final int PRODUCT_ID = 2;



  Future<bool> keycontains(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.containsKey(key)) {
      return true;
    }
    return false;
  }

  Future<void> save(String? key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key!, value);
    } else if (value is String) {
      prefs.setString(key!, value);
    } else if (value is int) {
      prefs.setInt(key!, value);
    } else if (value is double) {
      prefs.setDouble(key!, value);
    } else if (value is List<String>) {
      prefs.setStringList(key!, value);
    } else {
      prefs.setString(key!, value);
    }
  }

  Future<String?> getString(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Return String
    return prefs.getString(key!);
  }

  Future<bool?> getBool(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey(key)) {
      return false;
    }
    return sharedPrefs.getBool(key);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getDouble(key);
  }

  remove(String key) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key);
  }
}
