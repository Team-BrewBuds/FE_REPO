import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feed.dart';
import 'package:brew_buds/model/user.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<Feed> _feeds;
  final List<User> _remandedUsers;

  HomeAllPresenter({
    required List<Feed> feeds,
    required List<User> remandedUsers,
  })  : _feeds = feeds,
        _remandedUsers = remandedUsers;

  @override
  List<Feed> get feeds => _feeds;

  @override
  List<User> get remandedUsers => _remandedUsers;

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