import 'package:flutter/material.dart';

import 'color_styles.dart';

class DraggableIndicator extends StatelessWidget {
  const DraggableIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 5,
      decoration: BoxDecoration(
        color: ColorStyles.barColor,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}