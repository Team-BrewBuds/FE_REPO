import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/data/dto/recommended/recommended_page_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'recommendation_api.g.dart';

@RestApi()
abstract class RecommendationApi {
  @GET('/recommendation/budy/')
  Future<RecommendedPageDTO> fetchRecommendedBuddyPage();

  factory RecommendationApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _RecommendationApi(dio);
  }
}
