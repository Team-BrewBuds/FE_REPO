import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/domain/profile/model/profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  @GET('/profiles/')
  Future<Profile> fetchMyProfile();

  @PATCH('/profiles/')
  Future<void> updateMyProfile({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/profiles/{id}/')
  Future<Profile> fetchProfile({
    @Path('id') required int id,
  });

  @GET('/profiles/{id}/notes/')
  Future<String> fetchSavedNotes({
    @Path('id') required int id,
    @Query('page') required int pageNo,
  });

  factory ProfileApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _ProfileApi(dio);
  }
}
