import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'sign_up_api.g.dart';

@RestApi()
abstract class SignUpApi {
  @POST('/profiles/login/{socialType}/finish/')
  Future<String> registerToken({
    @Path('socialType') required String socialType,
    @Body() required Map<String, dynamic> data,
  });

  @POST('/profiles/signup/')
  Future<void> signUp({
    @Header('Authorization') required String accessToken,
    @Body() required Map<String, dynamic> data,
  });

  @GET('/profiles/login/check_nickname/')
  Future<HttpResponse> login({
    @Header('Authorization') required String accessToken,
  });

  factory SignUpApi() => _SignUpApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));
}
