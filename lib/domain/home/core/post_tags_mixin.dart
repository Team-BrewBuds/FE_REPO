import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

mixin PostSubjectMixin<T extends StatefulWidget> on State<T> {
  List<String> appbarPostSubjectList = ['전체', '일반', '카페', '원두', '정보', '질문', '고민'];
  int currentTagIndex = 0;

  Widget buildPostTagsTapBar() {
    return Row(
      children: appbarPostSubjectList.indexed
          .map(
            (kind) => GestureDetector(
              onTap: () {
                onTagChanged(kind.$1);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: currentTagIndex == kind.$1
                    ? const BoxDecoration(
                        color: ColorStyles.black,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )
                    : BoxDecoration(
                        border: Border.all(color: ColorStyles.gray70),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                child: Text(
                  kind.$2,
                  style: TextStyles.labelMediumMedium.copyWith(
                    color: currentTagIndex == kind.$1 ? ColorStyles.white : ColorStyles.gray70,
                  ),
                ),
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
