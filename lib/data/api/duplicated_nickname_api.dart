import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'duplicated_nickname_api.g.dart';

@RestApi()
abstract class DuplicatedNicknameApi {
  @GET('/profiles/duplicated_nickname/')
  Future<String> checkNickname({
    @Query('nickname') required String nickname,
  });

  factory DuplicatedNicknameApi(Dio dio) = _DuplicatedNicknameApi;
}
