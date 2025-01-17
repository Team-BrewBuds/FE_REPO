import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:flutter/material.dart';

mixin PostTagsMixin<T extends StatefulWidget> on State<T> {
  List<String> appbarPostTags = ['전체', '일반', '카페', '원두', '정보', '질문', '고민'];
  int currentTagIndex = 0;

  Widget buildPostTagsTapBar() {
    return Row(
      children: appbarPostTags.indexed
          .map(
            (kind) => ButtonFactory.buildOvalButton(
              onTapped: () => onTagChanged(kind.$1),
              text: kind.$2,
              style: kind.$1 == currentTagIndex
                  ? OvalButtonStyle.fill(
                      color: ColorStyles.black,
                      textColor: ColorStyles.white,
                      size: OvalButtonSize.medium,
                    )
                  : OvalButtonStyle.line(
                      color: ColorStyles.gray70,
                      textColor: ColorStyles.gray70,
                      size: OvalButtonSize.medium,
                    ),
            ),
          )
          .separator(separatorWidget: const SizedBox(width: 6))
          .toList(),
    );
  }

  onTagChanged(int index) {
    setState(() {
      currentTagIndex = index;
    });
  }
}
