import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/home/core/home_view_mixin.dart';
import 'package:brew_buds/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_feed.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
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
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildRefreshWidget(),
        Selector<HomeTastingRecordPresenter, DefaultPage<TastingRecordInFeed>>(
          selector: (context, presenter) => presenter.page,
          builder: (context, page, child) => SliverList.separated(
            itemCount: page.result.length,
            itemBuilder: (context, index) {
              final tastingRecord = page.result[index];

              if (index % 12 == 11) {
                return Column(
                  children: [
                    _buildTastingRecordFeed(tastingRecord),
                    Container(height: 12, color: ColorStyles.gray20),
                    buildRemandedBuddies(currentPageIndex: (index / 12).floor()),
                  ],
                );
              } else {
                return _buildTastingRecordFeed(tastingRecord);
              }
            },
            separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
          ),
        ),
      ],
    );
  }

  Widget _buildTastingRecordFeed(TastingRecordInFeed tastingRecord) {
    return TastingRecordFeed(
      id: tastingRecord.id,
      writerThumbnailUri: tastingRecord.author.profileImageUri,
      writerNickName: tastingRecord.author.nickname,
      writingTime: tastingRecord.createdAt,
      hits: '조회 ${tastingRecord.viewCount}',
      isFollowed: tastingRecord.isUserFollowing,
      onTapProfile: () {
        pushToProfile(context: context, id: tastingRecord.author.id);
      },
      onTapFollowButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedFollowButton(tastingRecord);
      },
      isLiked: tastingRecord.isLiked,
      likeCount: '${tastingRecord.likeCount > 999 ? '999+' : tastingRecord.likeCount}',
      isLeaveComment: tastingRecord.isLeaveComment,
      commentsCount: '${tastingRecord.commentsCount > 999 ? '999+' : tastingRecord.commentsCount}',
      isSaved: tastingRecord.isSaved,
      onTapLikeButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedLikeButton(tastingRecord);
      },
      onTapCommentsButton: () {
        showCommentsBottomSheet(isPost: false, id: tastingRecord.id, author: tastingRecord.author);
      },
      onTapSaveButton: () {
        context.read<HomeTastingRecordPresenter>().onTappedSavedButton(tastingRecord);
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
