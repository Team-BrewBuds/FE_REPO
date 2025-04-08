import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationSettingPresenter extends Presenter {
  final NotificationRepository _notificationRepository = NotificationRepository.instance;
  NotificationSetting? _notificationSetting;
  late bool _isGranted;
  bool _isLoading = false;

  NotificationSetting? get notificationSetting => _notificationSetting;

  bool get isLoading => _isLoading;

  initState() async {
    _isLoading = true;
    notifyListeners();

    _isGranted = PermissionRepository.instance.notification.isGranted;
    if (_isGranted) {
      await _fetchSettings();
    }

    _isLoading = false;
    notifyListeners();
  }

  _fetchSettings() async {
    final setting = await _notificationRepository.fetchSettings();
    _notificationSetting = setting;
  }

  requestPermission() async {
    _isLoading = true;
    notifyListeners();

    await PermissionRepository.instance.requestNotification();
    final newState = PermissionRepository.instance.notification.isGranted;

    if (_isGranted != newState) {
      _isGranted = newState;
      await _fetchSettings();
    }

    _isLoading = false;
    notifyListeners();
  }

  onChangeLikeNotifyState() async {
    final setting = _notificationSetting;
    if (setting != null) {
      _isLoading = true;
      notifyListeners();

      final newSetting = await _notificationRepository.updateSettings(
        notificationSetting: setting.copyWith(like: !setting.like),
      );

      if (newSetting != null) {
        _notificationSetting = newSetting;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  onChangeCommentNotifyState() async {
    final setting = _notificationSetting;
    if (setting != null) {
      _isLoading = true;
      notifyListeners();

      final newSetting = await _notificationRepository.updateSettings(
        notificationSetting: setting.copyWith(comment: !setting.comment),
      );

      if (newSetting != null) {
        _notificationSetting = newSetting;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  onChangeFollowNotifyState() async {
    final setting = _notificationSetting;
    if (setting != null) {
      _isLoading = true;
      notifyListeners();

      final newSetting = await _notificationRepository.updateSettings(
        notificationSetting: setting.copyWith(follow: !setting.follow),
      );

      if (newSetting != null) {
        _notificationSetting = newSetting;
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  onChangeMarketingNotifyState() async {
    final setting = _notificationSetting;
    if (setting != null) {
      _isLoading = true;
      notifyListeners();

      final newSetting = await _notificationRepository.updateSettings(
        notificationSetting: setting.copyWith(marketing: !setting.marketing),
      );

      if (newSetting != null) {
        _notificationSetting = newSetting;
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
