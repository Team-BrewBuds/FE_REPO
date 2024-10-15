import 'package:brew_buds/model/user.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T> extends ChangeNotifier {
  List<T> get feeds;
  List<User> get remandedUsers;
  Future<void> initState();
  Future<void> onRefresh();
  Future<void> fetchMoreData();
}