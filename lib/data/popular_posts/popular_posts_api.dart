import 'package:brew_buds/model/pages/popular_post_page.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'popular_posts_api.g.dart';

@RestApi()
abstract class PopularPostsApi {
  @GET('/records/post/top')
  Future<PopularPostsPage> fetchPopularPostsPage({
    @Query('subject') required String subject,
    @Query('format') required String format,
    @Query('page') required int pageNo,
  });

  factory PopularPostsApi(Dio dio) = _PopularPostsApi;
}