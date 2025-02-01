import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/factory/button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../widget/wdgt_search_bottom_sheet.dart';
import 'core/tasing_record_mixin.dart';

class TastingRecordThirdStepPage extends StatefulWidget {
  const TastingRecordThirdStepPage({super.key});

  @override
  State<TastingRecordThirdStepPage> createState() =>
      _TastingRecordThirdStepPageState();
}

class _TastingRecordThirdStepPageState extends State<TastingRecordThirdStepPage>
    with TasingRecordMixin<TastingRecordThirdStepPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  int get currentPageIndex => 2;

  @override
  bool get isSatisfyRequirements => true;

  @override
  bool get isSkippablePage => false;

  @override
  void Function() get onNext => () {};

  @override
  void Function() get onSkip => () {};

  bool isOn = false;

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 430,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0), // Adjust this value as needed
              topRight: Radius.circular(8.0), // Adjust this value as needed
            ),
            color: Colors.white, // Set a background color if needed
          ),
          child: Column(
            children: [
              // 상단 X 아이콘
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 24), // 왼쪽 여백을 위한 빈 위젯
                    Text(
                      '시음 날짜',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/x.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // CupertinoDatePicker 추가
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                ),
              ),
              // 완료 버튼
              Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, right: 16.0, bottom: 46.0, left: 16.0),
                  child: ButtonFactory.buildRoundedButton(
                      onTapped: () {},
                      text: '선택',
                      style: RoundedButtonStyle.fill(
                          size: RoundedButtonSize.xLarge,
                          color: Colors.black))),
            ],
          ),
        );
      },
    );
  }

  void _showLocatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0), // Adjust this value as needed
              topRight: Radius.circular(8.0), // Adjust this value as needed
            ),
            color: Colors.white, // Set a background color if needed
          ),
          child: Column(
            children: <Widget>[
              WdgtSearchBottomSheet(title: '위치', content: '시음장소를 검색하세요', useIcon: true,
                )



            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter) {

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('원두가 취향에 맞나요?', style: TextStyles.title04SemiBold),
                  Container(
                    color: Colors.black,
                    width: 80,
                    height: 80,
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text('원두 평가', style: TextStyles.title01SemiBold),
              const SizedBox(height: 8),
              StarRating(
                onRatingSelected: (rating) {
                  print('선택된 별점: $rating');
                },
              ),
              const SizedBox(height: 8),
              Text('시음 내용', style: TextStyles.title01SemiBold),
              const SizedBox(height: 12),
              Container(
                  height: 140, // 필드의 높이를 140으로 설정
                  child: TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.text,
                    style: TextStyles.labelSmallMedium,
                    decoration: InputDecoration(
                      hintText: '원두와 시음 경험에 대한 이야기를 자유롭게 나눠주세요.',
                      hintStyle: TextStyles.labelSmallMedium
                          .copyWith(color: ColorStyles.gray50),
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 140, horizontal: 12),
                      // 수직 패딩으로 높이 설정
                      prefix: const SizedBox(width: 12),
                    ),
                    cursorColor: ColorStyles.black,
                  )),
              const SizedBox(height: 28),
              ListWidget('시음 날짜', null, _showDatePicker),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                    height: 0.3,
                  )),
              ListWidget(
                  '시음 장소',
                  SvgPicture.asset(
                    'assets/icons/plus_fill.svg',
                    fit: BoxFit.scaleDown,
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                        ColorStyles.gray50, BlendMode.srcIn),
                  ),
                  _showLocatePicker),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Divider(
                    height: 0.3,
                  )),
              isOnlyMe(title:'나만 보기', toggle: (){
                setState(() {
                  isOn = !isOn;
                });
              }, isOn: isOn),

            ],
          ),
        ),
      ),
    );
  }

  Widget ListWidget(
      String title, SvgPicture? icon, void Function(BuildContext)? onTap) {
    return Container(
      height: 60,
      color: ColorStyles.gray10,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap(context);
                } else {
                  print('a나만보기');
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyles.labelSmallMedium,
                  ),
                  Row(
                    children: [
                      Container(child: icon)],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //   Container(
    //   height: 180, // 전체 컨테이너 높이
    //   color: ColorStyles.gray10, // 배경색 설정
    //   child: ListView.separated(
    //     physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
    //     itemCount: title.length, // 아이템 개수 설정
    //     itemBuilder: (context, index) {
    //       return InkWell(
    //         onTap: () {
    //           switch(index){
    //             case 0: _showDatePicker(context);
    //             break;
    //             case 1:
    //               _showLocatePicker(context);
    //               break;
    //
    //             case 2:
    //               break;
    //
    //             default:
    //               break;
    //           }
    //
    //         },
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Text(
    //                 title[index],
    //                 style: TextStyles.labelSmallMedium,
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     separatorBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 12),
    //         child: Divider(color: ColorStyles.gray30), // 구분선 추가
    //       );
    //     },
    //   ),
    // );
  }

  Widget isOnlyMe(
       {required Function() toggle, required String title, required bool isOn}) {

    return Container(
      height: 60,
      color: ColorStyles.gray10,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0, left: 12.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: toggle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyles.labelSmallMedium,
                  ),
                  Row(
                    children: [
                      isOn ?
                      Container(child: SvgPicture.asset('assets/icons/togOn.svg')) :
                      Container(child: SvgPicture.asset('assets/icons/togOff.svg'))

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
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

class StarRating extends StatefulWidget {
  final Function(int) onRatingSelected;

  const StarRating({Key? key, required this.onRatingSelected})
      : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1;
            });
            widget.onRatingSelected(_currentRating);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/icons/star_fill.svg',
              width: 36,
              height: 36,
              color: index < _currentRating ? ColorStyles.red : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
