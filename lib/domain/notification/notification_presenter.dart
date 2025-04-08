import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/notification/notification_model.dart';

final class NotificationPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  DefaultPage<NotificationModel> _page = DefaultPage.initState();
  int _pageNo = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<NotificationModel> get notificationList => _page.results;

  initState() {
    fetchMoreData();
  }

  onRefresh() {
    _pageNo = 1;
    fetchMoreData();
  }

  fetchMoreData() async {
    if (!_page.hasNext) return;

    _isLoading = true;
    notifyListeners();

    final newPage = await _notificationRepository.fetchNotificationPage(pageNo: _pageNo);
    _page = newPage.copyWith(results: _page.results + newPage.results);
    _pageNo++;
    _isLoading = false;
    notifyListeners();
  }

  readAll() async {
    _isLoading = true;
    notifyListeners();

    final result = await _notificationRepository.readAllNotification();
    if (result) {
      _page = _page.copyWith(results: notificationList.map((e) => e.copyWith(isRead: true)).toList());
    }

    _isLoading = false;
    notifyListeners();
  }

  readAt(int index) async {
    _isLoading = true;
    notifyListeners();

    final targetNotification = notificationList[index];
    final previousList = List<NotificationModel>.from(notificationList);
    final result = await _notificationRepository.readNotification(id: targetNotification.id);
    if (result) {
      previousList[index] = targetNotification.copyWith(isRead: true);
      _page = _page.copyWith(results: previousList);
    }

    _isLoading = false;
    notifyListeners();
  }

  deleteAll() async {
    _isLoading = true;
    notifyListeners();

    final result = await _notificationRepository.deleteAllNotification();
    if (result) {
      _page = _page.copyWith(results: List.empty(growable: true));
    }

    _isLoading = false;
    notifyListeners();
  }

  deleteAt(int index) async {
    _isLoading = true;
    notifyListeners();

    final result = await _notificationRepository.deleteNotification(id: notificationList[index].id);
    if (result) {
      _page = _page.copyWith(results: _page.results..removeAt(index));
    }

    _isLoading = false;
    notifyListeners();
  }
}
