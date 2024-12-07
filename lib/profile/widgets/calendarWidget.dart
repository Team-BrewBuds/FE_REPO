import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class KoreanCalendarPage extends StatefulWidget {
  @override
  _KoreanCalendarPageState createState() => _KoreanCalendarPageState();
}

class _KoreanCalendarPageState extends State<KoreanCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('활동 캘린더'),
                ElevatedButton(onPressed: () {}, child: Text('시음기록'))
              ],
            ),
            TableCalendar(
              locale: 'ko_KR',
              // 한국어 로케일 설정
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,

              headerStyle: HeaderStyle(
                leftChevronPadding: EdgeInsets.zero,
                formatButtonVisible: false,
                titleTextFormatter: (date, locale) {
                  return DateFormat.yMMMM('ko_KR').format(date);
                },
                titleCentered: true,
              ),

              calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(),
                  todayTextStyle: TextStyle(color: ColorStyles.red20),
                  selectedTextStyle: TextStyle(color: ColorStyles.red20),
                  selectedDecoration: BoxDecoration(),
                  outsideDaysVisible: false),

              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },

              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
          ],
    );
  }
}
