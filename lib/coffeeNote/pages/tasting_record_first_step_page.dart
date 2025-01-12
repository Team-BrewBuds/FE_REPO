import 'package:brew_buds/coffeeNote/pages/tasting_record_sec_step_page.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/button_factory.dart';
import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../../features/signup/models/gender.dart';
import '../../features/signup/provider/sign_up_presenter.dart';
import '../widget/wdgt_select_list.dart';
import 'core/tasing_record_mixin.dart';

class TasingRecordFirstStepPage extends StatefulWidget {
  const TasingRecordFirstStepPage({super.key});

  @override
  State<TasingRecordFirstStepPage> createState() => _TasingRecordFirstStepPageState();
}

class _TasingRecordFirstStepPageState extends State<TasingRecordFirstStepPage> with
    TasingRecordMixin<TasingRecordFirstStepPage>
{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child:  Padding(
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
                ],),

              //원두 유형 버튼
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('원두 유형', style: TextStyles.title01SemiBold),
                    SizedBox(height: 8,),
                    Row(children: [
                      ButtonFactory.buildRoundedButton(onTapped: () =>
                      {
                      },
                          text: '싱글오리진',
                          style: RoundedButtonStyle.line(
                            size: RoundedButtonSize.medium,
                            color: ColorStyles.gray50,
                            textColor: ColorStyles.black,
                          )),

                      SizedBox(width: 8,),
                      ButtonFactory.buildRoundedButton(onTapped: () =>
                      {
                      },
                          text: '블렌드',
                          style: RoundedButtonStyle.line(
                            size: RoundedButtonSize.medium,
                            color: ColorStyles.gray50,
                            textColor: ColorStyles.black,
                          )),
                    ],),
                    SizedBox(height:4 ,),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/uncheck.svg',
                          fit: BoxFit.scaleDown,
                          height: 28,
                          width: 28,
                        ),

                        Text('다카페인', style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),)
                      ],
                    )

                  ]
                  ,
                ),
              ],),
              SizedBox(height: 20,),

              //원두 유형 text 입력
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('원두 이름', style: TextStyles.title01SemiBold),
                  SizedBox(height: 10,),
                  ButtonFactory.buildButton(
                      onTapped: () =>
                  {
                  },
                      style: RoundedButtonStyle.line(
                        size: RoundedButtonSize.medium,
                        color: ColorStyles.gray50,
                        textColor: ColorStyles.black,
                      ), text: '원두 이름을 검색해보세요.', iconPath: 'assets/icons/search.svg'
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('원두 생산 국가', style: TextStyles.title01SemiBold),
                  SizedBox(height: 10,),
                  ButtonFactory.buildButton(
                      onTapped: () =>
                      {
                      },
                      style: RoundedButtonStyle.line(
                        size: RoundedButtonSize.medium,
                        color: ColorStyles.gray50,
                        textColor: ColorStyles.black,
                      ), text: '생산 국가를 검색해보세요.', iconPath: 'assets/icons/search.svg'
                  ),
                ],
              ),
              SizedBox(height: 20,),
              WdgtSelectList()







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
  void Function() get onNext => (){
    print('next');
    Navigator.push(context, MaterialPageRoute(builder: (context)=> TastingRecordSecStepPage()));
  };

}
