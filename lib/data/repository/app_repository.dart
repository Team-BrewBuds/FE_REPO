import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:notification_center/notification_center.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class AppRepository {
  AppRepository._();

  static final AppRepository _instance = AppRepository._();

  static AppRepository get instance => _instance;

  factory AppRepository() => instance;

  bool _isUpdateRequired = false;

  bool get isUpdateRequired => _isUpdateRequired;

  Future<void> checkUpdateRequired() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    final minVersionStr = remoteConfig.getString('min_required_version');
    final minVersion = Version.parse(minVersionStr);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(packageInfo.version);

    _isUpdateRequired = currentVersion < minVersion;
    if (_isUpdateRequired) {
      NotificationCenter().notify('need_update');
    }
  }

  Future<String> fetchAppStoreUrl() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    return remoteConfig.getString('app_store_url');
  }
}
