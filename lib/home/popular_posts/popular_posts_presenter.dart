import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/post.dart';
import 'package:brew_buds/model/user.dart';

final class PopularPostsPresenter extends HomeViewPresenter<Post> {
  final List<Post> _popularPosts;

  PopularPostsPresenter({
    required List<Post> popularPosts,
  }) : _popularPosts = popularPosts;

  @override
  List<Post> get feeds => _popularPosts;

  @override
  List<User> get remandedUsers => List.empty();

  @override
  Future<void> initState() {
    return Future.value();
  }

  @override
  Future<void> onRefresh() {
    return Future.value();
  }

  @override
  Future<void> fetchMoreData() {
    return Future.value();
  }
}
