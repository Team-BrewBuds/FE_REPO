import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'recommendation_api.g.dart';

@RestApi()
abstract class RecommendationApi {
  @GET('/recommendation/budy/')
  Future<String> fetchRecommendedBuddyPage();

  @GET('/recommendation/bean/{user_id}/')
  Future<String> fetchRecommendedCoffeeBeanList({
    @Path('user_id') required int id,
  });

  factory RecommendationApi() => _RecommendationApi(DioClient.instance.dio);
}
