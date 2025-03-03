import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/detail/show_detail.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/home/all/home_all_presenter.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_button.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeAllView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeAllView({
    super.key,
    this.scrollController,
  });

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
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildRefreshWidget(),
        Selector<HomeAllPresenter, DefaultPage<Feed>>(
          selector: (context, presenter) => presenter.page,
          builder: (context, page, child) => SliverList.separated(
            itemCount: page.result.length,
            itemBuilder: (context, index) {
              final feed = page.result[index];
              final Widget feedWidget;
              if (feed is PostInFeed) {
                feedWidget = _buildPostFeed(feed);
              } else if (feed is TastingRecordInFeed) {
                feedWidget = _buildTastingRecordFeed(feed);
              } else {
                feedWidget = Container();
              }

              if (index % 12 == 11) {
                return Column(
                  children: [
                    feedWidget,
                    Container(height: 12, color: ColorStyles.gray20),
                    buildRemandedBuddies(currentPageIndex: (index / 12).floor()),
                  ],
                );
              } else {
                return feedWidget;
              }
            },
            separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
          ),
        ),
      ],
    );
  }

  Widget _buildPostFeed(PostInFeed post) {
    final width = MediaQuery.of(context).size.width;
    final Widget? child;

    if (post.imagesUri.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.imagesUri.length,
        itemBuilder: (context, index) => MyNetworkImage(
          imageUri: post.imagesUri[index],
          height: width,
          width: width,
          color: const Color(0xffD9D9D9),
        ),
      );
    } else if (post.tastingRecords.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.tastingRecords.length,
        itemBuilder: (context, index) => TastingRecordCard(
          image: MyNetworkImage(
            imageUri: post.tastingRecords[index].thumbnailUri,
            height: width,
            width: width,
            color: const Color(0xffD9D9D9),
          ),
          rating: '${post.tastingRecords[index].rating}',
          type: post.tastingRecords[index].beanType,
          name: post.tastingRecords[index].beanName,
          tags: post.tastingRecords[index].flavors,
        ),
        childBuilder: (context, index) => GestureDetector(
          onTap: () {
            showTastingRecordDetail(context: context, id: post.tastingRecords[index].id);
          },
          child: Container(
            color: ColorStyles.white,
            child: TastingRecordButton(
              name: post.tastingRecords[index].beanName,
              bodyText: post.tastingRecords[index].contents,
            ),
          ),
        ),
      );
    } else {
      child = null;
    }

    return PostFeed(
      id: post.id,
      writerThumbnailUri: post.author.profileImageUri,
      writerNickName: post.author.nickname,
      writingTime: post.createdAt,
      hits: '조회 ${post.viewCount}',
      isFollowed: post.isUserFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: post.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeAllPresenter>().onTappedFollowButton(post);
      },
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {
        context.read<HomeAllPresenter>().onTappedLikeButton(post);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: true, id: post.id, author: post.author);
      },
      onTapSaveButton: () {
        context.read<HomeAllPresenter>().onTappedSavedButton(post);
      },
      title: post.title,
      body: post.contents,
      tagText: post.subject.toString(),
      tagIcon: SvgPicture.asset(
        post.subject.iconPath,
        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
      ),
      child: child,
    );
  }

  Widget _buildTastingRecordFeed(TastingRecordInFeed tastingRecord) {
    return TastingRecordFeed(
      id: tastingRecord.id,
      writerThumbnailUri: tastingRecord.author.profileImageUri,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: tastingRecord.isUserFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: tastingRecord.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeAllPresenter>().onTappedFollowButton(tastingRecord);
      },
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      isLeaveComment: tastingRecord.isLeaveComment,
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {
        context.read<HomeAllPresenter>().onTappedLikeButton(tastingRecord);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: false, id: tastingRecord.id, author: tastingRecord.author);
      },
      onTapSaveButton: () {
        context.read<HomeAllPresenter>().onTappedSavedButton(tastingRecord);
      },
      thumbnailUri: tastingRecord.thumbnailUri,
      rating: '${tastingRecord.rating}',
      type: tastingRecord.beanType,
      name: tastingRecord.beanName,
      tags: tastingRecord.flavors,
      body: tastingRecord.contents,
    );
  }
}
