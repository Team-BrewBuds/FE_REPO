import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_detail.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/events/coffee_bean_event.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';

typedef BeanInfoState = ({
  String name,
  String type,
  bool isDecaf,
  String imagePath,
  double rating,
  List<String> flavors
});
typedef BeanDetailState = ({
  List<String>? country,
  String? region,
  String? variety,
  List<String>? process,
  String? roastPoint,
  String? roastery,
  String? extraction,
});
typedef BeanTasteState = ({int body, int acidity, int bitterness, int sweetness});

final class CoffeeBeanDetailPresenter extends Presenter {
  final CoffeeBeanRepository _coffeeBeanRepository = CoffeeBeanRepository.instance;
  final int id;
  late final StreamSubscription _coffeeBeanSub;
  bool _isLoading = false;
  bool _isEmpty = false;
  CoffeeBeanDetail? _coffeeBeanDetail;
  List<RecommendedCoffeeBean> _recommendedCoffeeBeanList = [];

  bool get isEmpty => _isEmpty;

  bool get isLoading => _isLoading;

  String get name => _coffeeBeanDetail?.name ?? '';

  bool get isSaved => _coffeeBeanDetail?.isUserNoted ?? false;

  BeanInfoState get beanInfoState => (
        name: _coffeeBeanDetail?.name ?? '',
        type: (_coffeeBeanDetail?.type ?? CoffeeBeanType.singleOrigin).toString(),
        isDecaf: _coffeeBeanDetail?.isDecaf ?? false,
        imagePath: _coffeeBeanDetail?.imagePath ?? '',
        rating: _coffeeBeanDetail?.rating ?? 0,
        flavors: _coffeeBeanDetail?.flavors ?? [],
      );

  BeanDetailState get beanDetailState => (
        country: _coffeeBeanDetail?.country,
        region: _coffeeBeanDetail?.region,
        variety: _coffeeBeanDetail?.variety,
        process: _coffeeBeanDetail?.process?.split(',').where((element) => element.isNotEmpty).toList(),
        roastPoint: _roastingPointToString(_coffeeBeanDetail?.roastPoint),
        roastery: _coffeeBeanDetail?.roastery,
        extraction: _coffeeBeanDetail?.extraction,
      );

  BeanTasteState get beanTasteState => (
        body: _coffeeBeanDetail?.body ?? 0,
        acidity: _coffeeBeanDetail?.acidity ?? 0,
        bitterness: _coffeeBeanDetail?.bitterness ?? 0,
        sweetness: _coffeeBeanDetail?.sweetness ?? 0,
      );

  List<TopFlavor> get topFlavors => _coffeeBeanDetail?.topFlavors ?? [];

  List<RecommendedCoffeeBean> get recommendedCoffeeBeanList => _recommendedCoffeeBeanList;

  CoffeeBeanDetailPresenter({
    required this.id,
  }) {
    _coffeeBeanSub = EventBus.instance.on<CoffeeBeanSavedEvent>().listen(onCoffeeBeanEvent);
    initState();
  }

  onCoffeeBeanEvent(CoffeeBeanSavedEvent event) {
    if (event.senderId != presenterId && id == event.id && _coffeeBeanDetail != null) {
      _coffeeBeanDetail = _coffeeBeanDetail?.copyWith(isUserNoted: event.isSaved);
      notifyListeners();
    }
  }

  initState() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchCoffeeBean(),
      fetchRecommendedCoffeeBeans(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  @override
  dispose() {
    _coffeeBeanSub.cancel();
    super.dispose();
  }

  refresh() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchCoffeeBean(),
      fetchRecommendedCoffeeBeans(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCoffeeBean() async {
    _coffeeBeanDetail = await _coffeeBeanRepository
        .fetchCoffeeBeanDetail(id: id)
        .then((value) => Future<CoffeeBeanDetail?>.value(value))
        .catchError((e) => null);
    if (_coffeeBeanDetail == null) {
      _isEmpty = true;
    }
  }

  Future<void> fetchRecommendedCoffeeBeans() async {
    _recommendedCoffeeBeanList = List.from(await _coffeeBeanRepository.fetchRecommendedCoffeeBean());
  }

  Future<void> onTapSave() async {
    final isSaved = this.isSaved;
    _coffeeBeanDetail = _coffeeBeanDetail?.copyWith(isUserNoted: !isSaved);
    notifyListeners();

    try {
      await _coffeeBeanRepository.save(id: id, isSaved: isSaved);
    } catch (e) {
      _coffeeBeanDetail = _coffeeBeanDetail?.copyWith(isUserNoted: isSaved);
      notifyListeners();
    }
  }

  String? _roastingPointToString(int? roastingPoint) {
    if (roastingPoint == 1) {
      return '라이트';
    } else if (roastingPoint == 2) {
      return '라이트 미디엄';
    } else if (roastingPoint == 3) {
      return '미디엄';
    } else if (roastingPoint == 4) {
      return '미디엄 다크';
    } else if (roastingPoint == 5) {
      return '다크';
    } else {
      return null;
    }
  }
}
