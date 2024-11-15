import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../model/profile.dart';

part 'profile_api.g.dart';

@RestApi(baseUrl: "http://13.125.233.210")
abstract class ProfileApi {
  @GET('/profiles/')
  Future<Profile> getProfile({
    @Header('Authorization') required String token,
  });

  @PATCH("/profiles/")
  Future<Profile> patchProfile({
    @Header('Authorization') required String token,
    @Body() required Map<String, dynamic> map,
  });

  factory ProfileApi(Dio dio) = _ProfileApi;
}
