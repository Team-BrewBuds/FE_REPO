import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/exception/notification_exeption.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationSettingPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  NotificationSetting? _notificationSetting;
  bool _isGranted;
  bool _isLoading = false;

  NotificationSettingPresenter({
    required bool isGranted,
  }) : _isGranted = isGranted {
    _fetchSettings();
  }

  bool get isGranted => _isGranted;

  NotificationSetting? get notificationSetting => _notificationSetting;

  bool get isLoading => _isLoading;

  _fetchSettings() async {
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
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final newState = (await PermissionRepository.instance.requestNotification()).isGranted;

    if (_isGranted != newState) {
      _isGranted = newState;
      if (_isGranted) {
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
