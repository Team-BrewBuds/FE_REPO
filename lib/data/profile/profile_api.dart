import 'package:brew_buds/core/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import '../../model/profile.dart';
import '../../model/user.dart';

part 'profile_api.g.dart';

@RestApi(
  baseUrl: "http://13.125.233.210"
)
abstract class ProfileApi {

  @GET('/profiles/')
  Future<Profile> getProfile({
    @Header('Authorization') required String token,
  });

  @PATCH("/profiles/")
  Future<Profile> patchProfile({
    @Header('Authorization') required String token,
    @Body() required Map<String,dynamic> map,

});



  factory ProfileApi(Dio dio) = _ProfileApi;
}
