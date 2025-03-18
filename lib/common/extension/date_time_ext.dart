import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get differenceTheNow {
    final difference = DateTime.now().difference(this);
    if (difference.inMinutes < 1) {
      return '방금전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간전';
    } else {
      return '${difference.inDays}일전';
    }
  }

  String toDefaultString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}