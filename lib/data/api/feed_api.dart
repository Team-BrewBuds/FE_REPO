import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_api.g.dart';

@RestApi()
abstract class FeedApi {
  @GET('/records/feed/v2/')
  Future<String> fetchFeedPage({
    @Queries() required Map<String, dynamic> queries,
  });

  factory FeedApi() => _FeedApi(DioClient.instance.dio);
}
