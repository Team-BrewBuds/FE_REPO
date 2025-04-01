import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/data/api/recommendation_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_detail_dto.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_dto.dart';
import 'package:brew_buds/data/dto/coffee_bean/recommended_coffee_bean_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_for_coffee_bean_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_detail_mapper.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/recommended/recommended_coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_coffee_bean_mapper.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_detail.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';
import 'package:flutter/foundation.dart';

class CoffeeBeanRepository {
  final BeansApi _beansApi = BeansApi();
  final RecommendationApi _recommendedApi = RecommendationApi();
  final SaveApi _saveApi = SaveApi();

  CoffeeBeanRepository._();

  static final CoffeeBeanRepository _instance = CoffeeBeanRepository._();

  static CoffeeBeanRepository get instance => _instance;

  factory CoffeeBeanRepository() => instance;

  Future<List<RecommendedCoffeeBean>> fetchRecommendedCoffeeBean() async {
    final id = AccountRepository.instance.id;
    if (id != null) {
      final jsonString = await _recommendedApi.fetchRecommendedCoffeeBeanList(id: id);
      return compute((jsonString) {
        try {
          final jsonList = jsonDecode(jsonString) as List<dynamic>;
          return jsonList
              .map((json) => RecommendedCoffeeBeanDTO.fromJson(json as Map<String, dynamic>).toDomain())
              .toList();
        } catch (e) {
          rethrow;
        }
      }, jsonString);
    } else {
      return Future.error(Error());
    }
  }

  Future<CoffeeBeanDetail> fetchCoffeeBeanDetail({required int id}) async {
    final jsonString = await _beansApi.fetchBeanDetail(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return CoffeeBeanDetailDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<TastedRecordInCoffeeBean>> fetchTastedRecordsForCoffeeBean({required int id}) async {
    final jsonString = await _beansApi.fetchTastedRecordsForCoffeeBean(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => TastedRecordInCoffeeBeanDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<CoffeeBean>> fetchCoffeeBeans({required String word, required int pageNo}) async {
    final jsonString = await _beansApi.searchBeans(name: word, pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(json, (json) => CoffeeBeanDTO.fromJson(json as Map<String, dynamic>).toDomain());
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<void> save({required int id, required bool isSaved}) {
    if (isSaved) {
      return _saveApi.unSave(type: 'bean', id: id);
    } else {
      return _saveApi.save(type: 'bean', id: id);
    }
  }
}
