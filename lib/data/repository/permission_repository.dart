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
    await _requestAllPermission();
  }

  Future<void> _requestAllPermission() async {
    Future.delayed(const Duration(milliseconds: 500));
    notification = await Permission.notification.request();
    Future.delayed(const Duration(milliseconds: 500));
    location = await Permission.location.request();
    Future.delayed(const Duration(milliseconds: 500));
    camera = await Permission.camera.request();
    Future.delayed(const Duration(milliseconds: 500));
    photos = await Permission.photos.request();
    Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> requestPhotos() async {
    photos = await Permission.photos.request();
  }

  Future<PermissionStatus> requestNotification() async {
    notification = await Permission.notification.request();
    return notification;
  }
}
