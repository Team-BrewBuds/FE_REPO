import 'dart:convert';
import 'package:brew_buds/data/api/search_api.dart';
import 'package:brew_buds/data/dto/search/search_bean_dto.dart';
import 'package:brew_buds/data/dto/search/search_post_dto.dart';
import 'package:brew_buds/data/dto/search/search_tasting_record_dto.dart';
import 'package:brew_buds/data/dto/search/search_user_dto.dart';
import 'package:brew_buds/data/mapper/search_mapper.dart';
import 'package:brew_buds/search/models/search_result_model.dart';
import 'package:brew_buds/search/models/search_subject.dart';

final class SearchRepository {
  final SearchApi _searchApi = SearchApi();

  SearchRepository._();

  static final SearchRepository _instance = SearchRepository._();

  static SearchRepository get instance => _instance;

  factory SearchRepository() => instance;

  Future<List<String>> fetchSuggestSearchWord({required String searchWord, required SearchSubject subject}) async {
    final String result;
    switch (subject) {
      case SearchSubject.coffeeBean:
        result = await _searchApi.fetchBeanSuggest(searchWord: searchWord).onError((error, stackTrace) => '');
      case SearchSubject.buddy:
        result = await _searchApi.fetchUserSuggest(searchWord: searchWord).onError((error, stackTrace) => '');
      case SearchSubject.tastedRecord:
        result = await _searchApi.fetchTastingRecordSuggest(searchWord: searchWord).onError((error, stackTrace) => '');
      case SearchSubject.post:
        result = await _searchApi.fetchPostSuggest(searchWord: searchWord).onError((error, stackTrace) => '');
    }

    if (result.isEmpty) return [];

    final json = jsonDecode(result) as Map<String, dynamic>;
    final suggestions = json['suggestions'] as List<dynamic>;
    return suggestions.map((e) => e as String).toList();
  }

  Future<List<CoffeeBeanSearchResultModel>> searchBean({
    required String searchWord,
    String? beanType,
    String? country,
    bool? isDecaf,
    double? minRating,
    double? maxRating,
    String? sortBy,
  }) async {
    final result = await _searchApi
        .searchBean(
          searchWord: searchWord,
          beanType: beanType,
          country: country,
          isDecaf: isDecaf,
          minRating: minRating,
          maxRating: maxRating,
          sortBy: sortBy,
        )
        .onError((error, stackTrace) => '');

    if (result.isEmpty) return [];
    final json = jsonDecode(result) as List<dynamic>;
    return json.map((e) => SearchBeanDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList();
  }

  Future<List<BuddySearchResultModel>> searchUser({required String searchWord, String? sortBy}) async {
    final result = await _searchApi
        .searchUser(
          searchWord: searchWord,
          sortBy: sortBy,
        )
        .onError((error, stackTrace) => '');
    if (result.isEmpty) return [];
    final json = jsonDecode(result) as List<dynamic>;
    return json.map((e) => SearchUserDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList();
  }

  Future<List<TastedRecordSearchResultModel>> searchTastingRecord({
    required String searchWord,
    String? beanType,
    String? country,
    bool? isDecaf,
    double? minRating,
    double? maxRating,
    String? sortBy,
  }) async {
    final result = await _searchApi
        .searchTastingRecord(
          searchWord: searchWord,
          beanType: beanType,
          country: country,
          isDecaf: isDecaf,
          minRating: minRating,
          maxRating: maxRating,
          sortBy: sortBy,
        )
        .onError((error, stackTrace) => '');
    if (result.isEmpty) return [];
    final json = jsonDecode(result) as List<dynamic>;
    return json.map((e) => SearchTastingRecordDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList();
  }

  Future<List<PostSearchResultModel>> searchPost({required String searchWord, String? subject, String? sortBy}) async {
    final result = await _searchApi
        .searchPost(
          searchWord: searchWord,
          subject: subject,
          sortBy: sortBy,
        )
        .onError((error, stackTrace) => '');
    if (result.isEmpty) return [];
    final json = jsonDecode(result) as List<dynamic>;
    return json.map((e) => SearchPostDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList();
  }
}
