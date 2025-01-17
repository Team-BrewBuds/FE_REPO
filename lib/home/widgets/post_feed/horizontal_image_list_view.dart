import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/home/widgets/slider_view.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HorizontalImageListView extends StatefulWidget {
  final List<String> imagesUrl;

  const HorizontalImageListView({
    super.key,
    required this.imagesUrl,
  });

  @override
  State<HorizontalImageListView> createState() => _HorizontalImageListViewState();
}

class _HorizontalImageListViewState extends State<HorizontalImageListView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: SliderView(
            itemLength: widget.imagesUrl.length,
            itemBuilder: (context, index) => Image.network(
              widget.imagesUrl[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Text(
                  '이미지를 불러오는데 실패했습니다.',
                  style: TextStyles.title02SemiBold,
                ),
              ),
            ),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        widget.imagesUrl.length > 1
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(child: _buildAnimatedSmoothIndicator()),
              )
            : const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: widget.imagesUrl.length, // Replace count
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
