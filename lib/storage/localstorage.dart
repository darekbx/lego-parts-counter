import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  final String _apiKey = "apiKey";

  void setApiKey(String apiKey) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(_apiKey, apiKey);
  }

  Future<bool> hasApiKey() async {
    var storage = await SharedPreferences.getInstance();
    return storage.containsKey(_apiKey) && storage.getString(_apiKey).isNotEmpty;
  }

  Future<String> getApiKey() async =>
      (await SharedPreferences.getInstance()).getString(_apiKey);
}