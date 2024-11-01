import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'comments_api.g.dart';

@RestApi()
abstract class CommentsApi {
  @GET('/records/comment/{feedType}/{id}')
  Future<CommentsPage> fetchCommentsPage({
    @Path() required String feedType,
    @Path() required int id,
    @Query('page') required int pageNo,
  });

  factory CommentsApi(Dio dio) = _CommentsApi;
}