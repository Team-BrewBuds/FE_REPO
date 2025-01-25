import 'dart:math';

import 'package:brew_buds/common/extension/iterator_widget_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../provider/coffee_note_presenter.dart';

class WdgtBottomSheetSelect extends StatefulWidget {
  final String title;

  const WdgtBottomSheetSelect({super.key, required this.title});

  @override
  State<WdgtBottomSheetSelect> createState() => _WdgtBottomSheetSelectState();
}

class _WdgtBottomSheetSelectState extends State<WdgtBottomSheetSelect> {
  void _showToast(String message, {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
            textAlign: TextAlign.center,
            message,
            style: TextStyles.captionMediumNarrowMedium),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeNotePresenter>(builder: (context, presenter, _) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // 전체 Row를 가로로 중앙 정렬
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                    style: TextStyles.title02SemiBold,
                  ),
                ),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/icons/x.svg'))
              ],
            ),

            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 0.5,
            ),
            _buildOriginFilter(presenter)

            // _buildSubjectList(),
          ],
        ),
      );
    });
  }
}

Widget _buildOriginFilter(CoffeeNotePresenter presenter) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 24, right: 16, left: 16, bottom: 32),
        child: Column(
          children: presenter.flavor
              .map(
                (flavor) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flavor.toString(),
                      style: TextStyles.title01SemiBold,
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List<Widget>.generate(
                        (flavor.beanFlavor().length / 5).ceil(),
                        (columnIndex) => Row(
                          children: List<Widget>.generate(
                            min(6,
                                flavor.beanFlavor().length - (columnIndex * 5)),
                            (rowIndex) => InkWell(
                              onTap: () {
                                presenter.onSelectTasteFlavor(flavor
                                    .beanFlavor()[columnIndex * 5 + rowIndex]
                                    .toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: presenter.tasteFlaver.contains(flavor
                                            .beanFlavor()[
                                                columnIndex * 5 + rowIndex]
                                            .toString())
                                        ? ColorStyles.background
                                        : ColorStyles.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: presenter.tasteFlaver.contains(
                                              flavor
                                                  .beanFlavor()[
                                                      columnIndex * 5 +
                                                          rowIndex]
                                                  .toString())
                                          ? ColorStyles.red
                                          : ColorStyles.gray50,
                                      width: 1,
                                    )),
                                child: Text(
                                  flavor
                                      .beanFlavor()[columnIndex * 5 + rowIndex]
                                      .toString(),
                                  style:
                                      TextStyles.captionMediumMedium.copyWith(
                                    color: presenter.tasteFlaver.contains(flavor
                                            .beanFlavor()[
                                                columnIndex * 5 + rowIndex]
                                            .toString())
                                        ? ColorStyles.red
                                        : ColorStyles.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                              .separator(
                                  separatorWidget: const SizedBox(width: 8))
                              .toList(),
                        ),
                      )
                          .separator(separatorWidget: const SizedBox(height: 8))
                          .toList(),
                    )
                  ],
                ),
              )
              .separator(separatorWidget: const SizedBox(height: 16))
              .toList(),
        ),
      ),
      SizedBox(
        height: 12,
      ),
      presenter.tasteFlaver.isNotEmpty
          ? Container(
              height: 50,
              color: ColorStyles.gray10,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: presenter.tasteFlaver.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0), // 텍스트 주위에 여백을 추가
                        decoration: BoxDecoration(
                          color: ColorStyles.black, // 배경색
                          borderRadius: BorderRadius.circular(20), // 둥근 모서리
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              presenter.tasteFlaver[index],
                              style: TextStyles.labelSmallSemiBold
                                  .copyWith(color: ColorStyles.white),
                            ),
                            const SizedBox(width: 2),
                            InkWell(
                              onTap: () {
                                presenter.onSelectTasteFlavor(
                                    presenter.tasteFlaver[index]);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/x.svg',
                                width: 12,
                                height: 12,
                                fit: BoxFit.cover,
                                colorFilter: const ColorFilter.mode(
                                    ColorStyles.white, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 4,
                      );
                    },
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
      Padding(
        padding: EdgeInsets.only(top: 14, bottom: 46, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonFactory.buildRoundedButton(
                onTapped: () {},
                text: '초기화',
                style: RoundedButtonStyle.fill(
                    color: ColorStyles.gray30,
                    size: RoundedButtonSize.xSmall,
                    textColor: ColorStyles.black)),
            SizedBox(
              width: 10,
            ),
            ButtonFactory.buildRoundedButton(
                onTapped: () {},
                text: '선택하기',
                style: RoundedButtonStyle.fill(
                    color: ColorStyles.black,
                    size: RoundedButtonSize.large,
                    textColor: ColorStyles.white))
          ],
        ),
      )
    ],
  );
}
