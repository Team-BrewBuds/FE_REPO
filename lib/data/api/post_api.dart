import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  @GET('/records/post/')
  Future<String> fetchPostFeedPage({@Query('subject') required String? subject, @Query('page') required int pageNo});

  @POST('/records/post/')
  Future<void> createPost({@Body() required Map<String, dynamic> data});

  @GET('/records/post/{id}/')
  Future<String> fetchPost({@Path('id') required int id});

  @PATCH('/records/post/{id}/')
  Future<void> updatePost({@Path('id') required int id, @Body() required Map<String, dynamic> data});

  @DELETE('/records/post/{id}/')
  Future<void> deletePost({@Path('id') required int id});

  @GET('/records/post/top/')
  Future<String> fetchPopularPostsPage({@Query('subject') required String subject, @Query('page') required int pageNo});

  @GET('/records/post/user/{userId}/')
  Future<String> fetchPostPage({@Path('userId') required int userId, @Query('page') required int pageNo});

  factory PostApi() => _PostApi(DioClient.instance.dio);
}
