import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_refresh_control.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post_presenter.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_posts_presenter.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularPostsView extends StatefulWidget {
  const PopularPostsView({super.key});

  @override
  State<PopularPostsView> createState() => _PopularPostsViewState();
}

class _PopularPostsViewState extends State<PopularPostsView> {
  late final Throttle<void> pageNationThrottle;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      _scrollListener();
    });
    pageNationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
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
      pageNationThrottle.setValue(null);
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
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: scrollController,
          slivers: [
            buildSubjectFilter(),
            MyRefreshControl(onRefresh: () => context.read<PopularPostsPresenter>().onRefresh()),
            Builder(
              builder: (context) {
                final presenters = context.select<PopularPostsPresenter, List<PopularPostPresenter>>(
                  (presenter) => presenter.presenters,
                );
                return SliverList.separated(
                  itemCount: presenters.length,
                  itemBuilder: (context, index) {
                    final presenter = presenters[index];
                    return ChangeNotifierProvider.value(
                      value: presenter,
                      child: const PopularPostWidget(),
                    );
                  },
                  separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
                );
              },
            ),
            Builder(
              builder: (context) {
                final isLoading = context.select<PopularPostsPresenter, bool>((presenter) => presenter.isLoading);
                final hasNext = context.select<PopularPostsPresenter, bool>((presenter) => presenter.hasNext);
                final isEmpty = context.select<PopularPostsPresenter, bool>(
                  (presenter) => presenter.presenters.isEmpty,
                );
                if (isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: ColorStyles.gray70,
                      ),
                    ),
                  );
                } else if (!isLoading && !isEmpty && hasNext) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: ColorStyles.gray70,
                        ),
                      ),
                    ),
                  );
                } else if (!isLoading && !isEmpty && !hasNext) {
                  return SliverToBoxAdapter(
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
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '주간 인기글을 모두 읽었어요',
                        style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.gray60),
                      ),
                    ),
                  );
                }
              },
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
