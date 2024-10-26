import 'package:brew_buds/model/feed_page.dart';
import 'package:brew_buds/model/post_feed_page.dart';
import 'package:brew_buds/model/tasting_record_feed_page.dart';
import 'package:dio/dio.dart';
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

  factory HomeApi(Dio dio) = _HomeApi;
}