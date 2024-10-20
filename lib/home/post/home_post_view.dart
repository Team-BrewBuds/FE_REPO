import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/date_time_ext.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/core/post_tags_mixin.dart';
import 'package:brew_buds/home/post/home_post_presenter.dart';
import 'package:brew_buds/home/widgets/post_feed/post_contents_type.dart';
import 'package:brew_buds/home/widgets/post_feed/post_feed.dart';
import 'package:brew_buds/model/post_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePostView extends StatefulWidget {
  const HomePostView({super.key});

  @override
  State<HomePostView> createState() => _HomePostViewState();
}

class _HomePostViewState extends State<HomePostView>
    with HomeViewMixin<HomePostView, HomePostPresenter>, PostTagsMixin<HomePostView> {
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
            SizedBox(width: 6),
            Container(
              width: 1,
              height: 20,
              color: ColorStyles.gray40,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 6, right: 16),
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
