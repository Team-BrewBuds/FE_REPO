import 'dart:convert';

import 'package:brew_buds/data/api/notification_api.dart';
import 'package:brew_buds/data/dto/notification/notification_model_dto.dart';
import 'package:brew_buds/data/dto/notification/notification_setting_dto.dart';
import 'package:brew_buds/data/mapper/notification/notification_mapper.dart';
import 'package:brew_buds/data/mapper/notification/notification_setting_mapper.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/exception/login_exception.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/notification/notification_model.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationRepository {
  final NotificationApi _notificationApi = NotificationApi();
  final _deviceInfo = DeviceInfoPlugin();
  String _token = '';

  String get token => _token;

  NotificationRepository._();

  static final NotificationRepository _instance = NotificationRepository._();

  static NotificationRepository get instance => _instance;

  factory NotificationRepository() => instance;

  Future<void> init() async {
    try {
      await FirebaseMessaging.instance.getAPNSToken();
      final token = await FirebaseMessaging.instance.getToken().onError((error, stackTrace) => null);
      if (token != null && token.isNotEmpty) {
        _token = token;
      }
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        _token = event;
        registerToken(AccountRepository.instance.accessToken);
      });
    } catch (e) {
      return;
    }
  }

  Future<void> registerToken(String accessToken) async {
    if (_token.isNotEmpty) {
      try {
        await _notificationApi
            .registerDeviceToken(token: 'Bearer $accessToken', data: {'device_token': _token, 'device_type': 'ios'});
        final isGranted = PermissionRepository.instance.notification.isGranted;
        final data = await compute(
          (isGranted) => NotificationSettingDTO(
            like: isGranted,
            comment: isGranted,
            follow: isGranted,
            marketing: isGranted,
          ).toJson(),
          isGranted,
        );
        await _notificationApi.createNotificationSettings(data: data, token: 'Bearer $accessToken');
      } catch (e) {
        throw DeviceRegistrationException();
      }
    } else if (_token.isEmpty &&
        await _deviceInfo.iosInfo.then((info) => !info.isPhysicalDevice).onError((_, __) => false)) {
      return;
    } else {
      throw EmptyDeviceTokenException();
    }
  }

  Future<bool> deleteToken() async {
    try {
      if (_token.isNotEmpty) {
        return await _notificationApi
            .deleteDeviceToken(data: {'device_token': _token, 'device_type': 'ios'})
            .then((value) => true)
            .onError((error, stackTrace) => false);
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationSetting?> fetchSettings() async {
    final jsonString = await _notificationApi.fetchNotificationSettings();
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return NotificationSettingDTO.fromJson(json).toDomain();
        } catch (e) {
          return null;
        }
      },
      jsonString,
    );
  }

  Future<NotificationSetting?> updateSettings({required NotificationSetting notificationSetting}) async {
    final jsonString = await _notificationApi.updateNotificationSettings(
        data: await compute((setting) => setting.toDTO().toJson(), notificationSetting));
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return NotificationSettingDTO.fromJson(json).toDomain();
        } catch (e) {
          return null;
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<NotificationModel>> fetchNotificationPage({required int pageNo}) async {
    try {
      final json = jsonDecode(await _notificationApi.fetchNotifications(pageNo: pageNo)) as Map<String, dynamic>;
      return DefaultPage.fromJson(
        json,
        (jsonT) => NotificationModelDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
      );
    } catch (e) {
      return DefaultPage(count: 0, results: const [], hasNext: false);
    }
  }

  Future<void> deleteNotification({required int id}) {
    return _notificationApi.deleteNotification(id: id);
  }

  Future<void> deleteAllNotification() {
    return _notificationApi.deleteAllNotifications();
  }

  Future<void> readNotification({required int id}) {
    return _notificationApi.readNotification(id: id);
  }

  Future<bool> readAllNotification() {
    return _notificationApi.readAllNotifications().then((_) => true).onError((_, __) => false);
  }
}
