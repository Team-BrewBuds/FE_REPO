import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/post.dart';
import 'package:brew_buds/model/user.dart';

final class HomePostPresenter extends HomeViewPresenter<Post> {
  final List<Post> _posts;
  final List<User> _remandedUsers;

  HomePostPresenter({
    required List<Post> posts,
    required List<User> remandedUsers,
  })  : _posts = posts,
        _remandedUsers = remandedUsers;

  @override
  List<Post> get feeds => _posts;

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