import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  @GET('/profiles/')
  Future<String> fetchMyProfile();

  @PATCH('/profiles/')
  Future<void> updateMyProfile({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/profiles/{id}/')
  Future<String> fetchProfile({
    @Path('id') required int id,
  });

  @GET('/profiles/{id}/notes/')
  Future<String> fetchSavedNotes({
    @Path('id') required int id,
    @Query('page') required int pageNo,
  });

  @GET('/profiles/user/info/{user_id}/')
  Future<String> fetchUserInfo({
    @Path('user_id') required int id,
  });

  @DELETE('/profiles/')
  Future<void> signOut();

  factory ProfileApi() => _ProfileApi(DioClient.instance.dio);
}
