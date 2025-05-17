import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/exception/notification_exeption.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationSettingPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  final PermissionRepository _permissionRepository = PermissionRepository.instance;
  NotificationSetting? _notificationSetting;
  bool _isLoading = false;

  NotificationSettingPresenter() {
    _fetchSettings();
  }

  Future<PermissionStatus> get notificationStatus => _permissionRepository.notification;

  NotificationSetting? get notificationSetting => _notificationSetting;

  bool get isLoading => _isLoading;

  _fetchSettings() async {
    final status = await _permissionRepository.notification;

    if (!status.isGranted) return;

    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final setting = await _notificationRepository.fetchSettings();
      _notificationSetting = setting;
    } catch (_) {
      _notificationSetting = null;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  requestPermission() async {
    final previousStatus = await _permissionRepository.notification;
    final newState = await _permissionRepository.requestNotificationPermission();

    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    if (previousStatus != newState) {
      if (newState.isGranted) {
        await _notificationRepository.registerToken();
        await _fetchSettings();
      } else {
        await _notificationRepository.deleteToken();
        _notificationSetting = null;
      }
    }

    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onChangeLikeNotifyState() async {
    final status = await _permissionRepository.notification;

    if (!status.isGranted) return;

    final setting = _notificationSetting;
    if (setting != null) {
      _notificationSetting = setting.copyWith(like: !setting.like);
      notifyListeners();

      try {
        await _notificationRepository.updateSettings(
          notificationSetting: setting.copyWith(like: !setting.like),
        );
      } catch (e) {
        _notificationSetting = setting.copyWith(like: setting.like);
        notifyListeners();
        throw const NotificationUpdateException();
      }
    }
  }

  Future<void> onChangeCommentNotifyState() async {
    final status = await _permissionRepository.notification;

    if (!status.isGranted) return;

    final setting = _notificationSetting;
    if (setting != null) {
      _notificationSetting = setting.copyWith(comment: !setting.comment);
      notifyListeners();

      try {
        await _notificationRepository.updateSettings(
          notificationSetting: setting.copyWith(comment: !setting.comment),
        );
      } catch (e) {
        _notificationSetting = setting.copyWith(comment: setting.comment);
        notifyListeners();
        throw const NotificationUpdateException();
      }
    }
  }

  Future<void> onChangeFollowNotifyState() async {
    final status = await _permissionRepository.notification;

    if (!status.isGranted) return;

    final setting = _notificationSetting;
    if (setting != null) {
      _notificationSetting = setting.copyWith(follow: !setting.follow);
      notifyListeners();

      try {
        await _notificationRepository.updateSettings(
          notificationSetting: setting.copyWith(follow: !setting.follow),
        );
      } catch (e) {
        _notificationSetting = setting.copyWith(follow: setting.follow);
        notifyListeners();
        throw const NotificationUpdateException();
      }
    }
  }

  Future<void> onChangeMarketingNotifyState() async {
    final status = await _permissionRepository.notification;

    if (!status.isGranted) return;

    final setting = _notificationSetting;
    if (setting != null) {
      _notificationSetting = setting.copyWith(marketing: !setting.marketing);
      notifyListeners();

      try {
        await _notificationRepository.updateSettings(
          notificationSetting: setting.copyWith(marketing: !setting.marketing),
        );
      } catch (e) {
        _notificationSetting = setting.copyWith(marketing: setting.marketing);
        notifyListeners();
        throw const NotificationUpdateException();
      }
    }
  }
}
