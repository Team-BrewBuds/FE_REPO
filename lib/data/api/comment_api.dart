import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_api.g.dart';

@RestApi()
abstract class CommentApi {
  @GET('/records/comment/{id}/')
  Future<Comment> fetchComment({
    @Path() required int id,
  });

  //미구현
  @PATCH('/records/comment/{id}/')
  Future<CommentsPage> updateComment({
    @Path() required int id,
    @Body() required Map<String, dynamic> data,
  });

  @DELETE('/records/comment/{id}/')
  Future<CommentsPage> deleteComment({
    @Path() required int id,
  });

  @GET('/records/comment/{feedType}/{id}/')
  Future<void> createComment({
    @Path() required String feedType,
    @Path() required int id,
    @Body() required Map<String, dynamic> data,
  });

  @GET('/records/comment/{feedType}/{id}/')
  Future<CommentsPage> fetchCommentsPage({
    @Path() required String feedType,
    @Path() required int id,
    @Query('page') required int pageNo,
  });

  factory CommentApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _CommentApi(dio);
  }
}
