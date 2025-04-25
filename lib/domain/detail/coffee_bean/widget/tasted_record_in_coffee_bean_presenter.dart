import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/model/events/tasted_record_event.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';

final class TastedRecordInCoffeeBeanPresenter extends Presenter {
  TastedRecordInCoffeeBean _tastedRecordInCoffeeBean;
  late final StreamSubscription _tastedRecordSub;

  int get id => _tastedRecordInCoffeeBean.id;

  String get authorNickname => _tastedRecordInCoffeeBean.nickname;

  double get rating => _tastedRecordInCoffeeBean.rating.toDouble();

  List<String> get flavors => _tastedRecordInCoffeeBean.flavors;

  String get imageUrl => _tastedRecordInCoffeeBean.photoUrl;

  String get contents => _tastedRecordInCoffeeBean.contents;

  TastedRecordInCoffeeBeanPresenter({
    required TastedRecordInCoffeeBean tastedRecordInCoffeeBean,
  }) : _tastedRecordInCoffeeBean = tastedRecordInCoffeeBean {
    _tastedRecordSub = EventBus.instance.on<TastedRecordEvent>().listen(onTastedRecordEvent);
  }

  onTastedRecordEvent(TastedRecordEvent event) {
    switch (event) {
      case TastedRecordUpdateEvent():
        if (event.senderId != presenterId && event.id == _tastedRecordInCoffeeBean.id) {
          final updateModel = event.updateModel;
          _tastedRecordInCoffeeBean = _tastedRecordInCoffeeBean.copyWith(
            contents: updateModel.contents,
            rating: updateModel.tasteReview.star,
            flavors: List.from(updateModel.tasteReview.flavors),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _tastedRecordSub.cancel();
    super.dispose();
  }
}
