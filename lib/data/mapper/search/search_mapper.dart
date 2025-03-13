import 'package:brew_buds/data/dto/search/search_bean_dto.dart';
import 'package:brew_buds/data/dto/search/search_post_dto.dart';
import 'package:brew_buds/data/dto/search/search_tasting_record_dto.dart';
import 'package:brew_buds/data/dto/search/search_user_dto.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';

extension SearchBeanMapper on SearchBeanDTO {
  CoffeeBeanSearchResultModel toDomain() {
    return CoffeeBeanSearchResultModel(
      id: id,
      name: name,
      rating: rating,
      recordedCount: tastingRecordCount,
      imageUrl: imageUrl,
    );
  }
}

extension SearchTastingRecordMapper on SearchTastingRecordDTO {
  TastedRecordSearchResultModel toDomain() {
    return TastedRecordSearchResultModel(
      id: id,
      title: beanName,
      rating: rating,
      beanType: beanType,
      taste: beanTaste.split(','),
      contents: content,
      imageUri: imageUrl,
    );
  }
}

extension SearchPostMapper on SearchPostDTO {
  PostSearchResultModel toDomain() {
    return PostSearchResultModel(
      id: id,
      title: title,
      contents: content,
      likeCount: likeCount,
      commentCount: commentCount,
      hits: viewCount,
      createdAt: createdAt,
      authorNickname: authorNickname,
      subject: subject,
      imageUri: imageUrl,
    );
  }
}

extension SearchUserMapper on SearchUserDTO {
  BuddySearchResultModel toDomain() {
    return BuddySearchResultModel(
      id: id,
      profileImageUri: imageUrl,
      nickname: nickname,
      followerCount: followerCount,
      tastedRecordsCount: tastingRecordCount,
    );
  }
}
