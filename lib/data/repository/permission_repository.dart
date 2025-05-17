import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  PermissionRepository._();

  static final PermissionRepository _instance = PermissionRepository._();

  static PermissionRepository get instance => _instance;

  factory PermissionRepository() => instance;

  Map<Permission, PermissionStatus> _statuses = {};

  Future<PermissionStatus> get camera async {
    final status = _statuses[Permission.camera];
    if (status != null) {
      return status;
    } else {
      final requestStatus = await Permission.camera.request();
      _statuses[Permission.camera] = requestStatus;
      return requestStatus;
    }
  }

  Future<PermissionStatus> get photos async {
    final status = _statuses[Permission.photos];
    if (status != null) {
      return status;
    } else {
      final requestStatus = await Permission.photos.request();
      _statuses[Permission.photos] = requestStatus;
      return requestStatus;
    }
  }

  Future<PermissionStatus> get location async {
    final status = _statuses[Permission.location];
    if (status != null) {
      return status;
    } else {
      final requestStatus = await Permission.location.request();
      _statuses[Permission.location] = requestStatus;
      return requestStatus;
    }
  }

  Future<PermissionStatus> get notification async {
    final status = _statuses[Permission.notification];
    if (status != null) {
      return status;
    } else {
      final requestStatus = await Permission.notification.request();
      _statuses[Permission.notification] = requestStatus;
      return requestStatus;
    }
  }

  Future<void> initPermission() async {
    _statuses = await [
      Permission.notification,
      Permission.camera,
      Permission.photos,
      Permission.location,
    ].request();
  }

  Future<PermissionStatus> requestNotificationPermission() async {
    final newPermissionStatus = await Permission.notification.request();
    _statuses[Permission.notification] = newPermissionStatus;
    return newPermissionStatus;
  }
}
