import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/home/widgets/slider_view.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_button.dart';
import 'package:brew_buds/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

typedef TastingRecordListViewItem = ({
  String beanName,
  String beanType,
  String contents,
  double rating,
  List<String> flavors,
  String imageUri,
  void Function() onTap,
});

class HorizontalTastingRecordListView extends StatefulWidget {
  final List<TastingRecordListViewItem> items;

  const HorizontalTastingRecordListView({
    super.key,
    required this.items,
  });

  @override
  State<HorizontalTastingRecordListView> createState() => _HorizontalTastingRecordListViewState();
}

class _HorizontalTastingRecordListViewState extends State<HorizontalTastingRecordListView> {
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
            itemLength: widget.items.length,
            itemBuilder: (context, index) => TastingRecordCard(
              image: Image.network(
                widget.items[index].imageUri,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Text(
                    '이미지를 불러오는데 실패했습니다.',
                    style: TextStyles.title02SemiBold,
                  ),
                ),
              ),
              rating: '${widget.items[index].rating}',
              type: widget.items[index].beanType,
              name: widget.items[index].beanName,
              tags: widget.items[index].flavors,
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
            name: widget.items[currentIndex].beanName,
            bodyText: widget.items[currentIndex].contents,
            onTap: widget.items[currentIndex].onTap,
          ),
        ),
        widget.items.length > 1
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
        count: widget.items.length, // Replace count
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
