import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/data/dto/profile/account_info_dto.dart';
import 'package:brew_buds/data/dto/profile/profile_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  @GET('/profiles/')
  Future<ProfileDTO> fetchMyProfile();

  @PATCH('/profiles/')
  Future<void> updateMyProfile({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/profiles/{id}/')
  Future<ProfileDTO> fetchProfile({
    @Path('id') required int id,
  });

  @GET('/profiles/{id}/notes/')
  Future<String> fetchSavedNotes({
    @Path('id') required int id,
    @Query('page') required int pageNo,
  });

  @GET('/profiles/duplicated_nickname/')
  Future<String> checkNickname({
    @Query('nickname') required String nickname,
  });

  @GET('/profiles/user/info/{user_id}/')
  Future<AccountInfoDTO> fetchUserInfo({
    @Path('user_id') required int id,
  });

  @DELETE('/profiles/')
  Future<void> signOut();

  factory ProfileApi() => _ProfileApi(DioClient.instance.dio);
}
