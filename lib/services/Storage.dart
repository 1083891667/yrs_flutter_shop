import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<String> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future<void> setList(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList(key, value);
  }

  static Future<List<String>> getList(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getStringList(key);
  }

  static Future<void> setMap(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, json.encode(value));
  }

  static Future<Map> getMap(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey(key)) {
      return json.decode(sp.getString(key));
    } else {
      return {};
    }
  }

  static Future<void> remove(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  static Future<void> clear() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
