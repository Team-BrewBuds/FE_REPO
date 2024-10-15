import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_button_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/widgets/feed_widget.dart';
import 'package:brew_buds/home/widgets/post_feed/post_contents_type.dart';
import 'package:brew_buds/home/widgets/slider_view.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_button.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostFeed extends FeedWidget {
  final String title;
  final String body;
  final String tagText;
  final Widget tagIcon;
  final void Function() onTapMoreButton;
  final PostContentsType postContentsType;

  @override
  FeedWidgetState createState() => _PostFeedState();

  const PostFeed({
    super.key,
    required super.writerThumbnailUri,
    required super.writerNickName,
    required super.writingTime,
    required super.hits,
    required super.isFollowed,
    required super.onTapProfile,
    required super.onTapFollowButton,
    required super.isLiked,
    required super.likeCount,
    required super.isLeaveComment,
    required super.commentsCount,
    required super.isSaved,
    required super.onTapLikeButton,
    required super.onTapCommentsButton,
    required super.onTapSaveButton,
    required this.title,
    required this.body,
    required this.tagText,
    required this.tagIcon,
    required this.onTapMoreButton,
    required this.postContentsType,
  });
}

class _PostFeedState extends FeedWidgetState<PostFeed> {
  late final int itemLength;
  int currentIndex = 0;

  bool get isVisibleIndicator => itemLength > 1;

  @override
  void initState() {
    super.initState();
    final contentsType = widget.postContentsType;
    itemLength = switch (contentsType) {
      OnlyTextContents() => 0,
      ImagesContents() => contentsType.imageUriList.length,
      TastingRecordContents() => contentsType.sharedTastingRecords.length,
    };
  }

  @override
  Widget buildBody() {
    final contents = widget.postContentsType;

    switch (contents) {
      case OnlyTextContents():
        return _buildTextBody();
      case ImagesContents():
        return Column(
          children: [
            _buildImageSlider(contents),
            _buildTextBody(bodyMaxLines: 2),
          ],
        );
      case TastingRecordContents():
        return Column(
          children: [
            _buildTextBody(bodyMaxLines: 2),
            _buildSharedTastingRecordsListView(contents),
          ],
        );
    }
  }

  Widget _buildTextBody({int bodyMaxLines = 5}) {
    final isOverFlow = _calcOverFlow(bodyMaxLines);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_buildTag(), const Spacer()],
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            widget.title,
            style: TextStyles.titleMediumSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            widget.body,
            style: TextStyles.labelMediumRegular,
            maxLines: bodyMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isOverFlow ? 8 : 0),
          isOverFlow
              ? TextButtonFactory.build(
                  onTapped: widget.onTapMoreButton,
                  style: TextButtonStyle(size: TextButtonSize.small),
                  text: '더보기',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildImageSlider(ImagesContents imageContents) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Positioned.fill(
            child: SliderView(
              itemLength: itemLength,
              itemBuilder: (context, index) => Image.network(imageContents.imageUriList[index], fit: BoxFit.cover),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          Visibility(
            visible: isVisibleIndicator,
            child: Positioned(left: 0, right: 0, bottom: 16, child: _buildAnimatedSmoothIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildSharedTastingRecordsListView(TastingRecordContents tastingRecordContents) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: SliderView(
            itemLength: itemLength,
            itemBuilder: (context, index) => TastingRecordCard(
              image: Image.network(tastingRecordContents.sharedTastingRecords[index].thumbnailUri, fit: BoxFit.cover),
              rating: '${tastingRecordContents.sharedTastingRecords[index].rating}',
              type: tastingRecordContents.sharedTastingRecords[index].coffeeBeanType,
              name: tastingRecordContents.sharedTastingRecords[index].name,
              tags: tastingRecordContents.sharedTastingRecords[index].tags,
            ),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        Container(
          color: ColorStyles.white,
          child: TastingRecordButton(
            name: tastingRecordContents.sharedTastingRecords[currentIndex].name,
            bodyText: tastingRecordContents.sharedTastingRecords[currentIndex].body,
            onTap: () {},
          ),
        ),
        Visibility(
          visible: isVisibleIndicator,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(child: _buildAnimatedSmoothIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: itemLength, // Replace count
        axisDirection: Axis.horizontal,
        effect: const ExpandingDotsEffect(
          dotHeight: 7,
          dotWidth: 7,
          spacing: 4,
          dotColor: ColorStyles.gray60,
          activeDotColor: ColorStyles.red,
        ),
      ),
    );
  }

  Widget _buildTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SizedBox(height: 12, width: 12, child: widget.tagIcon),
          const SizedBox(width: 2),
          Text(widget.tagText, style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }

  bool _calcOverFlow(int maxLines) {
    final width = MediaQuery.of(context).size.width;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: widget.body, style: TextStyles.labelMediumRegular),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
