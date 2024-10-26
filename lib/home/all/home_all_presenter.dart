import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feed.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<Feed> _feeds;

  HomeAllPresenter({
    required List<Feed> feeds,
  })  : _feeds = feeds;

  @override
  List<Feed> get feeds => _feeds;

  @override
  Future<void> fetchMoreData() {
    // TODO: implement fetchMoreData
    throw UnimplementedError();
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    throw UnimplementedError();
  }

  @override
  Future<void> onRefresh() {
    // TODO: implement onRefresh
    throw UnimplementedError();
  }
}