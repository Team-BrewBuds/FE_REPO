import 'package:brew_buds/coffeeNote/widget/singleOriginWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../provider/coffee_note_presenter.dart';
import 'beanCountryWidget.dart';
import 'blendWidgets.dart';

class Nonficialbeanwidget extends StatefulWidget {
  const Nonficialbeanwidget({super.key});

  @override
  State<Nonficialbeanwidget> createState() => _NonficialbeanwidgetState();
}

class _NonficialbeanwidgetState extends State<Nonficialbeanwidget> {
  final CoffeeNotePresenter coffeeNotePresenter = CoffeeNotePresenter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),

        //원두 유형 버튼
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('원두 유형', style: TextStyles.title01SemiBold),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    ButtonFactory.buildRoundedButton(
                        onTapped: () {
                          setState(() {
                            coffeeNotePresenter.beanTypeSelect(type: 'single');
                          });
                        },
                        text: '싱글오리진',
                        style: coffeeNotePresenter.beanType == 'single'
                            ? RoundedButtonStyle.line(
                            size: RoundedButtonSize.medium,
                            backgroundColor: ColorStyles.background,
                            color: ColorStyles.red,
                            textColor: ColorStyles.red)
                            : RoundedButtonStyle.line(
                          size: RoundedButtonSize.medium,
                          color: ColorStyles.gray50,
                          textColor: ColorStyles.black,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    ButtonFactory.buildRoundedButton(
                        onTapped: () {
                          setState(() {
                            coffeeNotePresenter.beanTypeSelect(type: 'blend');
                          });
                        },
                        text: '블렌드',
                        style: coffeeNotePresenter.beanType == 'blend'
                            ? RoundedButtonStyle.line(
                            size: RoundedButtonSize.medium,
                            backgroundColor: ColorStyles.background,
                            color: ColorStyles.red,
                            textColor: ColorStyles.red)
                            : RoundedButtonStyle.line(
                          size: RoundedButtonSize.medium,
                          color: ColorStyles.gray50,
                          textColor: ColorStyles.black,
                        )),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      coffeeNotePresenter.deCaf();
                    });

                  },
                  child: Row(
                    children: [
                      coffeeNotePresenter.isDecaf
                          ? SvgPicture.asset(
                        'assets/icons/checkbox.svg',
                        fit: BoxFit.scaleDown,
                        height: 28,
                        width: 28,
                      )
                          : SvgPicture.asset(
                        'assets/icons/uncheck.svg',
                        fit: BoxFit.scaleDown,
                        height: 28,
                        width: 28,
                      ),
                      Text('다카페인',
                          style: coffeeNotePresenter.isDecaf
                              ? TextStyles.labelSmallMedium
                              .copyWith(color: ColorStyles.red)
                              : TextStyles.labelSmallMedium
                              .copyWith(color: ColorStyles.gray50))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('원산지', style: TextStyles.title01SemiBold),
            SizedBox(
              height: 10,
            ),
            ButtonFactory.buildButton(
                onTapped: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Beancountrywidget(),
                  );
                },
                style: RoundedButtonStyle.line(
                  size: RoundedButtonSize.medium,
                  color: ColorStyles.gray50,
                  textColor: ColorStyles.black,
                ),
                text: '원산지를 선택해주세요',
                iconPath: 'assets/icons/search.svg'),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        if (coffeeNotePresenter.beanType == 'single') singleOriginWidgets(),

        if (coffeeNotePresenter.beanType == 'blend') const Blendwidgets()
      ],
    );
  }
}
