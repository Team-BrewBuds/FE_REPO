import 'package:brew_buds/model/coffee_bean_type.dart';

mixin TastingRecordShareMixin {
  String get thumbnailUri;

  CoffeeBeanType get coffeeBeanType;

  String get name;

  String get body;

  double get rating;

  List<String> get tags;
}