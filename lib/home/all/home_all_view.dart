import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/widgets/post_feed/horizontal_image_list_view.dart';
import 'package:brew_buds/home/widgets/post_feed/horizontal_tasting_record_list_view.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
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
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget buildListItem(HomeAllPresenter presenter, int index) {
    final feed = presenter.feeds[index];
    if (feed is PostInFeed) {
      return _buildPostFeed(presenter, feed);
    } else if (feed is TastingRecordInFeed) {
      return _buildTastingRecordFeed(presenter, feed);
    } else {
      return Container();
    }
  }

  Widget _buildPostFeed(HomeAllPresenter presenter, PostInFeed post) {
    final Widget? child;

    if (post.imagesUri.isNotEmpty) {
      child = HorizontalImageListView(imagesUrl: post.imagesUri);
    } else if (post.tastingRecords.isNotEmpty) {
      child = HorizontalTastingRecordListView(
          items: post.tastingRecords
              .map(
                (tastingRecord) => (
                  beanName: tastingRecord.beanName,
                  beanType: tastingRecord.beanType,
                  contents: tastingRecord.contents,
                  rating: tastingRecord.rating,
                  flavors: tastingRecord.flavors,
                  imageUri: tastingRecord.thumbnailUri,
                  onTap: () {},
                ),
              )
              .toList());
    } else {
      child = null;
    }

    return PostFeed(
      writerThumbnailUri: post.author.profileImageUri,
      writerNickName: post.author.nickname,
      writingTime: post.createdAt,
      hits: '조회 ${post.viewCount}',
      isFollowed: post.author.isFollowed,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {
        presenter.onTappedLikeButton(post);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: true, id: post.id);
      },
      onTapSaveButton: () {
        presenter.onTappedSavedButton(post);
      },
      title: post.title,
      body: post.contents,
      tagText: post.subject.toString(),
      tagIcon: SvgPicture.asset(
        post.subject.iconPath,
        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
      ),
      onTapMoreButton: () {},
      child: child,
    );
  }

  Widget _buildTastingRecordFeed(HomeAllPresenter presenter, TastingRecordInFeed tastingRecord) {
    return TastingRecordFeed(
      writerThumbnailUri: tastingRecord.author.profileImageUri,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: tastingRecord.author.isFollowed,
      onTapProfile: () {},
      onTapFollowButton: () {},
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      isLeaveComment: tastingRecord.isLeaveComment,
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {
        presenter.onTappedLikeButton(tastingRecord);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: false, id: tastingRecord.id);
      },
      onTapSaveButton: () {
        presenter.onTappedSavedButton(tastingRecord);
      },
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
