import 'dart:math';

import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_bottom_sheet.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../model/beanInfo.dart';

class WdgtSelectList extends StatefulWidget {
  const WdgtSelectList({super.key});

  @override
  State<WdgtSelectList> createState() => _WdgtSelectListState();
}

class _WdgtSelectListState extends State<WdgtSelectList> {
  late List<bool> _expandedStates;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(7, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final List<double> _height = [268, 150, 200, 132, 131, 132, 132];
    return Consumer<CoffeeNotePresenter>(
      builder: (BuildContext context, presenter, Widget? child) {
        final List<Widget> _widgets = [
          _buildOriginFilter(presenter), //원두 추출방식
          _buildLoastingPoint(presenter), //원두 로스팅 포인트
          _buildProcess(presenter), //원두 가공방식
          _buildRegion(presenter), // 원두 생산지역
          _buildBevType(presenter), // 음료 유형
          _buildRoastery(context, presenter),
          _buildVariety(context, presenter),
        ];

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _expandedStates.length,
          itemBuilder: (context, index) {
            return listFrame(
              title: presenter.recordTitle[index],
              isExpanded: _expandedStates[index],
              height: _height[index],
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

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late String etcValue;

  textController.addListener(() {
    etcValue = textController.text;
    print(etcValue);
  });

  return Expanded(
    child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: firstRow
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: InkWell(
                            onTap: () {
                              presenter.extractionFilter(item);
                              // print(item.name);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                // 배경색
                                color:
                                    presenter.extractionList.contains(item.name)
                                        ? ColorStyles.background
                                        : null,
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color: presenter.extractionList
                                          .contains(item.name)
                                      ? ColorStyles.red
                                      : ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: TextStyle(
                                    color: presenter.extractionList
                                            .contains(item.name)
                                        ? ColorStyles.red
                                        : ColorStyles.black,
                                    fontSize: 13), // 텍스트 스타일
                              ),
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
                          child: InkWell(
                            onTap: () {
                              presenter.extractionFilter(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                color:
                                    presenter.extractionList.contains(item.name)
                                        ? ColorStyles.background
                                        : null,
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color: presenter.extractionList
                                          .contains(item.name)
                                      ? ColorStyles.red
                                      : ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: TextStyle(
                                    color: presenter.extractionList
                                            .contains(item.name)
                                        ? ColorStyles.red
                                        : ColorStyles.black,
                                    fontSize: 13), // 텍스트 스타일
                              ),
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
                      // presenter.addExtranctionEtcValue(etcValue);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 6),
                      decoration: BoxDecoration(
                        color: presenter.click ? ColorStyles.background : null,
                        borderRadius: BorderRadius.circular(8), // 둥근 테두리
                        border: Border.all(
                          color: presenter.click
                              ? ColorStyles.red
                              : ColorStyles.gray50, // 테두리 색상
                          width: 1, // 테두리 두께
                        ),
                      ),
                      child: Text(
                        '직접입력',
                        style: TextStyle(
                            color: presenter.click
                                ? ColorStyles.red
                                : ColorStyles.black,
                            fontSize: 13), // 텍스트 스타일
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                presenter.click
                    ? TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (value) {
                          presenter.addExtranctionEtcValue(etcValue);
                        },
                        style: TextStyles.labelSmallMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorStyles.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: ColorStyles.gray40, width: 1),
                            borderRadius: BorderRadius.circular(1),
                          ),
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
                              textController.clear();
                              presenter.extractionList.clear(); // 텍스트 초기화
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // 아이콘 패딩 추가
                              child: SvgPicture.asset(
                                'assets/icons/x_round.svg',
                                color: ColorStyles.gray30, // 아이콘 너비
                              ),
                            ),
                          ),
                        ),
                        cursorColor: ColorStyles.black,
                        // cursorErrorColor: ColorStyles.black,
                        // autovalidateMode: AutovalidateMode.always,
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 24,
                ),
              ]);
        }),
  );
}

Widget _buildLoastingPoint(CoffeeNotePresenter presenter) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 50,
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
                        presenter.onChangeRoastPoing(index);
                        print(presenter.roastPoint);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: presenter.roastPoint == index
                              ? ColorStyles.background
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: presenter.roastPoint == index
                              ? Border.all(color: ColorStyles.red)
                              : null,
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: presenter.roastPoint == index
                                  ? ColorStyles.red
                                  : ColorStyles.gray50,
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
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      // Only show text for the selected index
                      if (presenter.roastPoint == index) {
                        // Return the corresponding text for the selected index
                        if (index == 0) {
                          return Text(
                            '라이트',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.red,
                            ),
                          );
                        } else if (index == 1) {
                          return Text(
                            '라이트 미디엄',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.red,
                            ),
                          );
                        } else if (index == 2) {
                          return Text(
                            '미디엄',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.red,
                            ),
                          );
                        } else if (index == 3) {
                          return Text(
                            '미디엄 다크',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.red,
                            ),
                          );
                        } else {
                          return Text(
                            '다크',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.red,
                            ),
                          );
                        }
                      } else {
                        // For unselected items, return SizedBox.shrink()
                        return SizedBox.shrink();
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

Widget _buildProcess(CoffeeNotePresenter presenter) {
  final firstRow = presenter.processInfo.sublist(0, 4);
  final secondRow = presenter.processInfo.sublist(4);
  final TextEditingController _textEditController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late bool showTextField = false;

  return Expanded(
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
                          child: InkWell(
                            onTap: () {
                              presenter.processFilter(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                color: presenter.processList.contains(item.name)
                                    ? ColorStyles.background
                                    : null,
                                // 배경색
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color:
                                      presenter.processList.contains(item.name)
                                          ? Colors.red
                                          : ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: TextStyle(
                                    color: presenter.processList
                                            .contains(item.name)
                                        ? Colors.red
                                        : Colors.black), // 텍스트 스타일
                              ),
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
                          child: InkWell(
                            onTap: () {
                              presenter.processFilter(item);
                              if (item.index == 5) {
                                presenter.isClick();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              decoration: BoxDecoration(
                                color: presenter.processList.contains(item.name)
                                    ? ColorStyles.background
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                // 둥근 테두리
                                border: Border.all(
                                  color:
                                      presenter.processList.contains(item.name)
                                          ? Colors.red
                                          : ColorStyles.gray50, // 테두리 색상
                                  width: 1, // 테두리 두께
                                ),
                              ),
                              child: Text(
                                item.toString(),
                                style: TextStyle(
                                    color: presenter.processList
                                            .contains(item.name)
                                        ? Colors.red
                                        : Colors.black), // 텍스트 스타일
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 8),
                if (presenter.isshow)
                  TextFormField(
                    controller: _textEditController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (value) {
                      presenter.addProcessEtcValue(value);
                    },
                    style: TextStyles.labelSmallMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorStyles.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorStyles.gray40, width: 1),
                        borderRadius: BorderRadius.circular(1),
                      ),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      prefix: const SizedBox(width: 12),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          presenter.processList.clear(); // 텍스트 초기화
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/icons/x_round.svg',
                            color: ColorStyles.gray30,
                          ),
                        ),
                      ),
                    ),
                    cursorColor: ColorStyles.black,
                  ),
                SizedBox(
                  height: 8,
                ),
              ]);
        }),
  );
}

Widget _buildRegion(CoffeeNotePresenter presenter) {
  TextEditingController textEditingController = TextEditingController();
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.text,
          style: TextStyles.labelSmallMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            prefix: const SizedBox(width: 12),
            suffixIcon: GestureDetector(
              onTap: () {
                textEditingController.clear(); // 텍스트 초기화
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0), // 아이콘 패딩 추가
                child: SvgPicture.asset(
                  'assets/icons/x_round.svg',
                  color: ColorStyles.gray30, // 아이콘 너비
                ),
              ),
            ),
          ),
          cursorColor: ColorStyles.black,
          // cursorErrorColor: ColorStyles.black,
          // autovalidateMode: AutovalidateMode.always,
        )
      ],
    ),
  );
}

Widget _buildBevType(CoffeeNotePresenter presenter) {
  return Expanded(
    child: Row(
      children: [
        ButtonFactory.buildRoundedButton(
            onTapped: () {
              presenter.checkHot();
            },
            text: '핫',
            style: presenter.bevType
                ? RoundedButtonStyle.line(
                    size: RoundedButtonSize.small,
                    backgroundColor: ColorStyles.background,
                    color: ColorStyles.red,
                    textColor: ColorStyles.red)
                : RoundedButtonStyle.line(
                    size: RoundedButtonSize.small,
                    color: ColorStyles.gray50,
                    textColor: ColorStyles.black,
                  )),
        SizedBox(
          width: 10,
        ),
        ButtonFactory.buildRoundedButton(
            onTapped: () {
              presenter.checkIce();
            },
            text: "아이스",
            style: !presenter.bevType
                ? RoundedButtonStyle.line(
                    size: RoundedButtonSize.small,
                    backgroundColor: ColorStyles.background,
                    color: ColorStyles.red,
                    textColor: ColorStyles.red)
                : RoundedButtonStyle.line(
                    size: RoundedButtonSize.small,
                    color: ColorStyles.gray50,
                    textColor: ColorStyles.black,
                  ))
      ],
    ),
  );
}

Widget _buildRoastery(context, presenter) {
  TextEditingController textEditingController = TextEditingController();
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.text,
          style: TextStyles.labelSmallMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            prefix: const SizedBox(width: 12),
            suffixIcon: GestureDetector(
              onTap: () {
                textEditingController.clear(); // 텍스트 초기화
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0), // 아이콘 패딩 추가
                child: SvgPicture.asset(
                  'assets/icons/x_round.svg',
                  color: ColorStyles.gray30, // 아이콘 너비
                ),
              ),
            ),
          ),
          cursorColor: ColorStyles.black,
          // cursorErrorColor: ColorStyles.black,
          // autovalidateMode: AutovalidateMode.always,
        )
      ],
    ),
  );
}

Widget _buildVariety(context, presenter) {
  TextEditingController textEditingController = TextEditingController();
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24,
        ),
        TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.text,
          style: TextStyles.labelSmallMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorStyles.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorStyles.gray40, width: 1),
              borderRadius: BorderRadius.circular(1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            prefix: const SizedBox(width: 12),
            suffixIcon: GestureDetector(
              onTap: () {
                textEditingController.clear(); // 텍스트 초기화
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0), // 아이콘 패딩 추가
                child: SvgPicture.asset(
                  'assets/icons/x_round.svg',
                  color: ColorStyles.gray30, // 아이콘 너비
                ),
              ),
            ),
          ),
          cursorColor: ColorStyles.black,
          // cursorErrorColor: ColorStyles.black,
          // autovalidateMode: AutovalidateMode.always,
        )
      ],
    ),
  );
}

Widget listFrame(
    {required String title,
    required bool isExpanded,
    required double height,
    required VoidCallback onIconTap,
    required Widget buildWidget}) {
  return AnimatedContainer(
    height: isExpanded ? height : 48,
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
