import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/data/api/duplicated_nickname_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_in_profile_dto.dart';
import 'package:brew_buds/data/dto/post/noted_post_dto.dart';
import 'package:brew_buds/data/dto/post/post_in_profile_dto.dart';
import 'package:brew_buds/data/dto/profile/account_info_dto.dart';
import 'package:brew_buds/data/dto/profile/profile_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/noted_tasted_record_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_profile_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_in_profile_mapper.dart';
import 'package:brew_buds/data/mapper/common/preferred_bean_taste_mapper.dart';
import 'package:brew_buds/data/mapper/post/noted_post_mapper.dart';
import 'package:brew_buds/data/mapper/post/post_in_profile_mapper.dart';
import 'package:brew_buds/data/mapper/profile/account_info_mapper.dart';
import 'package:brew_buds/data/mapper/profile/profile_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/noted_tasted_record_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_profile_mapper.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';
import 'package:brew_buds/model/noted/noted_object.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/profile/account_info.dart';
import 'package:brew_buds/model/profile/profile.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileRepository {
  final ProfileApi _profileApi = ProfileApi();
  final PostApi _postApi = PostApi();
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final BeansApi _beanApi = BeansApi();
  final DuplicatedNicknameApi _duplicatedNicknameApi = DuplicatedNicknameApi(
    Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))),
  );

  ProfileRepository._();

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<Profile> fetchMyProfile() async {
    final jsonString = await _profileApi.fetchMyProfile();
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return ProfileDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<Profile> fetchProfile({required int id}) async {
    final jsonString = await _profileApi.fetchProfile(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return ProfileDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<bool> isValidNickname({required String nickname}) async {
    return _duplicatedNicknameApi.checkNickname(nickname: nickname).then(
      (value) {
        final json = jsonDecode(value) as Map<String, dynamic>;
        return !(json['is_available'] as bool? ?? false);
      },
    ).onError((error, stackTrace) => true);
  }

  Future<void> updateProfile({
    String? nickname,
    String? introduction,
    String? profileLink,
    List<CoffeeLife>? coffeeLife,
    PreferredBeanTaste? preferredBeanTaste,
    bool? isCertificated,
  }) {
    final Map<String, dynamic> data = {};
    if (nickname != null) {
      data['nickname'] = nickname;
    }
    final Map<String, dynamic> userDetail = {};
    writeNotNull(String key, dynamic value) {
      if (value != null) {
        userDetail[key] = value;
      }
    }

    writeNotNull('introduction', introduction);
    writeNotNull('profile_link', profileLink);
    if (coffeeLife != null) {
      writeNotNull('coffee_life', _coffeeLifeToJson(coffeeLife));
    }
    writeNotNull('preferred_bean_taste', preferredBeanTaste?.toJson());
    writeNotNull('is_certificated', isCertificated);
    if (userDetail.isNotEmpty) {
      data['user_detail'] = userDetail;
    }

    return _profileApi.updateMyProfile(body: data);
  }

  Map<String, dynamic> _coffeeLifeToJson(List<CoffeeLife> coffeeLife) {
    return {
      'cafe_alba': coffeeLife.contains(CoffeeLife.cafeAlba),
      'cafe_tour': coffeeLife.contains(CoffeeLife.cafeTour),
      'cafe_work': coffeeLife.contains(CoffeeLife.cafeWork),
      'coffee_study': coffeeLife.contains(CoffeeLife.coffeeStudy),
      'cafe_operation': coffeeLife.contains(CoffeeLife.cafeOperation),
      'coffee_extraction': coffeeLife.contains(CoffeeLife.coffeeExtraction),
    };
  }

  Future<DefaultPage<PostInProfile>> fetchPostPage({required int userId}) async {
    final jsonString = await _postApi.fetchPostPage(userId: userId);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(json, (jsonT) {
            return PostInProfileDTO.fromJson(jsonT as Map<String, dynamic>).toDomain();
          });
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<AccountInfo> fetchInfo({required int id}) async {
    final jsonString = await _profileApi.fetchUserInfo(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return AccountInfoDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<TastedRecordInProfile>> fetchTastedRecordPage({
    required int userId,
    required int pageNo,
    String? orderBy,
    String? beanType,
    bool? isDecaf,
    String? country,
    double? roastingPointMin,
    double? roastingPointMax,
    double? ratingMin,
    double? ratingMax,
  }) async {
    final jsonString = await _tastedRecordApi.fetchTastedRecordPage(
      userId: userId,
      pageNo: pageNo,
      orderBy: orderBy,
      beanType: beanType,
      isDecaf: isDecaf,
      country: (country?.isEmpty ?? true) ? null : country,
      roastingPointMin: roastingPointMin,
      roastingPointMax: roastingPointMax,
      ratingMin: ratingMin,
      ratingMax: ratingMax,
    );

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) {
              return TastedRecordInProfileDTO.fromJson(jsonT as Map<String, dynamic>).toDomain();
            },
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<BeanInProfile>> fetchCoffeeBeanPage({
    required int userId,
    required int pageNo,
    String? orderBy,
    String? beanType,
    bool? isDecaf,
    String? country,
    double? roastingPointMin,
    double? roastingPointMax,
    double? ratingMin,
    double? ratingMax,
  }) async {
    final jsonString = await _beanApi.fetchBeans(
      id: userId,
      pageNo: pageNo,
      ordering: orderBy,
      beanType: beanType,
      isDecaf: isDecaf,
      country: country,
      roastingPointMin: roastingPointMin,
      roastingPointMax: roastingPointMax,
      starMin: ratingMin,
      starMax: ratingMax,
    );

    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) {
              return CoffeeBeanInProfileDTO.fromJson(jsonT as Map<String, dynamic>).toDomain();
            },
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<NotedObject>> fetchNotePage({required int userId, required int pageNo}) async {
    final jsonString = await _profileApi.fetchSavedNotes(id: userId, pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(json, (jsonT) {
            final jsonMap = jsonT as Map<String, dynamic>;
            if (jsonMap.containsKey('post_id')) {
              return NotedPostDTO.fromJson(jsonMap).toDomain();
            } else {
              return NotedTastedRecordDTO.fromJson(jsonMap).toDomain();
            }
          });
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }
}
