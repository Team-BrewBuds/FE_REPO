import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/data/api/recommendation_api.dart';
import 'package:brew_buds/data/api/search_api.dart';
import 'package:brew_buds/data/dto/coffee_bean/recommended_coffee_bean_dto.dart';
import 'package:brew_buds/data/dto/search/search_bean_dto.dart';
import 'package:brew_buds/data/dto/search/search_post_dto.dart';
import 'package:brew_buds/data/dto/search/search_tasting_record_dto.dart';
import 'package:brew_buds/data/dto/search/search_user_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_simple_mapper.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/data/mapper/recommended/recommended_coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/search/search_mapper.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_simple.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:flutter/foundation.dart';

final class SearchRepository {
  final BeansApi _beansApi = BeansApi();
  final SearchApi _searchApi = SearchApi();
  final RecommendationApi _recommendedApi = RecommendationApi();

  SearchRepository._();

  static final SearchRepository _instance = SearchRepository._();

  static SearchRepository get instance => _instance;

  factory SearchRepository() => instance;

  Future<List<RecommendedCoffeeBean>> fetchRecommendedCoffeeBean() async {
    final id = AccountRepository.instance.id;
    if (id != null) {
      final jsonString = await _recommendedApi.fetchRecommendedCoffeeBeanList(id: id);
      return compute(
        (jsonString) {
          try {
            final jsonList = jsonDecode(jsonString) as List<dynamic>;
            return jsonList
                .map((json) => RecommendedCoffeeBeanDTO.fromJson(json as Map<String, dynamic>).toDomain())
                .toList();
          } catch (e) {
            rethrow;
          }
        },
        jsonString,
      );
    } else {
      return Future.error(Error());
    }
  }

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

    return compute(
      (result) {
        try {
          final json = jsonDecode(result) as Map<String, dynamic>;
          final suggestions = json['suggestions'] as List<dynamic>;
          return suggestions.map((e) => e as String).toList();
        } catch (e) {
          rethrow;
        }
      },
      result,
    );
  }

  Future<DefaultPage<SearchResultModel>> searchBean({
    required String searchWord,
    required int pageNo,
    CoffeeBeanType? beanType,
    String? country,
    bool? isDecaf,
    double? minRating,
    double? maxRating,
    String? sortBy,
  }) async {
    final jsonString = await _searchApi.searchBean(
      searchWord: searchWord,
      pageNo: pageNo,
      beanType: beanType?.toJson(),
      country: country,
      isDecaf: isDecaf,
      minRating: minRating,
      maxRating: maxRating,
      sortBy: sortBy,
    );

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => SearchBeanDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<SearchResultModel>> searchUser({
    required String searchWord,
    required int pageNo,
    String? sortBy,
  }) async {
    final jsonString = await _searchApi.searchUser(searchWord: searchWord, pageNo: pageNo, sortBy: sortBy);

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => SearchUserDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<SearchResultModel>> searchTastingRecord({
    required String searchWord,
    required int pageNo,
    CoffeeBeanType? beanType,
    String? country,
    bool? isDecaf,
    double? minRating,
    double? maxRating,
    String? sortBy,
  }) async {
    final jsonString = await _searchApi.searchTastingRecord(
      searchWord: searchWord,
      pageNo: pageNo,
      beanType: beanType?.toJson(),
      country: country,
      isDecaf: isDecaf,
      minRating: minRating,
      maxRating: maxRating,
      sortBy: sortBy,
    );

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => SearchTastingRecordDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<SearchResultModel>> searchPost({
    required String searchWord,
    required int pageNo,
    PostSubject? subject,
    String? sortBy,
  }) async {
    final jsonString = await _searchApi.searchPost(
      searchWord: searchWord,
      pageNo: pageNo,
      subject: subject?.toJsonValue(),
      sortBy: sortBy,
    );

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => SearchPostDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<List<CoffeeBeanSimple>> fetchCoffeeBeanRanking() {
    return _beansApi.fetchCoffeeBeanRanking().then((dtoList) => dtoList.map((dto) => dto.toDomain()).toList());
  }
}
