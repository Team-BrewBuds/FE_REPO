import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T> extends ChangeNotifier {
  List<T> get feeds;
  List<dynamic> get remandedUsers;
  Future<void> initState();
  Future<void> onRefresh();
  Future<void> fetchMoreData();
}