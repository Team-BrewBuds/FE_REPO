import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../model/profile.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET('/profiles/')
  Future<Profile> getProfile();

  @PATCH("/profiles/")
  Future<Profile> patchProfile({
    @Header('Authorization') required String token,
    @Body() required Map<String, dynamic> map,
  });
}
