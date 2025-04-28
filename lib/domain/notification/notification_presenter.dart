import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/model/notification/notification_model.dart';

final class NotificationPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  final List<NotificationModel> _notificationList = List.empty(growable: true);
  bool _hasNext = true;
  int _pageNo = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasNext => _hasNext && _notificationList.isNotEmpty;

  List<NotificationModel> get notificationList => List.unmodifiable(_notificationList);

  NotificationPresenter() {
    fetchMoreData();
  }

  onRefresh() {
    _notificationList.clear();
    _hasNext = true;
    _pageNo = 1;
    fetchMoreData();
  }

  fetchMoreData() async {
    if (!_hasNext) return;

    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();

      final newPage = await _notificationRepository.fetchNotificationPage(pageNo: _pageNo);
      _notificationList.addAll(newPage.results);
      _hasNext = newPage.hasNext;
      _pageNo++;
      _isLoading = false;
      notifyListeners();
    }
  }

  readAt(int index) async {
    final notification = _notificationList[index];
    _notificationList[index] = notification.copyWith(isRead: true);
    notifyListeners();

    try {
      await _notificationRepository.readNotification(id: notification.id);
    } catch (e) {
      _notificationList[index] = notification.copyWith();
      notifyListeners();
    }
  }

  Future<void> deleteAll() async {
    final previous = List<NotificationModel>.from(_notificationList);
    _notificationList.clear();
    notifyListeners();

    try {
      await _notificationRepository.deleteAllNotification();
    } catch (e) {
      _notificationList.addAll(previous);
      notifyListeners();
    }
  }

  deleteAt(int index) async {
    final removedNotification = _notificationList.removeAt(index);
    notifyListeners();

    try {
      await _notificationRepository.deleteNotification(id: removedNotification.id);
    } catch (e) {
      _notificationList.insert(index, removedNotification);
      notifyListeners();
    }
  }
}
