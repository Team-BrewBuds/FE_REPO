import 'package:brew_buds/core/dio_client.dart';
import 'package:brew_buds/data/dto/taste_report/activity_summary_dto.dart';
import 'package:brew_buds/data/dto/taste_report/rating_distribution_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'taste_report_api.g.dart';

@RestApi()
abstract class TasteReportApi {
  @GET('/profiles/pref_report/summary/{user_id}/')
  Future<ActivitySummaryDTO> fetchActivitySummary({
    @Path('user_id') required int id,
  });

  @GET('/profiles/pref_report/calendar/{user_id}/')
  Future<String> fetchActivityCalendar({
    @Path('user_id') required int id,
    @Query('year') int? year,
    @Query('month') int? month,
    @Query('type') required String type,
  });

  @GET('/profiles/pref_report/star/{user_id}/')
  Future<RatingDistributionDTO> fetchRatingDistribution({
    @Path('user_id') required int id,
  });

  @GET('/profiles/pref_report/flavor/{user_id}/')
  Future<String> fetchFavoriteFlavor({
    @Path('user_id') required int id,
  });

  @GET('/profiles/pref_report/country/{user_id}/')
  Future<String> fetchPreferredCountry ({
    @Path('user_id') required int id,
  });

  factory TasteReportApi() => _TasteReportApi(DioClient.instance.dio);
}
