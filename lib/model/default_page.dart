import 'package:json_annotation/json_annotation.dart';

part 'default_page.g.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class DefaultPage<T> {
  @JsonKey(name: 'results', defaultValue: []) final List<T> result;
  @JsonKey(name: 'next', defaultValue: false, fromJson: _hasNextFromJson) final bool hasNext;

  DefaultPage(this.result, this.hasNext);

  factory DefaultPage.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$DefaultPageFromJson<T>(json, fromJsonT);
}

bool _hasNextFromJson(Object? json) {
  return json != null;
}