import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDateTime;

  const DatePickerBottomSheet({
    super.key,
    required this.initialDateTime,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _dateTime;

  @override
  void initState() {
    _dateTime = widget.initialDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
                      child: Row(
                        children: [
                          const SizedBox(width: 24),
                          const Spacer(),
                          Text('시음 날짜', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/x.svg',
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.ymd,
                        onDateTimeChanged: (dateTime) {
                          _dateTime = dateTime;
                        },
                        initialDateTime: widget.initialDateTime,
                        maximumDate: DateTime.now(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom + 14, top: 24),
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE7E7E7)))),
                      child: GestureDetector(
                        onTap: () {
                          context.pop(_dateTime);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: ColorStyles.black,
                          ),
                          child: Text(
                            '선택',
                            style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
