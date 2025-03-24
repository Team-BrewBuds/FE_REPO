import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api.g.dart';

@RestApi()
abstract class FeedApi {
  @GET('/records/feed/')
  Future<String> fetchFeedPage({
    @Query('feed_type') required String feedType,
    @Query('page') required int pageNo,
  });

  factory FeedApi() => _FeedApi(DioClient.instance.dio);
}
