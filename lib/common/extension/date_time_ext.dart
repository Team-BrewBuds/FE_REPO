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

  String timeAgo() {
    final Duration difference = DateTime.now().difference(this);

    if (difference.inMinutes < 1) {
      return "방금 전";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}분 전";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}시간 전";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}일 전";
    } else if (difference.inDays < 30) {
      return "${difference.inDays ~/ 7}주 전";
    } else if (difference.inDays < 365) {
      return "${difference.inDays ~/ 30}개월 전";
    } else {
      return "${difference.inDays ~/ 365}년 전";
    }
  }
}