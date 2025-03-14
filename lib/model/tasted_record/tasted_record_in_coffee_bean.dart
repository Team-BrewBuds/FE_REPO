import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasted_record_in_coffee_bean.freezed.dart';

@freezed
class TastedRecordInCoffeeBean with _$TastedRecordInCoffeeBean {
  const factory TastedRecordInCoffeeBean({
    required int id,
    required String nickname,
    required String contents,
    required String beanName,
    required int rating,
    required CoffeeBeanType beanType,
    required List<String> flavors,
    required String photoUrl,
  }) = _TastedRecordInCoffeeBean;
}
