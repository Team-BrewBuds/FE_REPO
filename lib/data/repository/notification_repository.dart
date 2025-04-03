import 'dart:convert';

import 'package:brew_buds/data/api/notification_api.dart';
import 'package:brew_buds/data/dto/notification/notification_setting_dto.dart';
import 'package:brew_buds/data/mapper/notification/notification_setting_mapper.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

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

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      _token = event;
      registerToken(AccountRepository.instance.accessToken);
    });
  }

  Future<bool> registerToken(String accessToken) async {
    if (_token.isNotEmpty) {
      try {
        await _notificationApi
            .registerDeviceToken(token: 'Bearer $accessToken', data: {'device_token': _token, 'device_type': 'ios'});
        if (!await _notificationApi.fetchNotificationSettings().then((_) => true).onError((_, __) => false)) {
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
          await _notificationApi.createNotificationSettings(data: data);
        }
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> deleteToken() async {
    if (_token.isNotEmpty) {
      return await _notificationApi
          .deleteDeviceToken(data: {'device_token': _token, 'device_type': 'ios'})
          .then((value) => true)
          .onError((error, stackTrace) => false);
    } else {
      return true;
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

  Future<bool> createSettings({required NotificationSetting notificationSetting}) async {
    return _notificationApi
        .createNotificationSettings(data: await compute((setting) => setting.toDTO().toJson(), notificationSetting))
        .then((value) => true)
        .onError((error, stackTrace) => false);
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
}
