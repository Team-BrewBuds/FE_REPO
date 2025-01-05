import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/button_factory.dart';
import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../pages/write_coffee_free_note.dart';

class CoffeeNoteBottomSheet extends StatefulWidget {
  final VoidCallback onClose;

  const CoffeeNoteBottomSheet({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CoffeeNoteBottomSheet> createState() => _CoffeeNoteBottomSheetState();
}

class _CoffeeNoteBottomSheetState extends State<CoffeeNoteBottomSheet> {
  final List<String> iconPath = [
    'assets/icons/pen.svg',
    'assets/icons/cup.svg'
  ];
  final List<String> title = ['게시글', '시음기록'];
  final List<String> question = ['자유롭게 커피에 대한 것을 공유해보\n세요', '어떤 커피를 드셨나요?'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: MediaQuery.of(context).size.height * 0.4, // BottomSheet 높이
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '커피노트 작성하기',
                  style: TextStyles.title02SemiBold,
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 0.5,
            color: ColorStyles.gray10,
          ),
          Expanded(
              child: ListView.separated(
            itemCount: 2,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WriteCoffeeFreeNote()),
                    );
                  } else {

                  }
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColorStyles.gray10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            iconPath[index],
                            fit: BoxFit.scaleDown,
                            height: 28,
                            width: 28,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title[index],
                              style: TextStyles.title01SemiBold,
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              question[index],
                              style: TextStyles.bodyNarrowRegular,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1.0,
                color: ColorStyles.gray10,
              );
            },
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0, vertical: 24.0),
            child: ButtonFactory.buildRoundedButton(
              onTapped: widget.onClose,
              text: '닫기',
              style: RoundedButtonStyle.fill(
                size: RoundedButtonSize.bW288H48,
                color: ColorStyles.black,
                textColor: ColorStyles.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
