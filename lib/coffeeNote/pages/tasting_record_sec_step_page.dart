import 'dart:math';

import 'package:brew_buds/coffeeNote/pages/tasting_record_third_step_page.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/widget/flavorChoiceWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../../features/signup/models/signup_lists.dart';
import '../../filter/filter_presenter.dart';
import '../widget/wdgt_bottom_sheet.dart';
import '../widget/wdgt_search_bottom_sheet.dart';
import 'core/tasing_record_mixin.dart';

class TastingRecordSecStepPage extends StatefulWidget {
  const TastingRecordSecStepPage({super.key});

  @override
  State<TastingRecordSecStepPage> createState() =>
      _TastingRecordSecStepPageState();
}

class _TastingRecordSecStepPageState extends State<TastingRecordSecStepPage>
    with TasingRecordMixin<TastingRecordSecStepPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    // TODO: implement buildBody
    final SignUpLists lists = SignUpLists();
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('원두의 맛은 어떤가요?', style: TextStyles.title04SemiBold),
                    Container(
                      color: Colors.black,
                      width: 80,
                      height: 80,
                    )
                  ],
                ),

                //원두 유형 text 입력
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('맛', style: TextStyles.title01SemiBold),
                    SizedBox(
                      height: 10,
                    ),
                    if(presenter.tasteFlaver.isEmpty)
                    ButtonFactory.buildButton(
                      onTapped: () => {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => flavorChoiceWidget(
                            title: '원두에서 어떤 맛이 느껴지시나요?',
                          ),
                        )
                      },
                      style: RoundedButtonStyle.line(
                        size: RoundedButtonSize.medium,
                        color: ColorStyles.gray50,
                        textColor: ColorStyles.black,
                      ),
                      text:
                      '원두의 맛을 입력해보세요. (최대 4개).',
                    ),

                    if(presenter.tasteFlaver.isNotEmpty)
                      Container(
                        height: 50,
                        color: ColorStyles.gray10,
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



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(lists.categories.length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(lists.categories[index],
                                style: TextStyles.title01SemiBold),
                            SizedBox(height: 10),
                            buildSelector(index, presenter),
                            Container(),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget buildSelector(int categoryIndex, CoffeeNotePresenter presenter) {
    final SignUpLists lists = SignUpLists();
    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                if (index == 4 || index == 0) return SizedBox(width: 20);
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              String value = lists.labels[categoryIndex][index];
              int valueIndex = lists.labels[categoryIndex].indexOf(value);
              bool isSelected =presenter.selectedIndexes[categoryIndex] == index;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        presenter.onChangeTastPoint(categoryIndex,valueIndex);
                        print(value);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isSelected
                                      ? ColorStyles.red
                                      : Colors.grey),
                            )
                          : null,
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? ColorStyles.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    isSelected ?
                    lists.labels[categoryIndex][index] : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? ColorStyles.red : Colors.black,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement currentPageIndex
  int get currentPageIndex => 1;

  @override
  // TODO: implement isSatisfyRequirements
  bool get isSatisfyRequirements => true;


  @override
  // TODO: implement isSkippablePage
  bool get isSkippablePage => false;

  @override
  // TODO: implement onNext
  void Function() get onNext => () {
        print('next');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TastingRecordThirdStepPage()));
      };





  @override
  // TODO: implement onSkip
  void Function() get onSkip => () {};

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
  Widget buildBottom(BuildContext context, CoffeeNotePresenter presenter) {
    // TODO: implement buildBottom

    return Padding(
      padding:
          const EdgeInsets.only(top: 24, bottom: 46.0, left: 16, right: 16),
      child: AbsorbPointer(
        absorbing: !isSatisfyRequirements,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ButtonFactory.buildRoundedButton(
              onTapped: () => Navigator.pop(context),
              text: '뒤로',
              style: RoundedButtonStyle.fill(
                size: RoundedButtonSize.xSmall,
                color: ColorStyles.gray30,
                textColor: ColorStyles.black,
              )),
          SizedBox(
            width: 8,
          ),
          ButtonFactory.buildRoundedButton(
            onTapped: onNext,
            text: '다음',
            style: RoundedButtonStyle.fill(
                size: RoundedButtonSize.large,
                color: isSatisfyRequirements
                    ? ColorStyles.gray20
                    : ColorStyles.black,
                textColor: isSatisfyRequirements
                    ? ColorStyles.gray40
                    : ColorStyles.white),
          )
        ]),
      ),
    );
  }
}


