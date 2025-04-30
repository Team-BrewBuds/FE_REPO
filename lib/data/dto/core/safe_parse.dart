import 'package:flutter/foundation.dart';

T? safeParse<T>(Map<String, dynamic>? json, T Function(Map<String, dynamic>) parser) {
  if (json == null) return null;
  try {
    return parser(json);
  } catch (e) {
    // 로그 출력 등도 가능
    debugPrint('Parse failed for $T: $e');
    return null;
  }
}