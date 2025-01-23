import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  final int itemLength;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(int index)? onPageChanged;

  const SliderView({
    super.key,
    required this.itemLength,
    required this.itemBuilder,
    this.onPageChanged,
  });

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  int currentIndex = 0;

  bool get isVisibleIndicator => widget.itemLength > 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                widget.onPageChanged?.call(index);
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
        Visibility(
          visible: isVisibleIndicator,
          child: Positioned(
            top: 16,
            right: 16,
            child: _buildIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    if (currentIndex > widget.itemLength || currentIndex < 0 || widget.itemLength < 1) {
      return Container();
    } else {
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
  }
}
