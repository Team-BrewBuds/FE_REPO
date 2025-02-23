import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/detail/detail_builder.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_button.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        Selector<HomePostPresenter, HomePostFeedFilterState>(
          selector: (context, presenter) => presenter.homePostFeedFilterState,
          builder: (context, homePostFeedFilterState, child) =>
              buildListViewTitle(filters: homePostFeedFilterState.postSubjectFilterList,
                currentFilterIndex: homePostFeedFilterState.currentFilterIndex,),
        ),
        buildRefreshWidget(),
        Selector<HomePostPresenter, DefaultPage<PostInFeed>>(
          selector: (context, presenter) => presenter.page,
          builder: (context, page, child) =>
              SliverList.separated(
                itemCount: page.result.length,
                itemBuilder: (context, index) {
                  final post = page.result[index];
                  if (index % 12 == 11) {
                    return Column(
                      children: [
                        _buildPostFeed(post),
                        Container(height: 12, color: ColorStyles.gray20),
                        buildRemandedBuddies(currentPageIndex: (index / 12).floor()),
                      ],
                    );
                  } else {
                    return _buildPostFeed(post);
                  }
                },
                separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
              ),
        ),
      ],
    );
  }

  Widget _buildPostFeed(PostInFeed post) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final Widget? child;

    if (post.imagesUri.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.imagesUri.length,
        itemBuilder: (context, index) =>
            MyNetworkImage(
              imageUri: post.imagesUri[index],
              height: width,
              width: width,
              color: const Color(0xffD9D9D9),
            ),
      );
    } else if (post.tastingRecords.isNotEmpty) {
      child = HorizontalSliderWidget(
        itemLength: post.tastingRecords.length,
        itemBuilder: (context, index) =>
            TastingRecordCard(
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
        childBuilder: (context, index) =>
            buildOpenableTastingRecordDetailView(
              id: post.tastingRecords[index].id,
              closeBuilder: (context, _) =>
                  Container(
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
        context.read<HomePostPresenter>().onTappedFollowButton(post);
      },
      isLiked: post.isLiked,
      likeCount: '${post.likeCount > 999 ? '999+' : post.likeCount}',
      isLeaveComment: post.isLeaveComment,
      commentsCount: '${post.commentsCount > 999 ? '999+' : post.commentsCount}',
      isSaved: post.isSaved,
      onTapLikeButton: () {
        context.read<HomePostPresenter>().onTappedLikeButton(post);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: true, id: post.id, author: post.author);
      },
      onTapSaveButton: () {
        context.read<HomePostPresenter>().onTappedSavedButton(post);
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

  SliverAppBar buildListViewTitle({required List<String> filters, required int currentFilterIndex}) {
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
              filters.length + 1,
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
                      return context.read<HomePostPresenter>().onChangeSubject(index - 1);
                    },
                    text: filters[index - 1],
                    style: index - 1 == currentFilterIndex
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
