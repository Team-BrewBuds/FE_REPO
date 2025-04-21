import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/events/tasted_record_event.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';

final class TastedRecordUpdatePresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  TastedRecord _tastedRecord;

  TastedRecordUpdatePresenter({
    required TastedRecord tastedRecord,
  }) : _tastedRecord = tastedRecord;

  bool get isValidFirstPage =>
      _tastedRecord.tastingReview.flavors.isNotEmpty &&
      _tastedRecord.tastingReview.body != 0 &&
      _tastedRecord.tastingReview.acidity != 0 &&
      _tastedRecord.tastingReview.bitterness != 0 &&
      _tastedRecord.tastingReview.sweetness != 0;

  bool get isValidLastPage =>
      _tastedRecord.tastingReview.star > 0 &&
      _tastedRecord.contents.length > 7 &&
      _tastedRecord.tastingReview.place.isNotEmpty;

  String get contents => _tastedRecord.contents;

  String get tag => _tastedRecord.tag;

  List<String> get images => _tastedRecord.imagesUrl;

  List<String> get taste => _tastedRecord.tastingReview.flavors;

  int get bodyValue => _tastedRecord.tastingReview.body;

  int get acidityValue => _tastedRecord.tastingReview.acidity;

  int get bitternessValue => _tastedRecord.tastingReview.bitterness;

  int get sweetnessValue => _tastedRecord.tastingReview.sweetness;

  String get tastedAt => _tastedRecord.tastingReview.tastedAt;

  String get place => _tastedRecord.tastingReview.place;

  int get star => _tastedRecord.tastingReview.star.toInt();

  Future<bool> update() async {
    try {
      final result = await _tastedRecordRepository
          .update(id: _tastedRecord.id, tastedRecord: _tastedRecord);
      EventBus.instance.fire(TastedRecordUpdateEvent(senderId: presenterId, tastedRecord: result));
      return true;
    } catch (e) {
      return false;
    }
  }

  onChangeTaste(List<String> taste) {
    _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(flavors: taste));
    notifyListeners();
  }

  onChangeBodyValue(int value) {
    if (value == _tastedRecord.tastingReview.body) {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(body: 0));
    } else {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(body: value));
    }
    notifyListeners();
  }

  onChangeAcidityValue(int value) {
    if (value == _tastedRecord.tastingReview.acidity) {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(acidity: 0));
    } else {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(acidity: value));
    }
    notifyListeners();
  }

  onChangeBitternessValue(int value) {
    if (value == _tastedRecord.tastingReview.bitterness) {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(bitterness: 0));
    } else {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(bitterness: value));
    }
    notifyListeners();
  }

  onChangeSweetnessValue(int value) {
    if (value == _tastedRecord.tastingReview.sweetness) {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(sweetness: 0));
    } else {
      _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(sweetness: value));
    }
    notifyListeners();
  }

  onChangeContents(String contents) {
    _tastedRecord = _tastedRecord.copyWith(contents: contents);
    notifyListeners();
  }

  onChangeHashTag(String newHashTag) {
    _tastedRecord = _tastedRecord.copyWith(tag: newHashTag.replaceAll('#', ','));
  }

  onChangeTastedAt(DateTime dateTime) {
    _tastedRecord = _tastedRecord.copyWith(
      tastingReview: _tastedRecord.tastingReview.copyWith(
        tastedAt: dateTime.toDefaultString(),
      ),
    );
    notifyListeners();
  }

  onChangePlace(String place) {
    _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(place: place));
    notifyListeners();
  }

  onChangePrivate(bool isPrivate) {
    _tastedRecord = _tastedRecord.copyWith(isPrivate: isPrivate);
    notifyListeners();
  }

  onChangeStar(int star) {
    _tastedRecord = _tastedRecord.copyWith(tastingReview: _tastedRecord.tastingReview.copyWith(star: star.toDouble()));
    notifyListeners();
  }
}
