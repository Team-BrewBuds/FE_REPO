import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  late final SharedPreferences _prefs;
  SharedPreferencesRepository._();

  static final SharedPreferencesRepository _instance = SharedPreferencesRepository._();

  static SharedPreferencesRepository get instance => _instance;

  factory SharedPreferencesRepository() => instance;

  List<String> get recentSearchWords => _prefs.getStringList('search_words') ?? [];

  bool get haveRequestPermission => _prefs.getBool('request_permission') ?? false;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setRecentSearchWords(List<String> searchWords) {
    return _prefs.setStringList('search_words', searchWords);
  }

  Future<void> removeAllSearchWords() {
    return _prefs.remove('search_words');
  }

  Future<void> setPermission() {
    return _prefs.setBool('request_permission', true);
  }
}