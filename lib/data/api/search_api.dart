import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api.g.dart';

@RestApi()
abstract class SearchApi {
  @GET('/search/suggest/bean/')
  Future<String> fetchBeanSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/suggest/buddy/')
  Future<String> fetchUserSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/suggest/tasted_record/')
  Future<String> fetchTastingRecordSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/suggest/post/')
  Future<String> fetchPostSuggest({
    @Query('q') required String searchWord,
  });

  @GET('/search/bean/')
  Future<String> searchBean({
    @Query('q') required String searchWord,
    @Query('bean_type') String? beanType,
    @Query('origin_country') String? country,
    @Query('is_decaf') bool? isDecaf,
    @Query('min_star') double? minRating,
    @Query('max_star') double? maxRating,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/buddy/')
  Future<String> searchUser({
    @Query('q') required String searchWord,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/tasted_record/')
  Future<String> searchTastingRecord({
    @Query('q') required String searchWord,
    @Query('bean_type') String? beanType,
    @Query('origin_country') String? country,
    @Query('is_decaf') bool? isDecaf,
    @Query('min_star') double? minRating,
    @Query('max_star') double? maxRating,
    @Query('sort_by') String? sortBy,
  });

  @GET('/search/post/')
  Future<String> searchPost({
    @Query('q') required String searchWord,
    @Query('subject') String? subject,
    @Query('sort_by') String? sortBy,
  });

  factory SearchApi() => _SearchApi(DioClient.instance.dio);
}
