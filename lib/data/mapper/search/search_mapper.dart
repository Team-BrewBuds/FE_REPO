import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:brew_buds/data/dto/search/search_bean_dto.dart';
import 'package:brew_buds/data/dto/search/search_post_dto.dart';
import 'package:brew_buds/data/dto/search/search_tasting_record_dto.dart';
import 'package:brew_buds/data/dto/search/search_user_dto.dart';
import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';

extension SearchBeanMapper on SearchBeanDTO {
  CoffeeBeanSearchResultModel toDomain() {
    final String imagePath;

    if (type == 'single') {
      if (roastPoint > 0 && roastPoint <= 5) {
        imagePath = 'assets/images/coffee_bean/single_$roastPoint.png';
      } else {
        imagePath = 'assets/images/coffee_bean/single_3.png';
      }
    } else if (type == 'blend') {
      imagePath = 'assets/images/coffee_bean/blend.png';
    } else {
      imagePath = '';
    }

    return CoffeeBeanSearchResultModel(
      id: id,
      name: name,
      rating: rating,
      recordedCount: tastingRecordCount,
      imagePath: imagePath,
    );
  }
}

extension SearchTastingRecordMapper on SearchTastingRecordDTO {
  TastedRecordSearchResultModel toDomain() {
    final regex = RegExp(r'^(http|https)://\S+$');
    final String imageUrl;
    if (this.imageUrl.isNotEmpty && !regex.hasMatch(this.imageUrl)) {
      imageUrl = 'https://bucket-brewbuds1.s3.ap-northeast-2.amazonaws.com/media/${this.imageUrl}';
    } else {
      imageUrl = this.imageUrl;
    }

    return TastedRecordSearchResultModel(
      id: id,
      title: beanName,
      rating: rating,
      beanType: beanType,
      taste: beanTaste.split(','),
      contents: content,
      imageUrl: imageUrl,
    );
  }
}

extension SearchPostMapper on SearchPostDTO {
  PostSearchResultModel toDomain() {
    final regex = RegExp(r'^(http|https)://\S+$');
    final String imageUrl;
    if (this.imageUrl.isNotEmpty && !regex.hasMatch(this.imageUrl)) {
      imageUrl = 'https://bucket-brewbuds1.s3.ap-northeast-2.amazonaws.com/media/${this.imageUrl}';
    } else {
      imageUrl = this.imageUrl;
    }

    return PostSearchResultModel(
      id: id,
      title: title,
      contents: content,
      likeCount: likeCount,
      commentCount: commentCount,
      hits: viewCount,
      createdAt: (DateTime.tryParse(createdAt) ?? DateTime.now()).timeAgo(),
      authorNickname: authorNickname,
      subject: subject.toDomain().toString(),
      imageUrl: imageUrl,
    );
  }
}

extension SearchUserMapper on SearchUserDTO {
  BuddySearchResultModel toDomain() {
    return BuddySearchResultModel(
      id: id,
      profileImageUrl: imageUrl,
      nickname: nickname,
      followerCount: followerCount,
      tastedRecordsCount: tastingRecordCount,
    );
  }
}
