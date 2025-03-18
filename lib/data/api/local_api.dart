import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'local_api.g.dart';

@RestApi()
abstract class LocalApi {
  @GET('')
  Future<String> fetchLocal({
    @Query('category_group_code') String category = 'CE7',
    @Query('query') required String query,
    @Query('page') required int pageNo,
    @Query('x') String? x,
    @Query('y') String? y,
  });

  factory LocalApi() {
    final dio = Dio(BaseOptions(baseUrl: 'https://dapi.kakao.com/v2/local/search/keyword.json'));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.headers['Authorization'] != null) {
          options.headers.remove('Authorization');
        }

        final token = dotenv.get('KAKAO_REST_API');
        options.headers.addAll({'Authorization': 'KakaoAK $token'});

        return handler.next(options);
      },
    ));
    return _LocalApi(dio);
  }
}
