import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/domain/profile/model/in_profile/bean_in_profile.dart';
import 'package:brew_buds/domain/profile/model/in_profile/post_in_profile.dart';
import 'package:brew_buds/domain/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:brew_buds/domain/profile/model/profile.dart';
import 'package:brew_buds/domain/profile/model/saved_note/saved_note.dart';
import 'package:brew_buds/domain/profile/model/saved_note/saved_post.dart';
import 'package:brew_buds/domain/profile/model/saved_note/saved_tasting_record.dart';
import 'package:brew_buds/model/common/default_page.dart';

class ProfileRepository {
  final ProfileApi _profileApi = ProfileApi();
  final PostApi _postApi = PostApi();
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final BeansApi _beanApi = BeansApi();

  ProfileRepository._();

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<Profile> fetchMyProfile() => _profileApi.fetchMyProfile();

  Future<Profile> fetchProfile({required int id}) => _profileApi.fetchProfile(id: id);

  Future<void> fetchUpdateProfile(Map<String, dynamic> data) => _profileApi.updateMyProfile(body: data);

  Future<DefaultPage<PostInProfile>> fetchPostPage({required int userId}) {
    return _postApi.fetchPostPage(userId: userId).then((jsonString) {
      final json = jsonDecode(jsonString);
      return DefaultPage.fromJson(json, (jsonT) {
        return PostInProfile.fromJson(jsonT as Map<String, dynamic>);
      });
    });
  }

  Future<DefaultPage<TastingRecordInProfile>> fetchTastingRecordPage({
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
  }) {
    return _tastedRecordApi
        .fetchTastedRecordPage(
      userId: userId,
      pageNo: pageNo,
      orderBy: orderBy,
      beanType: beanType,
      isDecaf: isDecaf,
      country: country,
      roastingPointMin: roastingPointMin,
      roastingPointMax: roastingPointMax,
      ratingMin: ratingMin,
      ratingMax: ratingMax,
    )
        .then(
      (jsonString) {
        final json = jsonDecode(jsonString);
        return DefaultPage.fromJson(
          json,
          (jsonT) {
            return TastingRecordInProfile.fromJson(jsonT as Map<String, dynamic>);
          },
        );
      },
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
  }) {
    return _beanApi
        .fetchBeans(
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
    )
        .then(
      (jsonString) {
        final json = jsonDecode(jsonString);
        return DefaultPage.fromJson(
          json,
          (jsonT) {
            return BeanInProfile.fromJson(jsonT as Map<String, dynamic>);
          },
        );
      },
    );
  }

  Future<DefaultPage<SavedNote>> fetchNotePage({required int userId, required int pageNo}) {
    return _profileApi.fetchSavedNotes(id: userId, pageNo: pageNo).then((jsonString) {
      final json = jsonDecode(jsonString);
      return DefaultPage.fromJson(json, (jsonT) {
        final jsonMap = jsonT as Map<String, dynamic>;
        if (jsonMap.containsKey('post_id')) {
          return SavedPost.fromJson(jsonMap);
        } else {
          return SavedTastingRecord.fromJson(jsonMap);
        }
      });
    });
  }
}
