import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/home/core/home_view_mixin.dart';
import 'package:brew_buds/domain/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_feed_widget.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTastingRecordView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeTastingRecordView({
    super.key,
    this.scrollController,
  });

  @override
  State<HomeTastingRecordView> createState() => _HomeTastingRecordViewState();
}

class _HomeTastingRecordViewState extends State<HomeTastingRecordView>
    with HomeViewMixin<HomeTastingRecordView, HomeTastingRecordPresenter> {
  @override
  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildRefreshWidget(),
        Selector<HomeTastingRecordPresenter, DefaultPage<TastedRecordInFeed>>(
          selector: (context, presenter) => presenter.defaultPage,
          builder: (context, page, child) => SliverList.separated(
            itemCount: page.results.length,
            itemBuilder: (context, index) {
              final tastingRecord = page.results[index];
              if (index % 12 == 11) {
                return Column(
                  children: [
                    _buildTastingRecordFeed(tastingRecord, index),
                    Container(height: 12, color: ColorStyles.gray20),
                    buildRemandedBuddies(currentPageIndex: (index / 12).floor()),
                  ],
                );
              } else {
                return _buildTastingRecordFeed(tastingRecord, index);
              }
            },
            separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
          ),
        ),
      ],
    );
  }

  Widget _buildTastingRecordFeed(TastedRecordInFeed tastingRecord, int index) {
    return TastingRecordFeedWidget(
      id: tastingRecord.id,
      writerThumbnailUrl: tastingRecord.author.profileImageUrl,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: tastingRecord.isAuthorFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: tastingRecord.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedFollowAt(index);
      },
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedLikeAt(index);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: false, id: tastingRecord.id, author: tastingRecord.author);
      },
      onTapSaveButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedSavedAt(index);
      },
      thumbnailUri: tastingRecord.thumbnailUri,
      rating: '${tastingRecord.rating}',
      type: tastingRecord.beanType,
      name: tastingRecord.beanName,
      tags: tastingRecord.flavors,
      body: tastingRecord.contents,
    );
  }
}
