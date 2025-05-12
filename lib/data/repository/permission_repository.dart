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
    notification = await Permission.notification.request();
    camera = await Permission.camera.request();
    photos = await Permission.photos.request();
    location = await Permission.location.request();
  }

  Future<void> requestPhotos() async {
    photos = await Permission.photos.request();
  }

  Future<PermissionStatus> requestNotification() async {
    notification = await Permission.notification.request();
    return notification;
  }
}
