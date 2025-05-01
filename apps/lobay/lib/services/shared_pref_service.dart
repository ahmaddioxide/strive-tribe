import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static final PreferencesManager _preferencesManagerInstance = PreferencesManager._();

  static PreferencesManager getInstance() {
    return _preferencesManagerInstance;
  }
  PreferencesManager._();


  Future<SharedPreferences> getPreferences() async {
    final SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Future<void> setStringValue(String key, String value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future<String> getStringValue(String key, String defaultValue) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  Future<void> setBoolValue(String key, bool value) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  Future<bool> getBoolValue(String key, bool defaultValue) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? defaultValue;
  }


  Future<void> clearAllPref() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }



}
