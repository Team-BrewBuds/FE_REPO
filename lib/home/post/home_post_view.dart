import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/core/post_tags_mixin.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePostView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomePostView({super.key, this.scrollController});

  @override
  State<HomePostView> createState() => _HomePostViewState();
}

class _HomePostViewState extends State<HomePostView>
    with HomeViewMixin<HomePostView, HomePostPresenter>, PostTagsMixin<HomePostView> {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  Widget buildListItem(HomePostPresenter presenter, int index) {
    final post = presenter.feeds[index];

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

  @override
  SliverAppBar buildListViewTitle(HomePostPresenter presenter) {
    return SliverAppBar(
      titleSpacing: 0,
      floating: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: Row(
          children: [
            ButtonFactory.buildOvalButton(
              onTapped: () => GoRouter.of(context).push('/popular_post'),
              text: '인기',
              style: OvalButtonStyle.line(
                color: ColorStyles.red,
                textColor: ColorStyles.red,
                size: OvalButtonSize.medium,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 1,
              height: 20,
              color: ColorStyles.gray40,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 6, right: 16),
                scrollDirection: Axis.horizontal,
                child: buildPostTagsTapBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
