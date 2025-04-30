import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/domain/notification/notification_item_presenter.dart';
import 'package:brew_buds/domain/notification/notification_tap_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationItemWidget extends StatelessWidget {
  final void Function(NotificationTapAction action) onComplete;

  const NotificationItemWidget._({
    required this.onComplete,
  });

  static Widget buildWithPresenter({
    required NotificationItemPresenter presenter,
    required void Function(NotificationTapAction action) onComplete,
  }) {
    return ChangeNotifierProvider.value(
      value: presenter,
      child: NotificationItemWidget._(onComplete: onComplete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureButton<NotificationTapAction, Exception>(
      onTap: () => context.read<NotificationItemPresenter>().onTap(),
      onComplete: onComplete,
      child: Container(
        color: ColorStyles.white,
        child: Builder(builder: (context) {
          final isRead = context.select<NotificationItemPresenter, bool>((presenter) => presenter.isRead);
          return Opacity(
            opacity: isRead ? 0.3 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Builder(builder: (context) {
                  final body = context.select<NotificationItemPresenter, String>((presenter) => presenter.body);
                  return _buildNotificationText(body);
                }),
                Builder(builder: (context) {
                  final createdAt =
                      context.select<NotificationItemPresenter, String>((presenter) => presenter.createdAt);
                  return Text(
                    createdAt,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  );
                }),
              ],
            ),
          );
        }),
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
