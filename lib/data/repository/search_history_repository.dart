import 'package:shared_preferences/shared_preferences.dart';

final class SearchHistoryRepository {
  SearchHistoryRepository._();

  static final SearchHistoryRepository _instance = SearchHistoryRepository._();

  static SearchHistoryRepository get instance => _instance;

  factory SearchHistoryRepository() => instance;

  static const _key = 'recent_searches';

  Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> setSearchHistory(List<String> searchHistory) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_key, searchHistory);
  }

  Future<void> addSearch(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.remove(keyword); // 중복 제거
    history.insert(0, keyword); // 맨 앞에 추가

    await prefs.setStringList(_key, history);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
