import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/domain/notification/notification_item_presenter.dart';

final class NotificationPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  final List<NotificationItemPresenter> _notificationList = List.empty(growable: true);
  bool _hasNext = true;
  int _pageNo = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get hasNext => _hasNext && _notificationList.isNotEmpty;

  List<NotificationItemPresenter> get notificationList => List.unmodifiable(_notificationList);

  bool get hasNotification => _notificationList.where((notification) => !notification.isRead).isNotEmpty;

  NotificationPresenter() {
    fetchMoreData();
  }

  Future<void> onRefresh() async {
    _notificationList.clear();
    _hasNext = true;
    _pageNo = 1;
    await fetchMoreData(isRefresh: true);
  }

  Future<void> fetchMoreData({bool isRefresh = false}) async {
    if (!_hasNext) return;

    if (!_isLoading) {
      _isLoading = true;
      if (!isRefresh) {
        notifyListeners();
      }

      final newPage = await _notificationRepository.fetchNotificationPage(pageNo: _pageNo);
      _notificationList.addAll(newPage.results.map((model) => NotificationItemPresenter(notificationModel: model)));
      _hasNext = newPage.hasNext;
      _pageNo++;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAll() async {
    final previous = List<NotificationItemPresenter>.from(_notificationList);
    _notificationList.clear();
    notifyListeners();

    try {
      await _notificationRepository.deleteAllNotification();
    } catch (e) {
      _notificationList.addAll(previous);
      notifyListeners();
    }
  }

  Future<void> deleteAt(int index) async {
    final removedNotification = _notificationList.removeAt(index);
    notifyListeners();

    try {
      await _notificationRepository.deleteNotification(id: removedNotification.id);
    } catch (e) {
      _notificationList.insert(index, removedNotification);
      notifyListeners();
      rethrow;
    }
  }
}
