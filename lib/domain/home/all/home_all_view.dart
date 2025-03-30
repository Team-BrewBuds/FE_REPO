import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/home/all/home_all_presenter.dart';
import 'package:brew_buds/domain/home/core/home_view_mixin.dart';
import 'package:brew_buds/domain/home/widgets/post_feed_widget.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_button.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_feed_widget.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';
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
    scrollController = widget.scrollController ?? ScrollController();
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildRefreshWidget(),
        Selector<HomeAllPresenter, (DefaultPage<Feed>, List<RecommendedPage>)>(
          selector: (context, presenter) => (presenter.defaultPage, presenter.recommendedUserPage),
          builder: (context, selector, child) {
            final page = selector.$1;
            final recommendedUserPageList = selector.$2;

            return SliverList.separated(
              itemCount: page.results.length,
              itemBuilder: (context, index) {
                final feed = page.results[index];
                final Widget feedWidget;

                switch (feed) {
                  case PostFeed():
                    feedWidget = _buildPostFeed(feed.data, index);
                  case TastedRecordFeed():
                    feedWidget = _buildTastedRecordFeed(feed.data, index);
                }

                if (index % 12 == 11 && (index / 12).floor() < recommendedUserPageList.length) {
                  final recommendedUserIndex = (index / 12).floor();
                  return Column(
                    children: [
                      feedWidget,
                      Container(height: 12, color: ColorStyles.gray20),
                      buildRemandedBuddies(
                        page: recommendedUserPageList[recommendedUserIndex],
                        currentPageIndex: (index / 12).floor(),
                      ),
                    ],
                  );
                } else {
                  return feedWidget;
                }
              },
              separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPostFeed(Post post, int index) {
    final width = MediaQuery.of(context).size.width;
    final Widget? child;

    if (post.imagesUrl.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.imagesUrl.length,
        itemBuilder: (context, index) => MyNetworkImage(
          imageUrl: post.imagesUrl[index],
          height: width,
          width: width,
        ),
      );
    } else if (post.tastingRecords.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.tastingRecords.length,
        itemBuilder: (context, index) => TastingRecordCard(
          image: MyNetworkImage(
            imageUrl: post.tastingRecords[index].thumbnailUrl,
            height: width,
            width: width,
          ),
          rating: '${post.tastingRecords[index].rating}',
          type: post.tastingRecords[index].beanType,
          name: post.tastingRecords[index].beanName,
          tags: post.tastingRecords[index].flavors,
        ),
        childBuilder: (context, index) => GestureDetector(
          onTap: () {
            showTastingRecordDetail(context: context, id: post.tastingRecords[index].id).then((result) {
              if (result != null) {
                showSnackBar(message: result);
              }
            });
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

    return PostFeedWidget(
      id: post.id,
      writerThumbnailUrl: post.author.profileImageUrl,
      writerNickName: post.author.nickname,
      writingTime: post.createdAt,
      hits: '조회 ${post.viewCount}',
      isFollowed: post.isAuthorFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: post.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeAllPresenter>().onTappedFollowAt(index);
      },
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {
        context.read<HomeAllPresenter>().onTappedLikeAt(index);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: true, id: post.id, author: post.author);
      },
      onTapSaveButton: () {
        context.read<HomeAllPresenter>().onTappedSavedAt(index);
      },
      title: post.title,
      body: post.contents,
      subjectText: post.subject.toString(),
      subjectIcon: SvgPicture.asset(
        post.subject.iconPath,
        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
      ),
      tag: post.tag,
      child: child,
    );
  }

  Widget _buildTastedRecordFeed(TastedRecordInFeed tastingRecord, int index) {
    return TastingRecordFeedWidget(
      id: tastingRecord.id,
      writerThumbnailUrl: tastingRecord.author.profileImageUrl,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: tastingRecord.isAuthorFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: tastingRecord.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeAllPresenter>().onTappedFollowAt(index);
      },
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {
        context.read<HomeAllPresenter>().onTappedLikeAt(index);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: false, id: tastingRecord.id, author: tastingRecord.author);
      },
      onTapSaveButton: () {
        context.read<HomeAllPresenter>().onTappedSavedAt(index);
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
