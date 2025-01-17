import 'package:brew_buds/common/styles/color_styles.dart';
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
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          Positioned.fill(
            child: SliderView(
              itemLength: widget.imagesUrl.length,
              itemBuilder: (context, index) => Image.network(widget.imagesUrl[index], fit: BoxFit.cover),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          Visibility(
            visible: widget.imagesUrl.length > 1,
            child: Positioned(left: 0, right: 0, bottom: 16, child: _buildAnimatedSmoothIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: currentIndex,
        count: widget.imagesUrl.length, // Replace count
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
}
