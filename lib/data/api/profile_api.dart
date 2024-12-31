import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  @GET('/profiles/')
  Future<void> fetchMyProfile();

  //미구현
  @PATCH('/profiles/')
  Future<void> updateMyProfile({
    @Body() required Map<String, dynamic> body,
  });

  //미구현
  @GET('/profiles/{id}/')
  Future<void> fetchProfile({
    @Path('id') required int id,
  });

  //미구현
  @GET('/profiles/{id}/notes/')
  Future<void> fetchSavedNotes({
    @Path('id') required int id,
  });

  factory ProfileApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _ProfileApi(dio);
  }
}
