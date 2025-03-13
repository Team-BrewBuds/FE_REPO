import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_page.g.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class DefaultPage<T> {
  @JsonKey(defaultValue: 0)
  final int count;
  @JsonKey(defaultValue: [])
  final List<T> results;
  @JsonKey(name: 'next', defaultValue: false, fromJson: _hasNextFromJson)
  final bool hasNext;

  factory DefaultPage.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$DefaultPageFromJson<T>(json, fromJsonT);

  factory DefaultPage.initState() => DefaultPage(results: List<T>.empty(), hasNext: true, count: 0);

  const DefaultPage({
    required this.count,
    required this.results,
    required this.hasNext,
  });

  DefaultPage<T> copyWith({
    int? count,
    List<T>? results,
    bool? hasNext,
  }) {
    return DefaultPage<T>(
      count: count ?? this.count,
      results: results ?? this.results,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}

bool _hasNextFromJson(Object? json) {
  return json != null;
}
//
// @immutable
// final class Test<T> {
//   final int count;
//   final List<T> results;
//   final bool hasNext;
//
//   Test({
//     required this.count,
//     required List<T> results,
//     required this.hasNext,
//   }) : results = List<T>.unmodifiable(results);
//
//   factory Test.fromJson(Map<String, dynamic> json, T Function(Map<String,dynamic> jsonT) fromJsonT) {
//     return Test(
//       count: (json['count'] as num?)?.toInt() ?? 0,
//       results: (json['results'] as List<dynamic>?)?.map<T>((e) => fromJsonT(e as Map<String,dynamic>)).toList() ?? [],
//       hasNext: json['next'] != null,
//     );
//   }
//
//   factory Test.initState() => Test(count: 0, results: List<T>.empty(), hasNext: false);
// }
