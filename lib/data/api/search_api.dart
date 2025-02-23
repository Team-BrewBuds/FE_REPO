import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api.g.dart';

@RestApi()
abstract class SearchApi {
  @GET('/search/bean_suggest/')
  Future<String> fetchBeanSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/buddy_suggest/')
  Future<String> fetchUserSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/tastedrecord_suggest/')
  Future<String> fetchTastingRecordSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/post_suggest/')
  Future<String> fetchPostSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/bean_list/')
  Future<String> searchBean({
    @Query('q') required String searchWord,
    @Query('bean_type') String? beanType,
    @Query('origin_country') String? country,
    @Query('is_decaf') bool? isDecaf,
    @Query('min_star') double? minRating,
    @Query('max_star') double? maxRating,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/buddy_list/')
  Future<String> searchUser({
    @Query('q') required String searchWord,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/tastedrecord_list/')
  Future<String> searchTastingRecord({
    @Query('q') required String searchWord,
    @Query('bean_type') String? beanType,
    @Query('origin_country') String? country,
    @Query('is_decaf') bool? isDecaf,
    @Query('min_star') double? minRating,
    @Query('max_star') double? maxRating,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/post_list/')
  Future<String> searchPost({
    @Query('q') required String searchWord,
    @Query('subject') String? subject,
    @Query('sort_by') String? sortBy,
  });

  factory SearchApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _SearchApi(dio);
  }
}
