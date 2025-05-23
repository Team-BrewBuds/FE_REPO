import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  late final SharedPreferences _prefs;

  SharedPreferencesRepository._();

  static final SharedPreferencesRepository _instance = SharedPreferencesRepository._();

  static SharedPreferencesRepository get instance => _instance;

  factory SharedPreferencesRepository() => instance;

  List<String> get recentSearchWords => _prefs.getStringList('search_words') ?? [];

  bool get isFirst => _prefs.getBool('is_first') ?? true;

  bool get isCompletePermission => _prefs.getBool('permission') ?? false;

  bool get isFirstTimeCamera => _prefs.getBool('camera') ?? true;

  bool get isFirstTimeAlbum => _prefs.getBool('album') ?? true;

  bool get isFirstTimeLocation => _prefs.getBool('location') ?? true;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setRecentSearchWords(List<String> searchWords) {
    return _prefs.setStringList('search_words', searchWords);
  }

  Future<void> removeAllSearchWords() {
    return _prefs.remove('search_words');
  }

  Future<void> completeTutorial() {
    return _prefs.setBool('is_first', false);
  }

  Future<void> completePermission() {
    return _prefs.setBool('permission', true);
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
