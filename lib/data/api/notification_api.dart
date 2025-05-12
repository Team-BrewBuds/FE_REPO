import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api.g.dart';

@RestApi()
abstract class NotificationApi {
  @GET('/notifications/')
  Future<String> fetchNotifications({
    @Query('page') required int pageNo,
  });

  @PATCH('/notifications/')
  Future<void> readAllNotifications();

  @DELETE('/notifications/')
  Future<void> deleteAllNotifications();

  @PATCH('/notifications/{notification_id}/')
  Future<void> readNotification({
    @Path('notification_id') required int id,
  });

  @DELETE('/notifications/{notification_id}/')
  Future<void> deleteNotification({
    @Path('notification_id') required int id,
  });

  @POST('/notifications/devices/')
  Future<void> registerDeviceToken({
    @Body() required Map<String, dynamic> data,
  });

  @DELETE('/notifications/devices/')
  Future<void> deleteDeviceToken({
    @Body() required Map<String, dynamic> data,
  });

  @GET('/notifications/settings/')
  Future<String> fetchNotificationSettings();

  @POST('/notifications/settings/')
  Future<String> createNotificationSettings({
    @Body() required Map<String, dynamic> data,
  });

  @PATCH('/notifications/settings/')
  Future<String> updateNotificationSettings({
    @Body() required Map<String, dynamic> data,
  });

  factory NotificationApi() => _NotificationApi(DioClient.instance.dio);
}
