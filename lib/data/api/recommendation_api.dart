import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/data/dto/coffee_bean/recommended_coffee_bean_dto.dart';
import 'package:brew_buds/data/dto/recommended/recommended_page_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'recommendation_api.g.dart';

@RestApi()
abstract class RecommendationApi {
  @GET('/recommendation/budy/')
  Future<RecommendedPageDTO> fetchRecommendedBuddyPage();

  @GET('/recommendation/bean/{user_id}/')
  Future<List<RecommendedCoffeeBeanDTO>> fetchRecommendedCoffeeBeanList({
    @Path('user_id') required int id,
  });

  factory RecommendationApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _RecommendationApi(dio);
  }
}
