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
