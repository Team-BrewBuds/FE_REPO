import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/pages/feed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api.g.dart';

@RestApi()
abstract class FeedApi {
  @GET('/records/feed/')
  Future<FeedPage> fetchFeedPage({
    @Query('feed_type') required String feedType,
    @Query('page') required int pageNo,
  });

  factory FeedApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _FeedApi(dio);
  }
}
