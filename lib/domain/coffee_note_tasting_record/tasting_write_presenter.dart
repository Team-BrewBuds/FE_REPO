import 'dart:convert';
import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/taste_review.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/tasting_write_state.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_processing.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:flutter/foundation.dart';

final class TastingWritePresenter extends ChangeNotifier {
  final TastedRecordApi tastedRecordApi = TastedRecordApi();
  final PhotoApi photoApi = PhotoApi();
  List<Uint8List> imageData = [];
  TasteReview _tasteReview = TasteReview.initial();
  CoffeeBean _coffeeBean = CoffeeBean.empty();
  String _contents = '';
  String _hashTag = '';
  bool _isPrivate = false;

  CoffeeBeanProcessing? get currentProcess {
    final processText = _coffeeBean.process;
    if (processText != null) {
      return CoffeeBeanProcessing.values.firstWhere(
        (element) => element.toString() == processText,
        orElse: () => CoffeeBeanProcessing.writtenByUser,
      );
    } else {
      return null;
    }
  }

  bool get isValidFirstPage =>
      (_coffeeBean.name?.isNotEmpty ?? false) && _coffeeBean.type != null && (_coffeeBean.country?.isNotEmpty ?? false);

  bool get isValidSecondPage =>
      _tasteReview.flavor.isNotEmpty &&
      _tasteReview.body != 0 &&
      _tasteReview.acidity != 0 &&
      _tasteReview.bitterness != 0 &&
      _tasteReview.sweetness != 0;

  bool get isValidLastPage => _tasteReview.star > 0 && _contents.length > 7 && place.isNotEmpty;

  bool get isOfficial => _coffeeBean.isOfficial ?? false;

  String get name => _coffeeBean.name ?? '';

  CoffeeBeanType? get coffeeBeanType => _coffeeBean.type;

  bool? get isDecaf => _coffeeBean.isDecaf;

  List<String> get originCountry => _coffeeBean.country ?? [];

  int? get roastingPoint => _coffeeBean.roastPoint;

  bool? get isIce => _coffeeBean.beverageType;

  List<String> get taste => _tasteReview.flavor.split(',').where((element) => element.isNotEmpty).toList();

  int get bodyValue => _tasteReview.body;

  int get acidityValue => _tasteReview.acidity;

  int get bitternessValue => _tasteReview.bitterness;

  int get sweetnessValue => _tasteReview.sweetness;

  DateTime get tastedAt => _tasteReview.tastedAt ?? DateTime.now();

  bool get isPrivate => _isPrivate;

  String get place => _tasteReview.place;

  int get star => _tasteReview.star.toInt();

  initState() {}

  secondPageInitState() {
    _tasteReview = TasteReview.initial();
    notifyListeners();
  }

  lastPageInitState() {
    _contents = '';
    _hashTag = '';
    _tasteReview = _tasteReview.copyWith(star: 0, place: '미구현', tastedAt: DateTime.now());
    _isPrivate = false;
    notifyListeners();
  }

  Future<Result<String>> write() async {
    final List<int> imageCreatedResult = await _uploadImages();
    if (imageCreatedResult.isEmpty) return Result.error('사진 등록 실패.');

    final TastingWriteState writeState = TastingWriteState(
      content: _contents,
      isPrivate: _isPrivate,
      tag: _hashTag.isEmpty ? null : _hashTag,
      bean: _coffeeBean,
      tasteReview: _tasteReview,
      photos: imageCreatedResult,
    );

    tastedRecordApi.createTastedRecord(data: writeState.toJson());

    return Result.success('시음기록 작성 성공');
  }

  Future<List<int>> _uploadImages() async {
    final List<Uint8List> compressedImageDataList = [];
    for (final imageData in imageData) {
      compressedImageDataList.add(await compressList(imageData));
    }
    return photoApi.createPhotos(imageDataList: compressedImageDataList).then(
          (jsonString) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        return jsonList.map((json) => json['id'] as int).toList();
      },
    ).onError((error, stackTrace) => []);
  }

  setImageData(List<Uint8List> imageData) {
    this.imageData = List.from(imageData);
    notifyListeners();
  }

  onDeleteBeanName() {
    _coffeeBean = CoffeeBean.empty();
    notifyListeners();
  }

  onSelectedCoffeeBean(CoffeeBean? coffeeBean) {
    _coffeeBean = coffeeBean?.copyWith() ?? CoffeeBean.empty();
    notifyListeners();
  }

  onSelectedCoffeeBeanName(String? name) {
    _coffeeBean = CoffeeBean.empty().copyWith(name: name, isUserCreated: true, isOfficial: false);
    notifyListeners();
  }

  onChangeType(CoffeeBeanType? beanType) {
    if (beanType == CoffeeBeanType.singleOrigin) {
      _coffeeBean = _coffeeBean.copyWith(
        type: beanType,
        country: null,
        region: null,
        variety: null,
        extraction: null,
        roastPoint: null,
      );
    } else {
      _coffeeBean = _coffeeBean.copyWith(type: beanType);
    }
    notifyListeners();
  }

  onChangeIsDecaf(bool isDecaf) {
    _coffeeBean = _coffeeBean.copyWith(isDecaf: isDecaf);
    notifyListeners();
  }

  onChangeCountry(List<String>? country) {
    _coffeeBean = _coffeeBean.copyWith(country: country);
    notifyListeners();
  }

  onChangeRegion(String? region) {
    _coffeeBean = _coffeeBean.copyWith(region: region);
    notifyListeners();
  }

  onChangeVariety(String? variety) {
    _coffeeBean = _coffeeBean.copyWith(variety: variety);
    notifyListeners();
  }

  onChangeRoastingPoint(int? roastingPoint) {
    _coffeeBean = _coffeeBean.copyWith(roastPoint: roastingPoint);
    notifyListeners();
  }

  onChangeRoastery(String? roastery) {
    _coffeeBean = _coffeeBean.copyWith(roastery: roastery);
    notifyListeners();
  }

  onChangeProcess(String? process) {
    _coffeeBean = _coffeeBean.copyWith(process: process);
    notifyListeners();
  }

  onChangeExtraction(String? extraction) {
    _coffeeBean = _coffeeBean.copyWith(extraction: extraction);
    notifyListeners();
  }

  onChangeBeverageType(bool? isIce) {
    _coffeeBean = _coffeeBean.copyWith(beverageType: isIce);
    notifyListeners();
  }

  onChangeTaste(List<String> taste) {
    _tasteReview = _tasteReview.copyWith(flavor: taste.join(','));
    notifyListeners();
  }

  onChangeBodyValue(int value) {
    if (value == _tasteReview.body) {
      _tasteReview = _tasteReview.copyWith(body: 0);
    } else {
      _tasteReview = _tasteReview.copyWith(body: value);
    }
    notifyListeners();
  }

  onChangeAcidityValue(int value) {
    if (value == _tasteReview.acidity) {
      _tasteReview = _tasteReview.copyWith(acidity: 0);
    } else {
      _tasteReview = _tasteReview.copyWith(acidity: value);
    }
    notifyListeners();
  }

  onChangeBitternessValue(int value) {
    if (value == _tasteReview.bitterness) {
      _tasteReview = _tasteReview.copyWith(bitterness: 0);
    } else {
      _tasteReview = _tasteReview.copyWith(bitterness: value);
    }
    notifyListeners();
  }

  onChangeSweetnessValue(int value) {
    if (value == _tasteReview.sweetness) {
      _tasteReview = _tasteReview.copyWith(sweetness: 0);
    } else {
      _tasteReview = _tasteReview.copyWith(sweetness: value);
    }
    notifyListeners();
  }

  onChangeContents(String contents) {
    _contents = contents;
    notifyListeners();
  }

  onChangeHashTag(String newHashTag) {
    _hashTag = newHashTag.replaceAll('#', ',');
  }

  onChangeTastedAt(DateTime dateTime) {
    _tasteReview = _tasteReview.copyWith(tastedAt: dateTime);
    notifyListeners();
  }

  onChangePlace(String place) {
    _tasteReview = _tasteReview.copyWith(place: place);
    notifyListeners();
  }

  onChangePrivate(bool isPrivate) {
    _isPrivate = isPrivate;
    notifyListeners();
  }

  onChangeStar(int star) {
    _tasteReview = _tasteReview.copyWith(star: star.toDouble());
    notifyListeners();
  }
}
