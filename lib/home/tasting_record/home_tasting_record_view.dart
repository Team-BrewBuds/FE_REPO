import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:flutter/material.dart';

class HomeTastingRecordView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeTastingRecordView({super.key, this.scrollController});

  @override
  State<HomeTastingRecordView> createState() => _HomeTastingRecordViewState();
}

class _HomeTastingRecordViewState extends State<HomeTastingRecordView>
    with HomeViewMixin<HomeTastingRecordView, HomeTastingRecordPresenter> {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  Widget buildListItem(HomeTastingRecordPresenter presenter, int index) {
    final tastingRecord = presenter.feeds[index];
    return TastingRecordFeed(
      writerThumbnailUri: tastingRecord.author.profileImageUri,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt.differenceTheNow,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: true,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      isLeaveComment: tastingRecord.isLeaveComment,
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {},
      onTapCommentsButton: () {},
      onTapSaveButton: () {},
      thumbnailUri: tastingRecord.thumbnailUri,
      rating: '${tastingRecord.rating}',
      type: tastingRecord.beanType,
      name: tastingRecord.beanName,
      tags: tastingRecord.flavors,
      body: tastingRecord.contents,
      onTapMoreButton: () {},
    );
  }
}