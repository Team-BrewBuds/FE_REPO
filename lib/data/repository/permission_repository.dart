import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  PermissionRepository._();

  static final PermissionRepository _instance = PermissionRepository._();

  static PermissionRepository get instance => _instance;

  factory PermissionRepository() => instance;

  late PermissionStatus camera;
  late PermissionStatus photos;
  late PermissionStatus location;
  late PermissionStatus notification;

  Future<void> initPermission() async {
    camera = await Permission.camera.request();
    photos = await Permission.photos.request();
    location = await Permission.location.request();
    notification = await Permission.notification.request();
  }

  Future<void> requestNotification() async {
    notification = await Permission.notification.request();
  }
}
