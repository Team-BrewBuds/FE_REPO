import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/core/post_tags_mixin.dart';
import 'package:brew_buds/home/popular_posts/popular_post.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPostsView extends StatefulWidget {
  const PopularPostsView({super.key});

  @override
  State<PopularPostsView> createState() => _PopularPostsViewState();
}

class _PopularPostsViewState extends State<PopularPostsView>
    with HomeViewMixin<PopularPostsView, PopularPostsPresenter>, PostTagsMixin<PopularPostsView> {
  @override
  bool get isShowRemandedBuddies => false;

  @override
  Widget buildListItem(PopularPostsPresenter presenter, int index) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        border: Border.all(color: ColorStyles.gray20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PopularPost(
              title: '바스켓 크기에 따라서 맛 차이가 나나요?',
              bodyText: '대충 내려서 맛있게 즐기고 있었는데 다른 곳 오니까 맛은 좋더라구요 어쩌구 저쩌구 어쩌구 저쩌구 어쩌구 저쩌구  어쩌구 저쩌구 어쩌구 저쩌구  어쩌구 저쩌구 어쩌구 저쩌구 ',
              likeCount: '30',
              isLiked: true,
              commentsCount: '30',
              hasComment: false,
              tag: '정보',
              writingTime: '3시간전',
              hitsCount: '조회 9999+',
              nickName: '커피의 신',
              onTap: () {},
              onTapLikeButton: () {},
              onTapCommentButton: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 80,
            width: 80,
            color: Colors.red,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 인기글'),
        titleSpacing: 0,
        centerTitle: true,
        titleTextStyle: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
      ),
      body: Consumer<PopularPostsPresenter>(
        builder: (context, presenter, _) {
          return Container(
            color: ColorStyles.gray20,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                buildListViewTitle(presenter),
                buildRefreshWidget(presenter),
                buildListView(presenter),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        '주간 인기글을 모두 읽었어요',
                        style: TextStyles.labelMediumMedium.copyWith(
                          color: ColorStyles.gray60,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  SliverAppBar buildListViewTitle(PopularPostsPresenter presenter) {
    return SliverAppBar(
      leading: Container(),
      leadingWidth: 0,
      titleSpacing: 0,
      floating: true,
      title: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        scrollDirection: Axis.horizontal,
        child: buildPostTagsTapBar(),
      ),
    );
  }

  @override
  Widget buildSeparatorWidget(int index) => Container();
}
