import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/home/widgets/follow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HomeViewMixin<T extends StatefulWidget, Presenter extends HomeViewPresenter> on State<T> {
  final ScrollController scrollController = ScrollController();
  bool get isShowRemandedBuddies => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Presenter>().initState();
    });
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
      builder: (BuildContext context,
          RefreshIndicatorMode refreshState,
          double pulledExtent,
          double refreshTriggerPullDistance,
          double refreshIndicatorExtent,) {
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
        if (index % 12 == 11 && isShowRemandedBuddies) {
          return Column(
            children: [
              buildListItem(presenter, index),
              Container(height: 12, color: ColorStyles.gray20),
              _buildRemandedBuddies(presenter),
            ],
          );
        } else {
          return buildListItem(presenter, index);
        }
      },
      separatorBuilder: (context, index) => buildSeparatorWidget(index),
    );
  }

  Widget buildSeparatorWidget(int index) => Container(height: 12, color: ColorStyles.gray20);

  Widget _buildRemandedBuddies(Presenter presenter) {
    return Container(
      height: 300,
      color: ColorStyles.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('카페 투어를 즐기는 버디', style: TextStyles.title01SemiBold),
          Text('오늘은 새로운 버디와 카페 투어 어때요?', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray70),),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: presenter.remandedUsers.length,
              itemBuilder: (context, index) =>
                  _buildRemandedBuddyProfile(
                    imageUri: presenter.remandedUsers[index].thumbnailUri,
                    nickName: presenter.remandedUsers[index].nickName,
                    followCount: '${presenter.remandedUsers[index].followCount}',
                    isFollowed: presenter.remandedUsers[index].isFollowed,
                  ),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            ),
          ),
        ],
      ),
    );
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
}


