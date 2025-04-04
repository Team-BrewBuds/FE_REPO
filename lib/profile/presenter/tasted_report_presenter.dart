import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/profile/model/in_profile/bean_in_profile.dart';
import 'package:brew_buds/profile/model/in_profile/post_in_profile.dart';
import 'package:brew_buds/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:brew_buds/profile/model/saved_note/saved_note.dart';
import 'package:flutter/foundation.dart';

typedef ActivityInformationState = ({int tastingReportCount, int postCount, int savedNoteCount, int savedBeanCount});

typedef ActivityTypeState = ({List<String> activityTypeList, String currentActivityType});

typedef ActivityCalendarState = ({String title, DateTime focusedDay});

typedef ActivityListState = ({String currentActivityType, DefaultPage page});

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

final class TasteReportPresenter extends ChangeNotifier {
  final String nickname;
  final int _id;
  DefaultPage<TastingRecordInProfile> _tastingRecordsPage = DefaultPage.empty();
  DefaultPage<PostInProfile> _postsPage = DefaultPage.empty();
  DefaultPage<BeanInProfile> _beansPage = DefaultPage.empty();
  DefaultPage<SavedNote> _savedNotesPage = DefaultPage.empty();
  int _activityTypeIndex = 0;
  DateTime _focusedDay = DateTime.now();

  ActivityInformationState get activityInformationState => (
        tastingReportCount: 0,
        postCount: 0,
        savedNoteCount: 0,
        savedBeanCount: 0,
      );

  DefaultPage get _page {
    switch (ActivityType.values[_activityTypeIndex]) {
      case ActivityType.tastingRecord:
        return _tastingRecordsPage;
      case ActivityType.post:
        return _postsPage;
      case ActivityType.savedBean:
        return _beansPage;
      case ActivityType.savedNote:
        return _savedNotesPage;
    }
  }

  DateTime get focusedDay => _focusedDay;

  ActivityTypeState get activityTypeState => (
        activityTypeList: ActivityType.values.map((e) => e.toString()).toList(),
        currentActivityType: ActivityType.values[_activityTypeIndex].toString(),
      );

  ActivityListState get activityListState => (
        currentActivityType: ActivityType.values[_activityTypeIndex].toString(),
        page: _page,
      );

  TasteReportPresenter({
    required this.nickname,
    required int id,
  }) : _id = id;

  onChangeActivityType(int index) {
    _activityTypeIndex = index;
    notifyListeners();
  }

  onPageChange(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  goToday() {
    _focusedDay = DateTime.now();
    notifyListeners();
  }
}
