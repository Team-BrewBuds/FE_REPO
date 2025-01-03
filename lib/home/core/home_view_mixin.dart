import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/home/comments/comments_presenter.dart';
import 'package:brew_buds/home/comments/comments_view.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/home/widgets/follow_button.dart';
import 'package:brew_buds/model/user.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HomeViewMixin<T extends StatefulWidget, Presenter extends HomeViewPresenter> on State<T> {
  late final Throttle paginationThrottle;
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollListener);
      context.read<Presenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    paginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    final presenter = context.read<Presenter>();
    if (presenter.feeds.length - currentIndex < 4 && presenter.hasNext) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<Presenter>().fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Presenter>(builder: (context, presenter, _) {
      return Container(
        color: ColorStyles.gray20,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            buildListViewTitle(presenter),
            buildRefreshWidget(presenter),
            buildListView(presenter),
          ],
        ),
      );
    });
  }

  SliverAppBar buildListViewTitle(Presenter presenter) => const SliverAppBar(toolbarHeight: 0);

  Widget buildListItem(Presenter presenter, int index);

  Widget buildRefreshWidget(Presenter presenter) {
    return CupertinoSliverRefreshControl(
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
    );
  }

  SliverList buildListView(Presenter presenter) {
    return SliverList.separated(
      itemCount: presenter.feeds.length,
      itemBuilder: (context, index) {
        currentIndex = index;
        if (index % 12 == 11) {
          return Column(
            children: [
              buildListItem(presenter, index),
              Container(height: 12, color: ColorStyles.gray20),
              _buildRemandedBuddies(presenter, (index / 12).floor()),
            ],
          );
        } else {
          return buildListItem(presenter, index);
        }
      },
      separatorBuilder: (context, index) => buildSeparatorWidget(index),
    );
  }

  Widget buildSeparatorWidget(int index) {
    return Container(height: 12, color: ColorStyles.gray20);
  }

  Widget _buildRemandedBuddies(Presenter presenter, int recommendedIndex) {
    if (presenter.recommendedUserPages.length > recommendedIndex) {
      final page = presenter.recommendedUserPages[recommendedIndex];
      return Container(
        height: 304,
        color: ColorStyles.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(page.category.title(), style: TextStyles.title01SemiBold),
            Text(
              page.category.contents(),
              style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray70),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: page.users.length,
                itemBuilder: (context, index) => _buildRemandedBuddyProfile(
                  imageUri: page.users[index].user.profileImageUri,
                  nickName: page.users[index].user.nickname,
                  followCount: '${page.users[index].followerCount}',
                  isFollowed: false,
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
            ),
          ],
        ),
      );
    } else {
      presenter.fetchMoreRecommendedUsers();
      return Container();
    }
  }

  Widget _buildRemandedBuddyProfile({
    required String imageUri,
    required String nickName,
    required String followCount,
    required bool isFollowed,
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
          Container(
            height: 80,
            width: 80,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xffD9D9D9),
              shape: BoxShape.circle,
            ),
            child: Image.network(imageUri, fit: BoxFit.cover),
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
          FollowButton(onTap: () {}, isFollowed: isFollowed),
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
                  repository: CommentsRepository.instance,
                ),
            child: CommentBottomSheet(minimumHeight: MediaQuery.of(context).size.height * 0.7));
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
