import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:brew_buds/model/post_in_feed.dart';
import 'package:brew_buds/model/tasting_record_in_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAllView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeAllView({super.key, this.scrollController});

  @override
  State<HomeAllView> createState() => _HomeAllViewState();
}

class _HomeAllViewState extends State<HomeAllView> with HomeViewMixin<HomeAllView, HomeAllPresenter> {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  Widget buildListItem(HomeAllPresenter presenter, int index) {
    final feed = presenter.feeds[index];
    if (feed is PostInFeed) {
      return _buildPostFeed(feed);
    } else if (feed is TastingRecordInFeed) {
      return _buildTastingRecordFeed(feed);
    } else {
      return Container();
    }
  }

  Widget _buildPostFeed(PostInFeed post) {
    return PostFeed(
      writerThumbnailUri: post.author.profileImageUri,
      writerNickName: post.author.nickname,
      writingTime: post.createdAt.differenceTheNow,
      hits: '조회 ${post.viewCount}',
      isFollowed: false,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {},
      onTapCommentsButton: () {},
      onTapSaveButton: () {},
      title: post.title,
      body: post.contents,
      tagText: post.subject.toString(),
      tagIcon: SvgPicture.asset(
        post.subject.iconPath,
        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
      ),
      onTapMoreButton: () {},
    );
  }

  Widget _buildTastingRecordFeed(TastingRecordInFeed tastingRecord) {
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
