import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationSettingPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  late NotificationSetting _notificationSetting;
  late bool _isGranted;
  bool _hasSetting = false;
  bool _isLoading = false;

  initState() {
    _isGranted = PermissionRepository.instance.notification.isGranted;
    if (_isGranted) {
      _fetchSettings();
    }
    notifyListeners();
  }

  _fetchSettings() async {
    _isLoading = true;
    notifyListeners();

    final setting = await _notificationRepository.fetchSettings();
    if (setting != null) {
      _notificationSetting = setting;
      _hasSetting = true;
    } else {
      _notificationSetting = const NotificationSetting(like: true, comment: true, follow: true, marketing: true);
      await _notificationRepository.createSettings(notificationSetting: _notificationSetting);
    }

    _isLoading = false;
    notifyListeners();
  }

  requestPermission() async {
    _isLoading = true;
    notifyListeners();

    await PermissionRepository.instance.requestNotification();
    final newState = PermissionRepository.instance.notification.isGranted;

    if (_isGranted != newState) {
      _isGranted = newState;
      _fetchSettings();
    }

    _isLoading = false;
    notifyListeners();
  }

  onChangeLikeNotifyState() async {
    _isLoading = true;
    notifyListeners();

    _notificationSetting = _notificationSetting.copyWith(like: !_notificationSetting.like);

    _isLoading = false;
    notifyListeners();
  }

  onChangeCommentNotifyState() async {
    _isLoading = true;
    notifyListeners();



    _isLoading = false;
    notifyListeners();
  }

  onChangeFollowNotifyState() async {
    _isLoading = true;
    notifyListeners();



    _isLoading = false;
    notifyListeners();
  }

  onChangeMarketingNotifyState() async {
    _isLoading = true;
    notifyListeners();



    _isLoading = false;
    notifyListeners();
  }
}