import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/widgets/post_feed/horizontal_image_list_view.dart';
import 'package:brew_buds/home/widgets/post_feed/horizontal_tasting_record_list_view.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePostView extends StatefulWidget {
  final ScrollController? scrollController;
  final Function() scrollToTop;

  const HomePostView({
    super.key,
    this.scrollController,
    required this.scrollToTop,
  });

  @override
  State<HomePostView> createState() => _HomePostViewState();
}

class _HomePostViewState extends State<HomePostView> with HomeViewMixin<HomePostView, HomePostPresenter> {
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget buildListItem(HomePostPresenter presenter, int index) {
    final post = presenter.feeds[index];

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
                  onTap: () {
                    pushToTastingRecordDetail(context: context, id: tastingRecord.id);
                  },
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
      isFollowed: post.isUserFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: post.author.id);
      },
      onTapFollowButton: () {
        presenter.onTappedFollowButton(post);
      },
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {
        presenter.onTappedLikeButton(post);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: true, id: post.id, author: post.author);
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
      onTapMoreButton: () {
        pushToPostDetail(context: context, id: post.id);
      },
      child: child,
    );
  }

  @override
  SliverAppBar buildListViewTitle(HomePostPresenter presenter) {
    return SliverAppBar(
      titleSpacing: 0,
      floating: true,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List<Widget>.generate(
              presenter.postSubjectFilterList.length + 1,
              (index) {
                if (index == 0) {
                  return ButtonFactory.buildOvalButton(
                    onTapped: () => context.push('/home/popular_post'),
                    text: '인기',
                    style: OvalButtonStyle.line(
                      color: ColorStyles.red,
                      textColor: ColorStyles.red,
                      size: OvalButtonSize.medium,
                    ),
                  );
                } else {
                  return ButtonFactory.buildOvalButton(
                    onTapped: () {
                      return presenter.onChangeSubject(index - 1);
                    },
                    text: presenter.postSubjectFilterList[index - 1],
                    style: index - 1 == presenter.currentFilterIndex
                        ? OvalButtonStyle.fill(
                            color: ColorStyles.black,
                            textColor: ColorStyles.white,
                            size: OvalButtonSize.medium,
                          )
                        : OvalButtonStyle.line(
                            color: ColorStyles.gray70,
                            textColor: ColorStyles.gray70,
                            size: OvalButtonSize.medium,
                          ),
                  );
                }
              },
            ).separator(separatorWidget: const SizedBox(width: 6)).toList(),
          ),
        ),
      ),
    );
  }
}
