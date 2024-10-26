import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T> extends ChangeNotifier {
  List<T> get feeds;
  Future<void> initState();
  Future<void> onRefresh();
  Future<void> fetchMoreData();
}