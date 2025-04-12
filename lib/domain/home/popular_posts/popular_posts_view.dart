import 'dart:ui';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/domain/detail/post/post_detail_presenter.dart';
import 'package:brew_buds/domain/detail/post/post_detail_view.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_presenter.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPostsView extends StatefulWidget {
  const PopularPostsView({super.key});

  @override
  State<PopularPostsView> createState() => _PopularPostsViewState();
}

class _PopularPostsViewState extends State<PopularPostsView> with SnackBarMixin<PopularPostsView> {
  late final Throttle<bool> pageNationThrottle;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        _scrollListener();
      });
    pageNationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: false,
      onChanged: (value) {
        if (value) {
          _fetchMoreData();
        }
      },
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PopularPostsPresenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {
      _scrollListener();
    });
    scrollController.dispose();
    pageNationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent * 0.7) {
      pageNationThrottle.setValue(true);
    }
  }

  _fetchMoreData() {
    context.read<PopularPostsPresenter>().fetchMoreData();
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
      body: Container(
        color: ColorStyles.gray20,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            buildSubjectFilter(),
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 56,
              refreshIndicatorExtent: 56,
              builder: (
                  BuildContext context,
                  RefreshIndicatorMode refreshState,
                  double pulledExtent,
                  double refreshTriggerPullDistance,
                  double refreshIndicatorExtent,
                  ) {
                switch (refreshState) {
                  case RefreshIndicatorMode.drag:
                    final double percentageComplete = clampDouble(
                      pulledExtent / refreshTriggerPullDistance,
                      0.0,
                      1.0,
                    );
                    const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
                    return Opacity(
                      opacity: opacityCurve.transform(percentageComplete),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CupertinoActivityIndicator.partiallyRevealed(
                              progress: percentageComplete,
                              color: ColorStyles.gray70,
                            ),
                          ),
                        ),
                      ),
                    );
                  case RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh:
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                        ),
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
              onRefresh: () {
                return context.read<PopularPostsPresenter>().onRefresh();
              },
            ),
            Selector<PopularPostsPresenter, DefaultPage<Post>>(
              selector: (context, presenter) => presenter.page,
              builder: (context, page, child) {
                return SliverList.separated(
                  itemCount: page.results.length,
                  itemBuilder: (context, index) {
                    final popularPost = page.results[index];
                    return ThrottleButton(
                      onTap: () {
                        showCupertinoModalPopup<String>(
                          barrierColor: ColorStyles.white,
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider<PostDetailPresenter>(
                              create: (_) => PostDetailPresenter(id: popularPost.id),
                              child: const PostDetailView(),
                            );
                          },
                        ).then((result) {
                          if (result != null) {
                            showSnackBar(message: result);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
                        color: ColorStyles.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PopularPostWidget(
                                title: popularPost.title,
                                bodyText: popularPost.contents,
                                likeCount: '${popularPost.likeCount > 999 ? '999+' : popularPost.likeCount}',
                                isLiked: popularPost.isLiked,
                                commentsCount:
                                    '${popularPost.commentsCount > 999 ? '999+' : popularPost.commentsCount}',
                                hasComment: false,
                                tag: popularPost.subject.toString(),
                                writingTime: popularPost.createdAt,
                                hitsCount: '조회 ${popularPost.viewCount > 9999 ? '9999+' : popularPost.viewCount}',
                                nickName: popularPost.author.nickname,
                                imageUrl: popularPost.imagesUrl.firstOrNull,
                              ),
                            ),
                            SizedBox(width: popularPost.imagesUrl.isNotEmpty ? 8 : 0),
                            popularPost.imagesUrl.isNotEmpty
                                ? MyNetworkImage(
                                    imageUrl: popularPost.imagesUrl.first,
                                    height: 80,
                                    width: 80,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
                );
              },
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
      ),
    );
  }

  SliverAppBar buildSubjectFilter() {
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
          child: Selector<PopularPostsPresenter, PopularPostSubjectFilterState>(
              selector: (context, presenter) => presenter.subjectFilterState,
              builder: (context, subjectFilterState, child) {
                return Row(
                  spacing: 6,
                  children: List<Widget>.generate(
                    subjectFilterState.postSubjectFilterList.length,
                    (index) {
                      return ThrottleButton(
                        onTap: () {
                          scrollController.jumpTo(0);
                          context.read<PopularPostsPresenter>().onChangeSubject(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: index == subjectFilterState.currentIndex
                              ? const BoxDecoration(
                                  color: ColorStyles.black,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                )
                              : BoxDecoration(
                                  border: Border.all(color: ColorStyles.gray70),
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                          child: Text(
                            subjectFilterState.postSubjectFilterList[index],
                            style: TextStyles.labelMediumMedium.copyWith(
                              color: index == subjectFilterState.currentIndex ? ColorStyles.white : ColorStyles.gray70,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                );
              }),
        ),
      ),
    );
  }
}
