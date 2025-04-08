import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItemWidget extends StatelessWidget {
  final String body;
  final String date;
  final bool isRead;

  const NotificationItemWidget({
    super.key,
    required this.body,
    required this.date,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isRead ? 0.3 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          _buildNotificationText(body),
          Text(
            date,
            style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
          ),
        ],
      ),
    );
  }

  Text _buildNotificationText(String body) {
    final defaultStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      height: 1.5,
      letterSpacing: -0.01,
    );
    final cleaned = body.replaceAll('\n', ' ').replaceAll('\r', ' ').trim();
    final regex = RegExp(r'^(.+?)님(.*)$');
    final match = regex.firstMatch(cleaned);

    if (match != null && match.groupCount == 2) {
      final nickname = match.group(1)!;
      final message = '님${match.group(2)!}';

      final parts = message.split('.');

      return Text.rich(
        maxLines: null,
        TextSpan(
          children: [
            TextSpan(
              text: nickname,
              style: TextStyles.title01SemiBold,
            ),
            TextSpan(
              text: '${parts[0]}.',
              style: defaultStyle,
            ),
          ],
        ),
      );
    } else {
      return Text(body, style: defaultStyle, maxLines: null);
    }
  }
}
