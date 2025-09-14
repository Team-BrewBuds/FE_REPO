import 'dart:io';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/model/events/need_update_event.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class AppRepository {
  AppRepository._();

  static final AppRepository _instance = AppRepository._();

  static AppRepository get instance => _instance;

  factory AppRepository() => instance;

  Future<void> checkUpdateRequired() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    final minVersionStr = Platform.isIOS
        ? remoteConfig.getString('min_required_version')
        : remoteConfig.getString('min_required_version_aos');
    final minVersion = Version.parse(minVersionStr);

    print(minVersion.toString());

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(packageInfo.version);

    print(currentVersion.toString());

    if (currentVersion < minVersion) {
      print("<");
      EventBus.instance.fire(NeedUpdateEvent(id: await fetchAppId()));
    }
  }

  Future<String> fetchAppId() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    return remoteConfig.getString('ios_app_id');
  }

  Future<String> fetchStoreURL() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    return Platform.isIOS
        ? remoteConfig.getString('app_store_url')
        : remoteConfig.getString('play_store_url');
  }
}
