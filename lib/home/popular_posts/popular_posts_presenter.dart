import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/post_in_feed.dart';

final class PopularPostsPresenter extends HomeViewPresenter<PostInFeed> {
  final List<PostInFeed> _popularPosts;

  PopularPostsPresenter({
    required List<PostInFeed> popularPosts,
  }) : _popularPosts = popularPosts;

  @override
  List<PostInFeed> get feeds => _popularPosts;

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
