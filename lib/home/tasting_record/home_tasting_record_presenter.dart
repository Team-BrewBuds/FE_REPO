import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/tasting_record_in_feed.dart';

final class HomeTastingRecordPresenter extends HomeViewPresenter<TastingRecordInFeed> {
  final List<TastingRecordInFeed> _tastingRecords;

  HomeTastingRecordPresenter({
    required List<TastingRecordInFeed> tastingRecords,
  })  : _tastingRecords = tastingRecords;

  @override
  List<TastingRecordInFeed> get feeds => _tastingRecords;

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
