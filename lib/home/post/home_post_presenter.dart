import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/post_in_feed.dart';

final class HomePostPresenter extends HomeViewPresenter<PostInFeed> {
  final List<PostInFeed> _posts;

  HomePostPresenter({
    required List<PostInFeed> posts,
  })  : _posts = posts;

  @override
  List<PostInFeed> get feeds => _posts;

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