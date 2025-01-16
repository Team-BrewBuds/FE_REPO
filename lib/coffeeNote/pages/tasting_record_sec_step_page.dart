import 'package:brew_buds/coffeeNote/pages/tasting_record_third_step_page.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:flutter/material.dart';

import '../../common/button_factory.dart';
import '../../common/color_styles.dart';
import '../../common/text_styles.dart';
import '../widget/wdgt_search_bottom_sheet.dart';
import 'core/tasing_record_mixin.dart';

class TastingRecordSecStepPage extends StatefulWidget {
  const TastingRecordSecStepPage({super.key});

  @override
  State<TastingRecordSecStepPage> createState() => _TastingRecordSecStepPageState();
}

class _TastingRecordSecStepPageState extends State<TastingRecordSecStepPage> with TasingRecordMixin<TastingRecordSecStepPage>{

  final _formKey = GlobalKey<FormState>();
  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    // TODO: implement buildBody
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child:  Container(
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
                ],),

              //원두 유형 text 입력
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('맛', style: TextStyles.title01SemiBold),
                  SizedBox(height: 10,),
                  ButtonFactory.buildButton(
                    onTapped: () =>
                    {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => WdgtSearchBottomSheet(
                          title: '',
                          content: '',
                        ),
                      )
                    },
                    style: RoundedButtonStyle.line(
                      size: RoundedButtonSize.medium,
                      color: ColorStyles.gray50,
                      textColor: ColorStyles.black,
                    ), text: '원두의 맛을 입력해보세요. (최대 4개).',
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  // TODO: implement currentPageIndex
  int get currentPageIndex =>  1;

  @override
  // TODO: implement isSatisfyRequirements
  bool get isSatisfyRequirements => true;

  @override
  // TODO: implement isSkippablePage
  bool get isSkippablePage =>  false;

  @override
  // TODO: implement onNext
  void Function() get onNext => (){
    print('next');
    Navigator.push(context, MaterialPageRoute(builder: (context)=> TastingRecordThirdStepPage()));
  };

  @override
  // TODO: implement onSkip
  void Function() get onSkip => (){};
}
