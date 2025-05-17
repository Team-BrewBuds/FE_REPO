import 'dart:async';
import 'dart:convert';

import 'package:brew_buds/data/api/notification_api.dart';
import 'package:brew_buds/data/dto/notification/notification_model_dto.dart';
import 'package:brew_buds/data/dto/notification/notification_setting_dto.dart';
import 'package:brew_buds/data/mapper/notification/notification_mapper.dart';
import 'package:brew_buds/data/mapper/notification/notification_setting_mapper.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/exception/login_exception.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/notification/notification_model.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

final class NotificationRepository {
  final NotificationApi _notificationApi = NotificationApi();

  NotificationRepository._();

  static final NotificationRepository _instance = NotificationRepository._();

  static NotificationRepository get instance => _instance;

  factory NotificationRepository() => instance;

  Future<void> init() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> registerToken() async {
    if ((await PermissionRepository.instance.notification).isGranted) return;

    try {
      await FirebaseMessaging.instance.getAPNSToken();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await _notificationApi.registerDeviceToken(data: {'device_token': token, 'device_type': 'ios'});
      } else {
        throw DeviceRegistrationException();
      }
    } catch (e) {
      throw DeviceRegistrationException();
    }
  }

  Future<void> deleteToken() async {
    if ((await PermissionRepository.instance.notification).isGranted) return;

    try {
      await FirebaseMessaging.instance.getAPNSToken();
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await _notificationApi.deleteDeviceToken(
          data: {'device_token': token, 'device_type': 'ios'},
        );
      }
    } catch (e) {
      return Future.value();
    }
  }

  Future<NotificationSetting> createdSettings() async {
    try {
      final data = const NotificationSettingDTO(
        like: true,
        comment: true,
        follow: true,
        marketing: true,
      ).toJson();
      final json = jsonDecode(await _notificationApi.createNotificationSettings(data: data)) as Map<String, dynamic>;
      return NotificationSettingDTO.fromJson(json).toDomain();
    } catch (_) {
      rethrow;
    }
  }

  Future<NotificationSetting> fetchSettings() async {
    try {
      final json = jsonDecode(await _notificationApi.fetchNotificationSettings()) as Map<String, dynamic>;
      return NotificationSettingDTO.fromJson(json).toDomain();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return await createdSettings();
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<NotificationSetting> updateSettings({required NotificationSetting notificationSetting}) async {
    try {
      final json = await _notificationApi.updateNotificationSettings(
        data: notificationSetting.toDTO().toJson(),
      ) as Map<String, dynamic>;
      return NotificationSettingDTO.fromJson(json).toDomain();
    } catch (_) {
      rethrow;
    }
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
