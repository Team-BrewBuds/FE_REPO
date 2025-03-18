import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:brew_buds/model/noted/noted_object.dart';
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
  DefaultPage<TastedRecordInProfile> _tastingRecordsPage = DefaultPage.initState();
  DefaultPage<PostInProfile> _postsPage = DefaultPage.initState();
  DefaultPage<BeanInProfile> _beansPage = DefaultPage.initState();
  DefaultPage<NotedObject> _savedNotesPage = DefaultPage.initState();
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
