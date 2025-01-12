import 'dart:math';

import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../common/color_styles.dart';
import '../../common/text_styles.dart';

class WdgtSelectList extends StatefulWidget {
  const WdgtSelectList({super.key});

  @override
  State<WdgtSelectList> createState() => _WdgtSelectListState();
}

class _WdgtSelectListState extends State<WdgtSelectList> {
  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    _expandedStates = List.generate(7, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeNotePresenter>(
      builder: (BuildContext context, presenter, Widget? child) {
        final List<Widget> _widgets = [
          _buildOriginFilter(presenter),
          Container(
            color: Colors.red,
            height: 30,
          ),
          Container(
            color: Colors.green,
            height: 30,
          ),
          Container(
            color: Colors.orange,
            height: 30,
          ),
          Container(
            color: Colors.blue,
            height: 30,
          ),
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

Widget _buildOriginFilter(CoffeeNotePresenter presenter) {

  final firstRow  = presenter.extractionInfo.sublist(0, 3);// 첫 번째 행
  final secondRow =  presenter.extractionInfo.sublist(3);  // 두 번째 행
  return SizedBox(
    height: 150,
    child:

  //
    ListView.builder(
        itemCount: 1,
        itemBuilder: (context,index){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Row(
            children: firstRow
                .map(
                  (item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration: BoxDecoration(// 배경색
                    borderRadius: BorderRadius.circular(8), // 둥근 테두리
                    border: Border.all(
                      color: ColorStyles.gray50, // 테두리 색상
                      width: 1, // 테두리 두께
                    ),
                  ),
                  child: Text(
                    item.toString(),
                    style: const TextStyle(color: Colors.black), // 텍스트 스타일
                  ),
                ),
              ),
            )
                .toList(),
          ),
          SizedBox(height: 8,),
          Row(
            children: secondRow
                .map(
                  (item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // 둥근 테두리
                    border: Border.all(
                      color: ColorStyles.gray50, // 테두리 색상
                      width: 1, // 테두리 두께
                    ),
                  ),
                  child: Text(
                    item.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 13), // 텍스트 스타일
                  ),
                ),
              ),
            ).toList(),
          ),

        ]

      );
        }));

  //   Container(
  //   child: Text(presenter.extractionInfo[0].toString()),
  // );
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
