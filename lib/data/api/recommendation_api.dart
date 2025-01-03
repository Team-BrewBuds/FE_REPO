import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'recommendation_api.g.dart';

@RestApi()
abstract class RecommendationApi {
  @GET('/recommendation/buddy/')
  Future<RecommendedUserPage> fetchRecommendedBuddyPage();

  factory RecommendationApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _RecommendationApi(dio);
  }
}
