import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:flutter/material.dart';

class HomeTastingRecordView extends StatefulWidget {
  const HomeTastingRecordView({super.key});

  @override
  State<HomeTastingRecordView> createState() => _HomeTastingRecordViewState();
}

class _HomeTastingRecordViewState extends State<HomeTastingRecordView>
    with HomeViewMixin<HomeTastingRecordView, HomeTastingRecordPresenter> {
  @override
  Widget buildListItem(HomeTastingRecordPresenter presenter, int index) {
    final tastingRecord = presenter.feeds[index];
    return TastingRecordFeed(
      writerThumbnailUri: tastingRecord.writer.thumbnailUri,
      writerNickName: tastingRecord.writer.nickName,
      writingTime: tastingRecord.writingTime.differenceTheNow,
      hits: '조회 ${tastingRecord.hits}',
      isFollowed: tastingRecord.writer.isFollowed,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: tastingRecord.isLike,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      isLeaveComment: tastingRecord.isLeaveComment,
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {},
      onTapCommentsButton: () {},
      onTapSaveButton: () {},
      thumbnailUri: tastingRecord.thumbnailUri,
      rating: '${tastingRecord.rating}',
      type: tastingRecord.coffeeBeanType.toString(),
      name: tastingRecord.name,
      tags: tastingRecord.tags,
      body: tastingRecord.body,
      onTapMoreButton: () {},
    );
  }
}
