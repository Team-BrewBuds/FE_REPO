import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';
import '../../model/profile.dart';

part 'profile_api.g.dart';

@RestApi(baseUrl: "http://13.125.233.210")
abstract class ProfileApi {
  @GET('/profiles/')
  Future<Profile> getProfile();

  @PATCH("/profiles/")
  Future<Profile> patchProfile({
    @Body() required Map<String, dynamic> data,
  });

  factory ProfileApi(Dio dio) = _ProfileApi;

  factory ProfileApi.defaultApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return ProfileApi(dio);
  }
}
