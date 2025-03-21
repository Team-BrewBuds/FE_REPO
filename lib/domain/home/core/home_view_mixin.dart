import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/home/comments/comments_presenter.dart';
import 'package:brew_buds/domain/home/comments/comments_view.dart';
import 'package:brew_buds/domain/home/core/home_view_presenter.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HomeViewMixin<T extends StatefulWidget, Presenter extends HomeViewPresenter> on State<T> {
  late final Throttle paginationThrottle;
  late final Throttle recommendedPaginationThrottle;
  late final ScrollController scrollController;
  int currentIndex = 0;
  bool isLoading = false;

  bool get isShowRemandedBuddies => true;

  @override
  void initState() {
    super.initState();
    paginationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );

    recommendedPaginationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMorRecommendedUsers();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollListener);
      context.read<Presenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    paginationThrottle.cancel();
    recommendedPaginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
      recommendedPaginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<Presenter>().fetchMoreData();
  }

  _fetchMorRecommendedUsers() {
    context.read<Presenter>().fetchMoreRecommendedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Presenter>(builder: (context, presenter, _) {
      return Container(
        color: ColorStyles.gray20,
        child: buildBody(context),
      );
    });
  }

  Widget buildBody(BuildContext context);

  Widget buildRefreshWidget() {
    return CupertinoSliverRefreshControl(
      onRefresh: () {
        return context.read<Presenter>().onRefresh();
      },
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
    );
  }

  Widget buildRemandedBuddies({required int currentPageIndex}) {
    return Selector<Presenter, RecommendedPage?>(
        selector: (context, presenter) => presenter.getRecommendedPage(currentPageIndex),
        builder: (context, recommendedUserPage, child) {
          final currentPage = recommendedUserPage;
          if (currentPage != null) {
            return Container(
              height: 304,
              color: ColorStyles.white,
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(currentPage.category.title(), style: TextStyles.title01SemiBold),
                  Text(
                    currentPage.category.contents(),
                    style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: currentPage.users.length,
                      itemBuilder: (context, index) {
                        final remandedBuddy = currentPage.users[index];
                        return buildRemandedBuddyProfile(
                          imageUrl: remandedBuddy.profileImageUrl,
                          nickName: remandedBuddy.nickname,
                          followCount: '${remandedBuddy.followerCount}',
                          isFollowed: remandedBuddy.isFollow,
                          onTappedFollowButton: () {
                            context.read<Presenter>().onTappedRecommendedUserFollowButton(
                                  remandedBuddy,
                                  currentPageIndex,
                                );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                    ),
                  ),
                ],
              ),
            );
          } else {
            recommendedPaginationThrottle.setValue(null);
            return const SizedBox.shrink();
          }
        });
  }

  Widget buildRemandedBuddyProfile({
    required String imageUrl,
    required String nickName,
    required String followCount,
    required bool isFollowed,
    required Function() onTappedFollowButton,
  }) {
    return Container(
      width: 134,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        border: Border.all(color: ColorStyles.gray20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          MyNetworkImage(
            imageUrl: imageUrl,
            height: 80,
            width: 80,
            shape: BoxShape.circle,
          ),
          const SizedBox(height: 12),
          Text(
            nickName,
            style: TextStyles.labelSmallSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            followCount,
            style: TextStyles.labelSmallSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          FollowButton(
            onTap: () {
              onTappedFollowButton.call();
            },
            isFollowed: isFollowed,
          ),
        ],
      ),
    );
  }

  showCommentsBottomSheet({required bool isPost, required int id, required User author}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider<CommentsPresenter>(
          create: (_) => CommentsPresenter(
            isPost: isPost,
            id: id,
            author: author,
            accountRepository: AccountRepository.instance,
            repository: CommentsRepository.instance,
          ),
          child: CommentBottomSheet(minimumHeight: MediaQuery.of(context).size.height * 0.7),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black.withOpacity(0.9),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
