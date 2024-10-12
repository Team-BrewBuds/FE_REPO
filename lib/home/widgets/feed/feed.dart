import 'package:brew_buds/common/icon_button_factory.dart';
import 'package:brew_buds/common/text_button_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/home/widgets/follow_button.dart';
import 'package:brew_buds/home/widgets/home_tag.dart';
import 'package:brew_buds/home/widgets/list_view_indicator.dart';
import 'package:brew_buds/home/widgets/tasting_record_card_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

part 'feed_bottom_buttons.dart';

part 'feed_profile.dart';

part 'feed_post.dart';

part 'feed_tasting_record.dart';

part 'feed_body.dart';

class Feed extends StatefulWidget {
  final FeedProfile profile;
  final FeedBody body;
  final FeedBottomButtons bottomButtons;

  const Feed({
    super.key,
    required this.profile,
    required this.body,
    required this.bottomButtons,
  });

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      decoration: BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.profile,
          const SizedBox(height: 16),
          _buildBody(),
          const SizedBox(height: 12),
          widget.bottomButtons,
        ],
      ),
    );
  }

  Widget _buildBody() {
    final body = widget.body;
    if (body is PostWithImagesBody) {
      return _buildBodyWithImagesListView(body);
    } else if (body is PostWithSharedTastingRecordsBody) {
      return _buildBodyWithSharedTastingRecordsListView(body);
    } else if (body is PostBody) {
      return FeedPost(
        title: body.title,
        bodyText: body.bodyText,
        bodyTextMaxLines: 5,
        onTapMoreButton: body.onTapMoreButton,
      );
    } else if (body is TastingRecordBody) {
      return FeedTastingRecord(
        imageUri: body.imageUri,
        gPA: body.gPA,
        type: body.type,
        name: body.name,
        tags: body.tags,
        bodyText: body.bodyText,
        onTapMoreButton: body.onTapMoreButton,
      );
    } else {
      return Container();
    }
  }

  Widget _buildBodyWithImagesListView(PostWithImagesBody postWithImagesBody) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    final isVisibleIndicator = postWithImagesBody.itemLength > 1;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildCarouselSliderView(
                  itemLength: postWithImagesBody.itemLength,
                  imageBuilder: postWithImagesBody.imageBuilder,
                ),
              ),
              Visibility(
                visible: isVisibleIndicator,
                child: Positioned(
                  top: 16,
                  right: 16,
                  child: _buildIndicators(maxLength: postWithImagesBody.itemLength),
                ),
              ),
              Visibility(
                visible: isVisibleIndicator,
                child: Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: _buildAnimatedSmoothIndicator(maxLength: postWithImagesBody.itemLength),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FeedPost(
          title: postWithImagesBody.title,
          bodyText: postWithImagesBody.bodyText,
          bodyTextMaxLines: 2,
          onTapMoreButton: postWithImagesBody.onTapMoreButton,
        ),
      ],
    );
  }

  Widget _buildBodyWithSharedTastingRecordsListView(PostWithSharedTastingRecordsBody postWithSharedTastingRecordsBody) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    final isVisibleIndicator = postWithSharedTastingRecordsBody.itemLength > 1;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildCarouselSliderView(
                  itemLength: postWithSharedTastingRecordsBody.itemLength,
                  imageBuilder: postWithSharedTastingRecordsBody.tastingRecordBuilder,
                ),
              ),
              Visibility(
                visible: isVisibleIndicator,
                child: Positioned(
                  top: 16,
                  right: 16,
                  child: _buildIndicators(maxLength: postWithSharedTastingRecordsBody.itemLength),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: ColorStyles.white,
          child: postWithSharedTastingRecordsBody.tastingRecordButtonBuilder.call(context, currentIndex),
        ),
        Visibility(
          visible: isVisibleIndicator,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(child: _buildAnimatedSmoothIndicator(maxLength: postWithSharedTastingRecordsBody.itemLength)),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselSliderView({
    required int itemLength,
    required Widget Function(BuildContext context, int currentIndex) imageBuilder,
  }) {
    return CarouselSlider.builder(
      itemCount: itemLength,
      itemBuilder: (context, _, currentIndex) => imageBuilder(context, currentIndex),
      options: CarouselOptions(
        aspectRatio: 1,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        initialPage: currentIndex,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIndicators({required int maxLength}) {
    return ListViewIndicator(currentIndex: currentIndex + 1, maximumIndex: maxLength);
  }

  Widget _buildAnimatedSmoothIndicator({required int maxLength}) {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: maxLength, // Replace count
        axisDirection: Axis.horizontal,
        effect: const ScrollingDotsEffect(
          dotHeight: 7,
          dotWidth: 7,
          spacing: 4,
          dotColor: ColorStyles.gray60,
          activeDotColor: ColorStyles.red,
        ),
      ),
    );
  }
}
