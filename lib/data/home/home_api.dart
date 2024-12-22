import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/pages/feed_page.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@RestApi()
abstract class HomeApi {
  @GET('/records/feed/')
  Future<FeedPage> fetchFeedPage({
    @Query('feed_type') required String feedType,
    @Query('page') required int pageNo,
  });

  @GET('/records/post/')
  Future<PostFeedPage> fetchPostFeedPage({
    @Query('subject') required String? subject,
    @Query('page') required int pageNo,
  });

  @GET('/records/tasted_record/')
  Future<TastingRecordFeedPage> fetchTastingRecordFeedPage({
    @Query('page') required int pageNo,
  });

  @GET('/recommendation/buddy/')
  Future<RecommendedUserPage> fetchRecommendedUserPage();

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

  @POST('/interactions/note/{type}/{id}/')
  Future<void> save({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  @DELETE('/interactions/note/{type}/{id}/')
  Future<void> delete({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  factory HomeApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _HomeApi(dio);
  }
}
