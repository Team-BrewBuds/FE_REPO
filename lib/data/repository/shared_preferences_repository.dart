import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  late final SharedPreferences _prefs;
  SharedPreferencesRepository._();

  static final SharedPreferencesRepository _instance = SharedPreferencesRepository._();

  static SharedPreferencesRepository get instance => _instance;

  factory SharedPreferencesRepository() => instance;

  List<String> get recentSearchWords => _prefs.getStringList('search_words') ?? [];

  bool get isFirst => _prefs.getBool('is_first') ?? true;

  bool get isFirstTimeLogin => _prefs.getBool('login') ?? true;

  bool get isFirstTimeCamera =>  _prefs.getBool('camera') ?? true;

  bool get isFirstTimeAlbum =>  _prefs.getBool('album') ?? true;

  bool get isFirstTimeLocation =>  _prefs.getBool('location') ?? true;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setRecentSearchWords(List<String> searchWords) {
    return _prefs.setStringList('search_words', searchWords);
  }

  Future<void> removeAllSearchWords() {
    return _prefs.remove('search_words');
  }

  Future<void> completeTutorial() {
    return _prefs.setBool('is_first', true);
  }

  Future<void> setLogin() {
    return _prefs.setBool('login', false);
  }

  Future<void> useCamera() {
    return _prefs.setBool('camera', false);
  }

  Future<void> useAlbum() {
    return _prefs.setBool('album', false);
  }

  Future<void> useLocation() {
    return _prefs.setBool('location', false);
  }
}