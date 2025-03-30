import 'package:brew_buds/data/api/notification_api.dart';
import 'package:brew_buds/data/mapper/notification/notification_setting_mapper.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

final class NotificationRepository {
  final NotificationApi _notificationApi = NotificationApi();
  String _token = '';

  String get token => _token;

  NotificationRepository._();

  static final NotificationRepository _instance = NotificationRepository._();

  static NotificationRepository get instance => _instance;

  factory NotificationRepository() => instance;

  Future<void> init() async {
    await FirebaseMessaging.instance.getAPNSToken();
    final token = await FirebaseMessaging.instance.getToken().onError((error, stackTrace) => null);
    if (token != null && token.isNotEmpty) {
      _token = token;
    }

    print(_token);

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      _token = event;
      registerToken(AccountRepository.instance.accessToken);
    });
  }

  Future<bool> registerToken(String accessToken) async {
    if (_token.isNotEmpty) {
      return await _notificationApi
          .registerDeviceToken(token: 'Bearer $accessToken', data: {'device_token': _token, 'device_type': 'ios'})
          .then((value) => true)
          .onError((error, stackTrace) {
            return false;
          });
    } else {
      return false;
    }
  }

  Future<bool> deleteToken() async {
    if (_token.isNotEmpty) {
      return await _notificationApi
          .deleteDeviceToken(data: {'device_token': _token, 'device_type': 'ios'})
          .then((value) => true)
          .onError((error, stackTrace) => false);
    } else {
      return false;
    }
  }

  Future<NotificationSetting?> fetchSettings() {
    return _notificationApi
        .fetchNotificationSettings()
        .then((value) => Future<NotificationSetting?>.value(value.toDomain()))
        .onError((error, stackTrace) => null);
  }

  Future<bool> createSettings({required NotificationSetting notificationSetting}) {
    return _notificationApi
        .createNotificationSettings(data: notificationSetting.toDTO())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Future<bool> updateSettings({required NotificationSetting notificationSetting}) {
    return _notificationApi
        .updateNotificationSettings(data: notificationSetting.toDTO())
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }
}
