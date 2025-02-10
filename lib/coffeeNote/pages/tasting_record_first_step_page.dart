import 'package:brew_buds/coffeeNote/pages/tasting_record_sec_step_page.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/widget/wdgt_search_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../widget/beanCountryWidget.dart';
import '../widget/blendWidgets.dart';
import '../widget/nonficialBeanWidget.dart';
import '../widget/officialBeanWidget.dart';
import '../widget/singleOriginWidgets.dart';
import 'core/tasing_record_mixin.dart';
import 'package:brew_buds/coffeeNote/search_presenter.dart';

class TasingRecordFirstStepPage extends StatefulWidget {
  const TasingRecordFirstStepPage({super.key});

  @override
  State<TasingRecordFirstStepPage> createState() =>
      _TasingRecordFirstStepPageState();
}

class _TasingRecordFirstStepPageState extends State<TasingRecordFirstStepPage>
    with TasingRecordMixin<TasingRecordFirstStepPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {
    TextEditingController controller = TextEditingController();
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

              //원두 이름 검색
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('원두 이름', style: TextStyles.title01SemiBold),
                  SizedBox(
                    height: 10,
                  ),

                  // if(searchPresenter.reusltName.isEmpty)
                  ButtonFactory.buildButton(
                      onTapped: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => WdgtSearchBottomSheet(
                            title: '원두',
                            content: '원두 이름을 입력해 주세요.',
                            resultWidget: Container(
                              height: 50,
                              color: Colors.red,
                            ),
                              onCheck: () => presenter.checkOfficial(),
                            textCtrl:controller
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



                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text('원두 이름', style: TextStyles.title01SemiBold),
                  //     SizedBox(
                  //       height: 10,
                  //     ),
                  //     Container(
                  //       height: 50,
                  //       color: ColorStyles.gray10,
                  //       child: Padding(
                  //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //           child:    Container(
                  //
                  //             decoration: BoxDecoration(
                  //               color: ColorStyles.black, // 배경색
                  //               borderRadius: BorderRadius.circular(20), // 둥근 모서리
                  //             ),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   searchPresenter.value,
                  //                   style: TextStyles.labelSmallSemiBold
                  //                       .copyWith(color: ColorStyles.white),
                  //                 ),
                  //                 const SizedBox(width: 2),
                  //                 InkWell(
                  //                   onTap: () {
                  //
                  //                   },
                  //                   child: SvgPicture.asset(
                  //                     'assets/icons/x.svg',
                  //                     width: 12,
                  //                     height: 12,
                  //                     fit: BoxFit.cover,
                  //                     colorFilter: const ColorFilter.mode(
                  //                         ColorStyles.white, BlendMode.srcIn),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //       ),
                  //     ),
                  //
                  //     // if(searchPresenter.reusltName.isEmpty)
                  //     // ButtonFactory.buildButton(
                  //     //     onTapped: () {
                  //     //       showModalBottomSheet(
                  //     //         backgroundColor: Colors.white,
                  //     //         context: context,
                  //     //         isScrollControlled: true,
                  //     //         builder: (context) => WdgtSearchBottomSheet(
                  //     //           title: '원두',
                  //     //           content: '원두 이름을 입력해 주세요.',
                  //     //           resultWidget: Container(
                  //     //             height: 50,
                  //     //             color: Colors.red,
                  //     //           ),
                  //     //             onCheck: () => presenter.checkOfficial()
                  //     //         ),
                  //     //       );
                  //     //     },
                  //     //     style: RoundedButtonStyle.line(
                  //     //       size: RoundedButtonSize.medium,
                  //     //       color: ColorStyles.gray50,
                  //     //       textColor: ColorStyles.black,
                  //     //     ),
                  //     //     text: '원두 이름을 검색해보세요ㄴ.',
                  //     //     iconPath: 'assets/icons/search.svg'),
                  //
                  //
                  //   ],
                  // ),


                ],
              ),
              presenter.official ?Officialbeanwidget() : Nonficialbeanwidget(),

              SizedBox(
                height: 20,
              ),
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
  void Function() get onNext => () {
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
