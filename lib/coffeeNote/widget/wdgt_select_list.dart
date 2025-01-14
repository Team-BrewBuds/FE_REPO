import 'dart:math';

import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_bottom_sheet.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_search_bottom_sheet.dart';
import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/profile/model/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../model/beanInfo.dart';

class WdgtSelectList extends StatefulWidget {
  const WdgtSelectList({super.key});

  @override
  State<WdgtSelectList> createState() => _WdgtSelectListState();
}

class _WdgtSelectListState extends State<WdgtSelectList> {
  late List<bool> _expandedStates;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(7, (index) => false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeNotePresenter>(
      builder: (BuildContext context, presenter, Widget? child) {
        final List<Widget> _widgets = [
          _buildOriginFilter(presenter),
          _buildLoastingPoint(),
          _buildProcess(),
          _buildRegion(context, presenter),
          _buildBevType(),
          Container(
            color: Colors.black,
            height: 30,
          ),
          Container(
            color: Colors.white,
            height: 30,
          ),
        ];

        print(presenter.extractionInfo);
        // print(presenter.extractionInfo.toString());

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _expandedStates.length,
          itemBuilder: (context, index) {
            return listFrame(
              title: presenter.recordTitle[index],
              isExpanded: _expandedStates[index],
              onIconTap: () {
                setState(() {
                  _expandedStates[index] = !_expandedStates[index];
                });
              },
              buildWidget: _widgets[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              color: ColorStyles.gray10, // 배경 색상 설정
              child: Divider(),
            );
          },
        );
      },
    );
  }
}

Widget _buildOriginFilter(
  CoffeeNotePresenter presenter,
) {
  final firstRow = presenter.extractionInfo.sublist(0, 3); // 첫 번째 행
  final secondRow = presenter.extractionInfo.sublist(3); // 두 번째 행
  return SizedBox(
      height: 150,
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: firstRow
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                // 배경색
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color: ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                    color: Colors.black), // 텍스트 스타일
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: secondRow
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color: ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13), // 텍스트 스타일
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () {
                        presenter.onClick();
                        print(presenter.click);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // 둥근 테두리
                          border: Border.all(
                            color: ColorStyles.gray50, // 테두리 색상
                            width: 1, // 테두리 두께
                          ),
                        ),
                        child: Text(
                          '직접입력',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 13), // 텍스트 스타일
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  presenter.click
                      ? TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorStyles.gray40, width: 1),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorStyles.gray40, width: 1),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            prefix: const SizedBox(width: 12),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // textController.clear(); // 텍스트 초기화
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0), // 아이콘 패딩 추가
                                child: SvgPicture.asset(
                                  'assets/icons/x_round.svg',
                                  height: 24, // 아이콘 높이
                                  width: 24, // 아이콘 너비
                                ),
                              ),
                            ),
                          ),
                          cursorColor: ColorStyles.black,
                          // cursorErrorColor: ColorStyles.black,
                          // autovalidateMode: AutovalidateMode.always,
                        )
                      : SizedBox.shrink()
                ]);
          }));
}

Widget _buildLoastingPoint(){
  return Expanded(
    child:  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      SizedBox(
        height: 42,
        child: Stack(
          children: [
            Positioned(
              top: 14,
              left: 10,
              right: 10,
              child: Container(
                height: 1,
                color: const Color(0xFFCFCFCF),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Widget>.generate(
                  5,
                      (index) => InkWell(
                    onTap: () {
                      // presenter.onChangeAcidityValue(index);
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color:
                        // presenter.acidity == index ?
                        // ColorStyles.white :
                        Colors.transparent,
                        shape: BoxShape.circle,
                        border:
                        // presenter.acidity == index ?
                        // Border.all(color: ColorStyles.red)
                            // : null,
                        null
                      ),
                      child: Center(
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color:  ColorStyles.gray50,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 28,
              left: 4,
              right: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Widget>.generate(
                  5,
                      (index) {
                    if (index == 0) {
                      return Text(
                        '라이트',
                        style: TextStyles.captionMediumMedium.copyWith(
                          color:  ColorStyles.gray50,
                          // color: presenter.acidity == index ? ColorStyles.red :
                        ),
                      );
                    } else if (index == 1) {
                      return Text(
                        '라이트 미디엄',
                        style: TextStyles.captionMediumMedium.copyWith(
                          color:  ColorStyles.gray50,
                          // color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                        ),
                      );
                    } else if (index == 2) {
                      return Text(
                        '미디엄',
                        style: TextStyles.captionMediumMedium.copyWith(
                          color:  ColorStyles.gray50,
                          // color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                        ),
                      );
                    } else if (index == 3) {
                      return Text(
                        '미디엄 다크',
                        style: TextStyles.captionMediumMedium.copyWith(
                          color:  ColorStyles.gray50,
                          // color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                        ),
                      );
                    } else {
                      return Text(
                        '다크',
                        style: TextStyles.captionMediumMedium.copyWith(
                          color:  ColorStyles.gray50,
                          // color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
  );

}

Widget _buildProcess(){
  final firstRow = ProcessType.values.sublist(0,4);
  final secondRow = ProcessType.values.sublist(4);
  return SizedBox(
      height: 150,
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: firstRow
                        .map(
                          (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 6),
                          decoration: BoxDecoration(
                            // 배경색
                            borderRadius: BorderRadius.circular(8),
                            // 둥근 테두리
                            border: Border.all(
                              color: ColorStyles.gray50, // 테두리 색상
                              width: 1, // 테두리 두께
                            ),
                          ),
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                                color: Colors.black), // 텍스트 스타일
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: secondRow
                        .map(
                          (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // 둥근 테두리
                            border: Border.all(
                              color: ColorStyles.gray50, // 테두리 색상
                              width: 1, // 테두리 두께
                            ),
                          ),
                          child: Text(
                            item.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13), // 텍스트 스타일
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                ]);
          }));



}

Widget _buildRegion(context,presenter){
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonFactory.buildButton(
            onTapped: () =>
            {
            showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (context) => WdgtSearchBottomSheet(
            title: '생산 국가',
            ),
            )
            },
            style: RoundedButtonStyle.line(
              size: RoundedButtonSize.medium,
              color: ColorStyles.gray50,
              textColor: ColorStyles.black,
            ), text: '원두 이름을 검색해보세요.', iconPath: '',
        ),
      ],
    ),

  );
}

Widget _buildBevType(){
  return SizedBox(
    child: Row(
      children: [
        ButtonFactory.buildRoundedButton(onTapped: (){}, text: "핫", style: RoundedButtonStyle.line(size: RoundedButtonSize.small)),
        SizedBox(width: 10,),
        ButtonFactory.buildRoundedButton(onTapped: (){}, text: "아이스", style: RoundedButtonStyle.line(size: RoundedButtonSize.small))
      ],
    ),
  );
}

Widget listFrame(
    {required String title,
    required bool isExpanded,
    required VoidCallback onIconTap,
    required Widget buildWidget}) {
  return AnimatedContainer(
    height: isExpanded ? 200 : 48,
    // 확장 시 높이 변화
    color: ColorStyles.gray10,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    duration: const Duration(milliseconds: 300),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.labelMediumMedium,
            ),
            GestureDetector(
              onTap: onIconTap,
              child: SvgPicture.asset(
                isExpanded
                    ? 'assets/icons/subtract.svg'
                    : 'assets/icons/plus_fill.svg',
                fit: BoxFit.scaleDown,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
        if (isExpanded) buildWidget
      ],
    ),
  );
}
