import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/widgets/post_feed/post_contents_type.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:brew_buds/model/post.dart';
import 'package:brew_buds/model/post_contents.dart';
import 'package:brew_buds/model/tasting_record.dart';
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
    if (feed is Post) {
      return _buildPostFeed(feed);
    } else if (feed is TastingRecord) {
      return _buildTastingRecordFeed(feed);
    } else {
      return Container();
    }
  }

  Widget _buildPostFeed(Post post) {
    final contents = post.contents;
    final PostContentsType postContentsType = switch (contents) {
      OnlyText() => PostContentsType.onlyText(),
      ImageList() => PostContentsType.images(imageUriList: contents.imageUriList),
      SharedTastingRecordList() => PostContentsType.tastingRecords(
          sharedTastingRecords: contents.sharedTastingRecordList
              .map(
                (tastingRecord) => (
                  thumbnailUri: tastingRecord.thumbnailUri,
                  coffeeBeanType: tastingRecord.coffeeBeanType.toString(),
                  name: tastingRecord.name,
                  body: tastingRecord.body,
                  rating: tastingRecord.rating,
                  tags: tastingRecord.tags,
                ),
              )
              .toList(),
        )
    };

    return PostFeed(
      writerThumbnailUri: post.writer.thumbnailUri,
      writerNickName: post.writer.nickName,
      writingTime: post.writingTime.differenceTheNow,
      hits: '조회 ${post.hits}',
      isFollowed: post.writer.isFollowed,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: post.isLike,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {},
      onTapCommentsButton: () {},
      onTapSaveButton: () {},
      title: post.title,
      body: post.body,
      tagText: post.tag.toString(),
      tagIcon: SvgPicture.asset(
        post.tag.iconPath,
        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
      ),
      onTapMoreButton: () {},
      postContentsType: postContentsType,
    );
  }

  Widget _buildTastingRecordFeed(TastingRecord tastingRecord) {
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
