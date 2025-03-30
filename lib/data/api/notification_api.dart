import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/data/dto/notification/notification_setting_dto.dart';
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
    @Header('Authorization') required String token,
    @Body() required Map<String, dynamic> data,
  });

  @DELETE('/notifications/devices/')
  Future<void> deleteDeviceToken({
    @Body() required Map<String, dynamic> data,
  });

  @GET('/notifications/settings/')
  Future<NotificationSettingDTO> fetchNotificationSettings();

  @POST('/notifications/settings/')
  Future<void> createNotificationSettings({
    @Body() required NotificationSettingDTO data,
  });

  @PATCH('/notifications/settings/')
  Future<void> updateNotificationSettings({
    @Body() required NotificationSettingDTO data,
  });

  factory NotificationApi() => _NotificationApi(DioClient.instance.dio);
}
