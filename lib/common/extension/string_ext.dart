import 'dart:convert';

extension StringExt on String {
  Map<String, dynamic> convertToJson() {
    // 중괄호 추가하고 쌍따옴표로 키 감싸기
    final formatted = '{${replaceAllMapped(
      RegExp(r'(\w+):\s?([^,}]+)'),
      (match) => '"${match[1]}": ${match[2]}',
    )}}';

    return jsonDecode(formatted);
  }
}
