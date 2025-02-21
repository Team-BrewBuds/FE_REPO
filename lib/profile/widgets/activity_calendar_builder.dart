import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

final class ActivityCalendarBuilder extends CalendarBuilders {
  final dayTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 21.6 / 18,
    letterSpacing: -0.02,
    fontFamily: 'Pretendard',
  );

  final int Function(DateTime day) fetchActivityCount;

  const ActivityCalendarBuilder({
    required this.fetchActivityCount,
  });

  @override
  // TODO: implement selectedBuilder
  FocusedDayBuilder? get selectedBuilder => (BuildContext context, DateTime day, DateTime focusedDay) {
        final count = fetchActivityCount(day);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: ColorStyles.black, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: dayTextStyle.copyWith(color: ColorStyles.white),
                  ),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(color: ColorStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text('$count', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                  ),
                ),
              ),
          ],
        );
      };

  @override
  FocusedDayBuilder? get holidayBuilder => (BuildContext context, DateTime day, DateTime focusedDay) {
        final count = fetchActivityCount(day);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: count > 0 ? ColorStyles.gray10 : ColorStyles.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: dayTextStyle.copyWith(color: ColorStyles.red),
                  ),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(color: ColorStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text('$count', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                  ),
                ),
              ),
          ],
        );
      };

  @override
  FocusedDayBuilder? get defaultBuilder => (BuildContext context, DateTime day, DateTime focusedDay) {
        final count = fetchActivityCount(day);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: count > 0 ? ColorStyles.gray10 : ColorStyles.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: dayTextStyle.copyWith(color: ColorStyles.black),
                  ),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: const BoxDecoration(color: ColorStyles.red, shape: BoxShape.circle),
                  child: Center(
                    child: Text('$count', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                  ),
                ),
              ),
          ],
        );
      };
}
