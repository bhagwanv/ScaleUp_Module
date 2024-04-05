import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final SharedPref _instance = SharedPref._internal();
  final String? MOBILE_NUMBER = "";
  String myName = "name";

  factory SharedPref() {
    return _instance;
  }

  SharedPref._internal();

  Future<void> addStringToSF(String? key,String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key!, value!);
  }

  Future<void> addIntToSF(String? key,int? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key!, value!);
  }

  Future<void> addDoubleToSF(String? key,double? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key!, value!);
  }

  Future<void> addBoolToSF(String? key,bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key!, value!);
  }


  Future<String?> getStringValuesSF(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Return String
    return prefs.getString(key!);
  }

  Future<int?> getIntValuesSF(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Return int
    return prefs.getInt(key!);
  }

  Future<double?> getDoubleValuesSF(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Return double
    return prefs.getDouble(key!);
  }
}
