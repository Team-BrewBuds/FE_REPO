import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'tasted_record_api.g.dart';

@RestApi()
abstract class TastedRecordApi {
  @GET('/records/tasted_record/')
  Future<TastingRecordFeedPage> fetchTastingRecordFeedPage({
    @Query('page') required int pageNo,
  });

  @POST('/records/tasted_record/')
  Future<void> createTastedRecord({
    @Body() required Map<String, dynamic> data,
  });

  @GET('/records/tasted_record/{id}/')
  Future<void> fetchTastedRecord({
    @Path('id') required int id,
  });

  @PATCH('/records/tasted_record/{id}/')
  Future<void> updateTastedRecord({
    @Path('id') required int id,
    @Body() required Map<String, dynamic> data,
  });

  @DELETE('/records/tasted_record/{id}/')
  Future<void> deleteTastedRecord({
    @Path('id') required int id,
  });

  @GET('/records/tasted_record/user/{userId}/')
  Future<void> fetchTastedRecordPage({
    @Path('userId') required int userId,
    @Query('subject') required String subject,
  });

  factory TastedRecordApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _TastedRecordApi(dio);
  }
}
