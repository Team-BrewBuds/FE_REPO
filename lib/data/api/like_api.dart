import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'like_api.g.dart';

@RestApi()
abstract class LikeApi {
  @POST('/interactions/like/{type}/{id}/')
  Future<void> like({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  @DELETE('/interactions/like/{type}/{id}/')
  Future<void> unlike({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  factory LikeApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _LikeApi(dio);
  }
}
