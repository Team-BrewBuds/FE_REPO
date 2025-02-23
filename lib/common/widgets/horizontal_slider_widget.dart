import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HorizontalSliderWidget extends StatefulWidget {
  final int itemLength;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? childBuilder;

  const HorizontalSliderWidget({
    super.key,
    required this.itemLength,
    required this.itemBuilder,
    this.childBuilder,
  });

  @override
  State<HorizontalSliderWidget> createState() => _HorizontalSliderWidgetState();
}

class _HorizontalSliderWidgetState extends State<HorizontalSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    final childBuilder = widget.childBuilder;
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: CarouselSlider.builder(
                  itemCount: widget.itemLength,
                  itemBuilder: (context, _, index) => widget.itemBuilder(context, index),
                  options: CarouselOptions(
                    aspectRatio: 1,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              if (widget.itemLength > 1)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildIndicator(),
                ),
            ],
          ),
        ),
        if (childBuilder != null) childBuilder.call(context, currentIndex),
        widget.itemLength > 1
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(child: _buildAnimatedSmoothIndicator()),
              )
            : const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: ColorStyles.black70,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '${currentIndex + 1}/${widget.itemLength}',
        style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.white),
      ),
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: widget.itemLength, // Replace count
        axisDirection: Axis.horizontal,
        effect: const ScrollingDotsEffect(
          dotHeight: 6,
          dotWidth: 6,
          strokeWidth: 0,
          activeStrokeWidth: 0,
          spacing: 4,
          dotColor: ColorStyles.gray60,
          activeDotColor: ColorStyles.red,
        ),
      ),
    );
  }
}
