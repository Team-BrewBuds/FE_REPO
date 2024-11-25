import 'package:brew_buds/core/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retrofit/retrofit.dart';
import '../../model/profile.dart';
import '../../model/user.dart';

part 'profile_api.g.dart';


abstract class ProfileApi {

  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET('/profiles/')
  Future<Profile> getProfile();

  @PATCH("/profiles/")
  Future<Profile> patchProfile({
    @Header('Authorization') required String token,
    @Body() required Map<String,dynamic> map,

});




}
