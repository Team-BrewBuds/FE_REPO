
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../factory/button_factory.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';


class WdgtValidQuestion extends StatefulWidget {
  final String title;
  final String content;

  const WdgtValidQuestion(
      {super.key, required this.title, required this.content});

  @override
  State<WdgtValidQuestion> createState() => _WdgtValidQuestionState();
}

class _WdgtValidQuestionState extends State<WdgtValidQuestion> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white, // 배경색 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // borderRadius 적용
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0), // 내부 여백 설정
        width: double.infinity, // Dialog 너비 설정
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title
            Center(
              child: Text(
                  widget.title,
                  style: TextStyles.title02SemiBold
              ),
            ),
            const SizedBox(height: 8), // 제목과 내용 사이의 간격
            // Content
            Text(
              widget.content,
              style: TextStyles.bodyRegular,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonFactory.buildRoundedButton(onTapped: () =>
                  {
                    Navigator.of(context).pop(false) // 취소
                  },
                      text: '닫기',
                      style: RoundedButtonStyle.fill(
                          size: RoundedButtonSize.bW129H47,
                        color: ColorStyles.gray20,
                        textColor: ColorStyles.black,
                      )),
                  SizedBox(width: 8,),
                  ButtonFactory.buildRoundedButton(onTapped: () =>
                  {
                  Navigator.of(context).pop(true)
                  },
                      text: '나가기',
                      style: RoundedButtonStyle.fill(
                          size: RoundedButtonSize.bW129H47,
                        color: ColorStyles.black,
                        textColor: ColorStyles.white,))

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

