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
  @GET('/records/feed')
  Future<FeedPage> fetchFeedPage({
    @Query('feed_type') required String feedType,
    @Query('format') required String format,
    @Query('page') required int pageNo,
  });

  @GET('/records/post')
  Future<PostFeedPage> fetchPostFeedPage({
    @Query('subject') required String subject,
    @Query('format') required String format,
    @Query('page') required int pageNo,
  });

  @GET('/records/tasted_record')
  Future<TastingRecordFeedPage> fetchTastingRecordFeedPage({
    @Query('format') required String format,
    @Query('page') required int pageNo,
  });

  @GET('/records/tasted_record')
  Future<RecommendedUserPage> fetchRecommendedUserPage();


  factory HomeApi(Dio dio) = _HomeApi;

  factory HomeApi.defaultApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return HomeApi(dio);
  }
}