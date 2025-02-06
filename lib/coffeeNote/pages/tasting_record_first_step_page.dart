import 'dart:math';

import 'package:brew_buds/coffeeNote/pages/tasting_record_sec_step_page.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../../features/signup/models/gender.dart';
import '../../features/signup/provider/sign_up_presenter.dart';
import '../widget/beanCountryWidget.dart';
import '../widget/blendWidgets.dart';
import '../widget/singleOriginWidgets.dart';
import 'core/tasing_record_mixin.dart';

class TasingRecordFirstStepPage extends StatefulWidget {
  const TasingRecordFirstStepPage({super.key});

  @override
  State<TasingRecordFirstStepPage> createState() =>
      _TasingRecordFirstStepPageState();
}

class _TasingRecordFirstStepPageState extends State<TasingRecordFirstStepPage>
    with TasingRecordMixin<TasingRecordFirstStepPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isDecaf = false;
  late String beanType = '';
  late bool single = false;
  late bool blend = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void beanTypeSelect({required String type, bool }) {
    setState(() {
      if (type == 'single') {
        if (!single) {
          single = true;
          blend = false;
          beanType = 'single';
        } else {
          single = false;
          beanType = '';
        }
      } else if (type == 'blend') {
        if (!blend) {
          blend = true;
          single = false;
          beanType = 'blend';
        } else {
          blend = false;
          beanType = '';
        }
      }
    });
  }


  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 원두 정보를 알려주세요.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('원두 정보를 알려주세요', style: TextStyles.title04SemiBold),
                  Container(
                    color: Colors.black,
                    width: 80,
                    height: 80,
                  )
                ],
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
                                  beanTypeSelect(type: 'single');
                                });
                              },
                              text: '싱글오리진',
                              style: single
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
                                  beanTypeSelect(type: 'blend');
                                });
                              },
                              text: '블렌드',
                              style: blend
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
                        onTap: () => setState(() => isDecaf = !isDecaf),
                        child: Row(
                          children: [
                            isDecaf
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
                                style: isDecaf
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


              //원두 이름 검색
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('원두 이름', style: TextStyles.title01SemiBold),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonFactory.buildButton(
                      onTapped: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              WdgtSearchBottomSheet(
                                title: '원두',
                                content: '원두 이름을 입력해 주세요.',
                              ),
                        );
                      },
                      style: RoundedButtonStyle.line(
                        size: RoundedButtonSize.medium,
                        color: ColorStyles.gray50,
                        textColor: ColorStyles.black,
                      ),
                      text: '원두 이름을 검색해보세요.',
                      iconPath: 'assets/icons/search.svg'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('원두 생산 국가', style: TextStyles.title01SemiBold),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonFactory.buildButton(
                      onTapped: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              Beancountrywidget(
                              ),
                        );
                      },
                      style: RoundedButtonStyle.line(
                        size: RoundedButtonSize.medium,
                        color: ColorStyles.gray50,
                        textColor: ColorStyles.black,
                      ),
                      text: '생산 국가를 선택해주세요',
                      iconPath: 'assets/icons/search.svg'),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              if(beanType == 'single')
                sigleOriginWidgets(),

              if(beanType == 'blend')
                Blendwidgets()
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement currentPageIndex
  int get currentPageIndex => 0;

  @override
  // TODO: implement isSatisfyRequirements
  bool get isSatisfyRequirements => true;

  @override
  // TODO: implement isSkippablePage
  bool get isSkippablePage => false;

  @override
  // TODO: implement onNext
  void Function() get onNext =>
          () {
        print('next');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TastingRecordSecStepPage()));
      };

  @override
  Widget buildBottom(BuildContext context, CoffeeNotePresenter presenter) {
    // TODO: implement buildBottom
    return Padding(
      padding:
      const EdgeInsets.only(top: 24, bottom: 46.0, left: 16, right: 16),
      child: AbsorbPointer(
        absorbing: !isSatisfyRequirements,
        child: InkWell(
          onTap: onNext,
          child: Container(
            height: 47,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSatisfyRequirements
                  ? ColorStyles.black
                  : ColorStyles.gray30,
            ),
            child: Center(
              child: Text(
                '다음',
                style: TextStyles.labelMediumMedium.copyWith(
                  color: isSatisfyRequirements
                      ? ColorStyles.white
                      : ColorStyles.gray40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
