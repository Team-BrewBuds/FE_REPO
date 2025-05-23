import 'dart:math';

import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:brew_buds/core/analytics_manager.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/taste_report_repository.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/taste_report/activity_item.dart';
import 'package:brew_buds/model/taste_report/activity_summary.dart';
import 'package:brew_buds/model/taste_report/rating_distribution.dart';
import 'package:brew_buds/model/taste_report/top_country.dart';

typedef ActivityInformationState = ({int tastingReportCount, int postCount, int savedNoteCount, int savedBeanCount});

typedef ActivityTypeState = ({List<String> activityTypeList, String currentActivityType});

typedef ActivityCalendarState = ({Map<String, int> activityCount, DateTime focusedDay, DateTime selectedDay});

typedef ActivityListState = ({String currentActivityType, List<ActivityItem> items});

enum ActivityType {
  tastingRecord,
  post,
  savedBean,
  savedNote;

  @override
  String toString() => switch (this) {
        ActivityType.tastingRecord => '시음기록',
        ActivityType.post => '게시글',
        ActivityType.savedBean => '찜한 원두',
        ActivityType.savedNote => '저장한 노트',
      };
}

final class TasteReportPresenter extends Presenter {
  final TasteReportRepository _tastedReportRepository = TasteReportRepository.instance;
  final String nickname;
  final int _id;
  bool _isLoading = false;
  ActivitySummary? _activitySummary;
  RatingDistribution? _ratingDistribution;
  List<TopFlavor> _topFlavors = [];
  List<TopCountry> _topCounty = [];
  Map<String, List<ActivityItem>> _activityItems = {};
  int _activityTypeIndex = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool get isLoading => _isLoading;

  ActivityInformationState get activityInformationState => (
        tastingReportCount: _activitySummary?.tastedRecordCount ?? 0,
        postCount: _activitySummary?.postCount ?? 0,
        savedNoteCount: _activitySummary?.savedNoteCount ?? 0,
        savedBeanCount: _activitySummary?.savedBeanCount ?? 0,
      );

  DateTime get focusedDay => _focusedDay;

  ActivityTypeState get activityTypeState => (
        activityTypeList: ActivityType.values.map((e) => e.toString()).toList(),
        currentActivityType: ActivityType.values[_activityTypeIndex].toString(),
      );

  ActivityCalendarState get activityCalendarState => (
        activityCount: _activityItems.map((key, value) => MapEntry(key, value.length)),
        focusedDay: _focusedDay,
        selectedDay: _selectedDay,
      );

  String get currentActivityType => ActivityType.values[_activityTypeIndex].toString();

  int get itemsLength => (_activityItems[_selectedDay.toDefaultString()] ?? []).length;

  List<ActivityItem> get items => List.unmodifiable(_activityItems[_selectedDay.toDefaultString()] ?? []);

  RatingDistribution? get ratingDistribution => _ratingDistribution;

  List<TopFlavor> get topFlavor => _topFlavors.sublist(0, min(_topFlavors.length, 5));

  List<TopCountry> get topCountry => _topCounty.sublist(0, min(_topCounty.length, 5));

  TasteReportPresenter({
    required this.nickname,
    required int id,
  }) : _id = id;

  initState() async {
    _isLoading = true;
    notifyListeners();

    if (_id == AccountRepository.instance.id) {
      AnalyticsManager.instance.logScreen(screenName: 'profiles_a_taste_report');
    } else {
      AnalyticsManager.instance.logScreen(screenName: 'profiles_b_taste_report');
    }

    await Future.wait([
      fetchActivitySummary(),
      fetchActivity(),
      fetchRatingDistribution(),
      fetchTopFlavors(),
      fetchTopCountry(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchActivitySummary() async {
    _activitySummary = await _tastedReportRepository.fetchActivitySummary(id: _id);
  }

  Future<void> fetchRatingDistribution() async {
    _ratingDistribution = await _tastedReportRepository.fetchRatingDistribution(id: _id);
  }

  Future<void> fetchTopFlavors() async {
    _topFlavors = List.from(await _tastedReportRepository.fetchFavoriteFlavor(id: _id));
  }

  Future<void> fetchTopCountry() async {
    _topCounty = List.from(await _tastedReportRepository.fetchPreferredCountry(id: _id));
  }

  Future<void> fetchActivity() async {
    if (_activityTypeIndex == 0) {
      _activityItems = await _tastedReportRepository.fetchTastedRecordActivityCalendar(
        id: _id,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );
    } else if (_activityTypeIndex == 1) {
      _activityItems = await _tastedReportRepository.fetchPostActivityCalendar(
        id: _id,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );
    } else if (_activityTypeIndex == 2) {
      _activityItems = await _tastedReportRepository.fetchSavedBeanActivityCalendar(
        id: _id,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );
    } else {
      _activityItems = await _tastedReportRepository.fetchSavedNoteActivityCalendar(
        id: _id,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );
    }
    notifyListeners();
  }

  moveNextMonth() {
    _focusedDay = _calcNextMonth(_focusedDay);
    notifyListeners();
  }

  movePreviousMonth() {
    _focusedDay = _calcPreviousMonth(_focusedDay);
    notifyListeners();
  }

  onChangeActivityType(int index) {
    _activityTypeIndex = index;
    _activityItems = {};
    notifyListeners();
    fetchActivity();
  }

  onSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  onPageChange(DateTime day) {
    final firstDay = DateTime(day.year, day.month);
    _focusedDay = firstDay;
    fetchActivity();
    notifyListeners();
  }

  goToday() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime(_selectedDay.year, _selectedDay.month);
    fetchActivity();
    notifyListeners();
  }

  DateTime _calcNextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1);
    } else {
      return DateTime(date.year, date.month + 1);
    }
  }

  DateTime _calcPreviousMonth(DateTime date) {
    if (date.month == 1) {
      return DateTime(date.year - 1, 12);
    } else {
      return DateTime(date.year, date.month - 1);
    }
  }

  String getImagePath() {
    final tastedRecordCount = _activitySummary?.tastedRecordCount ?? 0;

    if (tastedRecordCount >= 5) {
      final postCount = _activitySummary?.postCount ?? 0;
      final savedBeanCount = _activitySummary?.savedBeanCount ?? 0;
      final savedNoteCount = _activitySummary?.savedNoteCount ?? 0;
      if (postCount >= 5 && savedBeanCount >= 5 && savedNoteCount >= 5) {
        return 'assets/images/taste_report/taste_explorer.png';
      } else {
        return 'assets/images/taste_report/taste_novice.png';
      }
    } else {
      return 'assets/images/taste_report/new_buddy.png';
    }
  }
}
