import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/tasting_record.dart';
import 'package:brew_buds/model/user.dart';

final class HomeTastingRecordPresenter extends HomeViewPresenter<TastingRecord> {
  final List<TastingRecord> _tastingRecords;
  final List<User> _remandedUsers;

  HomeTastingRecordPresenter({
    required List<TastingRecord> tastingRecords,
    required List<User> remandedUsers,
  })  : _tastingRecords = tastingRecords,
        _remandedUsers = remandedUsers;

  @override
  List<TastingRecord> get feeds => _tastingRecords;

  @override
  List<User> get remandedUsers => _remandedUsers;

  @override
  Future<void> fetchMoreData() {
    throw UnimplementedError();
  }

  @override
  Future<void> initState() {
    throw UnimplementedError();
  }

  @override
  Future<void> onRefresh() {
    throw UnimplementedError();
  }
}
