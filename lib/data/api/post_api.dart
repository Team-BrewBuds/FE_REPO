import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/detail/model/post.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  @GET('/records/post/')
  Future<PostFeedPage> fetchPostFeedPage({
    @Query('subject') required String? subject,
    @Query('page') required int pageNo,
  });

  @POST('/records/post/')
  Future<void> createPost({
    @Body() required Map<String, dynamic> data,
  });

  @GET('/records/post/{id}/')
  Future<Post> fetchPost({
    @Path('id') required int id,
  });

  @PATCH('/records/post/{id}/')
  Future<void> updatePost({
    @Path('id') required int id,
    @Body() required Map<String, dynamic> data,
  });

  @DELETE('/records/post/{id}/')
  Future<void> deletePost({
    @Path('id') required int id,
  });

  @GET('/records/post/top/')
  Future<PopularPostsPage> fetchPopularPostsPage({
    @Query('subject') required String subject,
    @Query('page') required int pageNo,
  });

  @GET('/records/post/user/{userId}/')
  Future<String> fetchPostPage({
    @Path('userId') required int userId,
  });

  factory PostApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _PostApi(dio);
  }
}
