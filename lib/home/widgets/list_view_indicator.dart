import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';

class ListViewIndicator extends StatelessWidget {
  final int currentIndex;
  final int maximumIndex;

  const ListViewIndicator({
    super.key,
    required this.currentIndex,
    required this.maximumIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (currentIndex > maximumIndex || currentIndex < 1 || maximumIndex < 1) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: ColorStyles.black,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          '$currentIndex/$maximumIndex',
          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.white),
        ),
      );
    }
  }
}
