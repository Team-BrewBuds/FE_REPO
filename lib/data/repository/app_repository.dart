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

    final minVersionStr = remoteConfig.getString('min_required_version');
    final minVersion = Version.parse(minVersionStr);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(packageInfo.version);

    if (currentVersion < minVersion) {
      EventBus.instance.fire(NeedUpdateEvent(id: await fetchAppId()));
    }
  }

  Future<String> fetchAppId() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    return remoteConfig.getString('ios_app_id');
  }
}
