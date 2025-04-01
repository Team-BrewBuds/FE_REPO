import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/dto/user/follow_user_dto.dart';
import 'package:brew_buds/data/mapper/user/follow_user_mapper.dart';
import 'package:brew_buds/domain/follow_list/model/follow_user.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:flutter/foundation.dart';

class FollowListRepository {
  final FollowApi _followApi = FollowApi();

  FollowListRepository._();

  static final FollowListRepository _instance = FollowListRepository._();

  static FollowListRepository get instance => _instance;

  factory FollowListRepository() => instance;

  Future<DefaultPage<FollowUser>> fetchFollowerList({required int id, required int page, required String type}) async {
    final jsonString = await _followApi.fetchMyFollowList(pageNo: page, type: type);
    return compute(
      (jsonString) {
        try {
          return DefaultPage.fromJson(
            jsonDecode(jsonString) as Map<String, dynamic>,
            (jsonT) => FollowUserDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<FollowUser>> fetchMyFollowerList({required int page, required String type}) async {
    final jsonString = await _followApi.fetchMyFollowList(pageNo: page, type: type);
    return compute(
      (jsonString) {
        try {
          return DefaultPage.fromJson(
            jsonDecode(jsonString) as Map<String, dynamic>,
            (jsonT) => FollowUserDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<void> follow({required int id, required bool isFollow}) {
    if (isFollow) {
      return _followApi.unFollow(id: id);
    } else {
      return _followApi.follow(id: id);
    }
  }
}
