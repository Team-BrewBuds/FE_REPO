import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'popular_posts_api.g.dart';

@RestApi()
abstract class PopularPostsApi {
  @GET('/records/post/top/')
  Future<PopularPostsPage> fetchPopularPostsPage({
    @Query('subject') required String subject,
    @Query('page') required int pageNo,
  });

  factory PopularPostsApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _PopularPostsApi(dio);
  }
}
