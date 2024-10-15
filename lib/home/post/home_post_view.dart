import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/widgets/post_feed/post_contents_type.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/model/post_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePostView extends StatefulWidget {
  const HomePostView({super.key});

  @override
  State<HomePostView> createState() => _HomePostViewState();
}

class _HomePostViewState extends State<HomePostView> with HomeViewMixin<HomePostView, HomePostPresenter> {
  final List<String> appbarPostTags = ['전체', '인기', '일반', '카페', '원두', '정보', '질문', '고민'];

  @override
  Widget buildListItem(HomePostPresenter presenter, int index) {
    final post = presenter.feeds[index];
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
}
