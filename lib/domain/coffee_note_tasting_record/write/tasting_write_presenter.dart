import 'dart:convert';
import 'dart:typed_data';

import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/coffee_bean_extraction.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/coffee_bean_processing.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';

final class TastingWritePresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  final PhotoApi photoApi = PhotoApi();
  List<Uint8List> imageData = [];
  TasteReview _tasteReview = TasteReview.empty();
  CoffeeBean _coffeeBean = CoffeeBean.empty();
  List<CoffeeBeanProcessing> _coffeeBeanProcessingList = [];
  String? _writtenByUserProcessing;
  CoffeeBeanExtraction? _coffeeBeanExtraction;
  String? _writtenByUserExtraction;
  String _contents = '';
  String _hashTag = '';
  bool _isPrivate = false;

  List<CoffeeBeanProcessing> get currentProcess => _coffeeBeanProcessingList;

  CoffeeBeanExtraction? get extraction => _coffeeBeanExtraction;

  bool get isValidFirstPage =>
      (_coffeeBean.name?.isNotEmpty ?? false) && _coffeeBean.type != null && (_coffeeBean.country?.isNotEmpty ?? false);

  bool get isValidSecondPage =>
      _tasteReview.flavors.isNotEmpty &&
      _tasteReview.body != 0 &&
      _tasteReview.acidity != 0 &&
      _tasteReview.bitterness != 0 &&
      _tasteReview.sweetness != 0;

  bool get isValidLastPage => _tasteReview.star > 0 && _contents.length > 7;

  bool get isOfficial => _coffeeBean.isOfficial ?? false;

  String get name => _coffeeBean.name ?? '';

  CoffeeBeanType? get coffeeBeanType => _coffeeBean.type;

  bool? get isDecaf => _coffeeBean.isDecaf;

  List<String> get originCountry => _coffeeBean.country ?? [];

  int? get roastingPoint => _coffeeBean.roastPoint;

  bool? get isIce => _coffeeBean.beverageType;

  List<String> get taste => _tasteReview.flavors;

  int get bodyValue => _tasteReview.body;

  int get acidityValue => _tasteReview.acidity;

  int get bitternessValue => _tasteReview.bitterness;

  int get sweetnessValue => _tasteReview.sweetness;

  String get tastedAt => _tasteReview.tastedAt;

  bool get isPrivate => _isPrivate;

  String get place => _tasteReview.place;

  int get star => _tasteReview.star.toInt();

  initState() {}

  secondPageInitState() {
    _tasteReview = TasteReview.empty();
    notifyListeners();
  }

  lastPageInitState() {
    _contents = '';
    _hashTag = '';
    _tasteReview = _tasteReview.copyWith(star: 0, place: '', tastedAt: DateTime.now().toDefaultString());
    _isPrivate = false;
    notifyListeners();
  }

  Future<Result<String>> write() async {
    final extraction = _coffeeBeanExtraction;
    switch (extraction) {
      case CoffeeBeanExtraction.writtenByUser:
        _coffeeBean = _coffeeBean.copyWith(extraction: _writtenByUserExtraction);
        break;
      default:
        _coffeeBean = _coffeeBean.copyWith(extraction: extraction.toString());
        break;
    }
    final processing = _coffeeBeanProcessingList
        .map((processing) {
          switch (processing) {
            case CoffeeBeanProcessing.writtenByUser:
              return _writtenByUserProcessing;
            default:
              return processing.toString();
          }
        })
        .whereType<String>()
        .toList();
    _coffeeBean = _coffeeBean.copyWith(process: processing);
    final List<int> imageCreatedResult = await _uploadImages();
    if (imageCreatedResult.isEmpty) return Result.error('사진 등록 실패.');

    return _tastedRecordRepository
        .create(
          content: _contents,
          isPrivate: isPrivate,
          tag: _hashTag,
          coffeeBean: _coffeeBean,
          tasteReview: _tasteReview,
          photos: imageCreatedResult,
        )
        .then((value) => Result.success('시음기록 작성 성공'))
        .onError((error, stackTrace) => Result.error('시음기록 작성에 실패했습니다.'));
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
    _coffeeBeanProcessingList = List.empty();
    _writtenByUserProcessing = null;
    _coffeeBean = CoffeeBean.empty();
    notifyListeners();
  }

  onSelectedCoffeeBean(CoffeeBean? coffeeBean) {
    final processing = coffeeBean?.process;

    if (processing != null && processing.isNotEmpty) {
      _coffeeBeanProcessingList = List.from(
        processing.map((e) => CoffeeBeanProcessing.fromString(e)).whereType<CoffeeBeanProcessing>(),
      );
    } else {
      _coffeeBeanProcessingList = List.empty();
    }

    _coffeeBean = coffeeBean?.copyWith() ?? CoffeeBean.empty();
    notifyListeners();
  }

  onSelectedCoffeeBeanName(String? name) {
    _coffeeBean = CoffeeBean.empty().copyWith(name: name, isUserCreated: true, isOfficial: false);
    notifyListeners();
  }

  onChangeType(CoffeeBeanType? beanType) {
    if (beanType == CoffeeBeanType.singleOrigin) {
      _coffeeBean = _coffeeBean.copyWith(type: beanType);
    } else {
      _coffeeBeanProcessingList = List.empty();
      _writtenByUserProcessing = null;
      _coffeeBean = _coffeeBean.copyWith(type: beanType, region: null, variety: null, process: null, roastPoint: null);
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

  onSelectProcess(CoffeeBeanProcessing process) {
    if (_coffeeBeanProcessingList.contains(process)) {
      _coffeeBeanProcessingList = List.from(_coffeeBeanProcessingList)..remove(process);
      if (process == CoffeeBeanProcessing.writtenByUser) {
        _writtenByUserProcessing = null;
      }
    } else {
      _coffeeBeanProcessingList = List.from(_coffeeBeanProcessingList)..add(process);
    }
    notifyListeners();
  }

  onChangeProcessText(String process) {
    _writtenByUserProcessing = process;
  }

  onChangeExtraction(CoffeeBeanExtraction extraction) {
    if (_coffeeBeanExtraction == extraction) {
      _coffeeBeanExtraction = null;
      if (extraction == CoffeeBeanExtraction.writtenByUser) {
        _writtenByUserExtraction = null;
      }
    } else {
      _coffeeBeanExtraction = extraction;
    }
    notifyListeners();
  }

  onChangeExtractionText(String extraction) {
    _writtenByUserExtraction = extraction;
  }

  onChangeBeverageType(bool? isIce) {
    _coffeeBean = _coffeeBean.copyWith(beverageType: isIce);
    notifyListeners();
  }

  onChangeTaste(List<String> taste) {
    _tasteReview = _tasteReview.copyWith(flavors: taste);
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
    _tasteReview = _tasteReview.copyWith(tastedAt: dateTime.toDefaultString());
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
