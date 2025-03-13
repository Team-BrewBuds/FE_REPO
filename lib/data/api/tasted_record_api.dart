import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'tasted_record_api.g.dart';

@RestApi()
abstract class TastedRecordApi {
  @GET('/records/tasted_record/')
  Future<String> fetchTastingRecordFeedPage({
    @Query('page') required int pageNo,
  });

  @POST('/records/tasted_record/')
  Future<void> createTastedRecord({
    @Body() required Map<String, dynamic> data,
  });

  @GET('/records/tasted_record/{id}/')
  Future<TastedRecordDTO> fetchTastedRecord({
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
  Future<String> fetchTastedRecordPage({
    @Path('userId') required int userId,
    @Query('page') required int pageNo,
    @Query('ordering') String? orderBy,
    @Query('bean_type') String? beanType,
    @Query('is_decaf') bool? isDecaf,
    @Query('origin_country') String? country,
    @Query('roast_point_min') double? roastingPointMin,
    @Query('roast_point_max') double? roastingPointMax,
    @Query('star_min') double? ratingMin,
    @Query('star_max') double? ratingMax,
  });

  factory TastedRecordApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _TastedRecordApi(dio);
  }
}
