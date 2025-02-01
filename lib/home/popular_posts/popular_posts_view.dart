import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/home/popular_posts/popular_post.dart';
import 'package:brew_buds/home/popular_posts/popular_posts_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPostsView extends StatefulWidget {
  const PopularPostsView({super.key});

  @override
  State<PopularPostsView> createState() => _PopularPostsViewState();
}

class _PopularPostsViewState extends State<PopularPostsView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PopularPostsPresenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                CupertinoSliverRefreshControl(
                  onRefresh: presenter.onRefresh,
                  builder: (
                    BuildContext context,
                    RefreshIndicatorMode refreshState,
                    double pulledExtent,
                    double refreshTriggerPullDistance,
                    double refreshIndicatorExtent,
                  ) {
                    switch (refreshState) {
                      case RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh:
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                ),
                SliverList.separated(
                  itemCount: presenter.popularPosts.length,
                  itemBuilder: (context, index) {
                    return buildListItem(presenter, index);
                  },
                  separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray60),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        '주간 인기글을 모두 읽었어요',
                        style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.gray60),
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

  Widget buildListItem(PopularPostsPresenter presenter, int index) {
    final popularPost = presenter.popularPosts[index];
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
              title: popularPost.title,
              bodyText: popularPost.contents,
              likeCount: '${popularPost.likeCount > 999 ? '999+' : popularPost.likeCount}',
              isLiked: popularPost.isLiked,
              commentsCount: '${popularPost.commentsCount > 999 ? '999+' : popularPost.commentsCount}',
              hasComment: false,
              tag: popularPost.subject.toString(),
              writingTime: popularPost.createdAt,
              hitsCount: '조회 ${popularPost.viewCount > 9999 ? '9999+' : popularPost.viewCount}',
              nickName: popularPost.author.nickname,
              imageUri: popularPost.imagesUri.firstOrNull,
              onTap: () {},
              onTapLikeButton: () {},
              onTapCommentButton: () {},
            ),
          ),
          SizedBox(width: popularPost.imagesUri.isNotEmpty ? 8 : 0),
          popularPost.imagesUri.isNotEmpty
              ? SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(
                    popularPost.imagesUri.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => Container(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  SliverAppBar buildListViewTitle(PopularPostsPresenter presenter) {
    return SliverAppBar(
      titleSpacing: 0,
      floating: true,
      leading: Container(),
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List<Widget>.generate(presenter.postSubjectFilterList.length, (index) {
              return ButtonFactory.buildOvalButton(
                onTapped: () {
                  scrollController.jumpTo(0);
                  return presenter.onChangeSubject(index);
                },
                text: presenter.postSubjectFilterList[index],
                style: index == presenter.currentFilterIndex
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
            }).separator(separatorWidget: const SizedBox(width: 6)).toList(),
          ),
        ),
      ),
    );
  }
}
