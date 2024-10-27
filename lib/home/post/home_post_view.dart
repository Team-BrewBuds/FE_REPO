import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
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
  final void Function()? jumpToTop;

  const HomePostView({
    super.key,
    this.scrollController,
    this.jumpToTop,
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
                    onTapped: () => GoRouter.of(context).push('/popular_post'),
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
                      widget.jumpToTop?.call();
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
