import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'follow_api.g.dart';

@RestApi()
abstract class FollowApi {
  @GET('/interactions/relationship/follow/')
  Future<String> fetchMyFollowList({
    @Query('page') required int pageNo,
    @Query('type') required String type,
  });

  @GET('/interactions/relationship/follow/{id}/')
  Future<void> fetchFollowList({
    @Path('id') required int id,
    @Query('page') required int pageNo,
    @Query('String') required String type,
  });

  @POST('/interactions/relationship/follow/{id}/')
  Future<void> follow({
    @Path('id') required int id,
  });

  @DELETE('/interactions/relationship/follow/{id}/')
  Future<void> unFollow({
    @Path('id') required int id,
  });

  factory FollowApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _FollowApi(dio);
  }
}
