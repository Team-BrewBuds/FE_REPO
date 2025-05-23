import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_api.g.dart';

@RestApi()
abstract class CommentApi {
  @GET('/records/comment/{id}/')
  Future<String> fetchComment({
    @Path() required int id,
  });

  @DELETE('/records/comment/{id}/')
  Future<void> deleteComment({
    @Path() required int id,
  });

  @POST('/records/comment/{feedType}/{id}/')
  Future<String> createComment({
    @Path() required String feedType,
    @Path() required int id,
    @Body() required Map<String, dynamic> data,
  });

  @GET('/records/comment/{feedType}/{id}/')
  Future<String> fetchCommentsPage({
    @Path() required String feedType,
    @Path() required int id,
    @Query('page') required int pageNo,
  });

  factory CommentApi() => _CommentApi(DioClient.instance.dio);
}
