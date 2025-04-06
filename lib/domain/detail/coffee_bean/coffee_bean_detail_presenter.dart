import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_detail.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';

typedef BeanInfoState = ({
  String name,
  String type,
  bool isDecaf,
  String imageUrl,
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
  bool _isEmpty = false;
  CoffeeBeanDetail? _coffeeBeanDetail;
  DefaultPage<TastedRecordInCoffeeBean> _page = DefaultPage.initState();
  List<RecommendedCoffeeBean> _recommendedCoffeeBeanList = [];

  bool get isEmpty => _isEmpty;

  String get name => _coffeeBeanDetail?.name ?? '';

  bool get isSaved => _coffeeBeanDetail?.isUserNoted ?? false;

  BeanInfoState get beanInfoState => (
        name: _coffeeBeanDetail?.name ?? '',
        type: (_coffeeBeanDetail?.type ?? CoffeeBeanType.singleOrigin).toString(),
        isDecaf: _coffeeBeanDetail?.isDecaf ?? false,
        imageUrl: _coffeeBeanDetail?.imageUrl ?? '',
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

  DefaultPage<TastedRecordInCoffeeBean> get page => _page;

  List<RecommendedCoffeeBean> get recommendedCoffeeBeanList => _recommendedCoffeeBeanList;

  CoffeeBeanDetailPresenter({
    required this.id,
  });

  initState() {
    fetchCoffeeBean();
    fetchTastedRecords();
    fetchRecommendedCoffeeBeans();
  }

  refresh() {
    fetchCoffeeBean();
    fetchTastedRecords();
    fetchRecommendedCoffeeBeans();
  }

  fetchCoffeeBean() async {
    _coffeeBeanDetail = await _coffeeBeanRepository
        .fetchCoffeeBeanDetail(id: id)
        .then((value) => Future<CoffeeBeanDetail?>.value(value))
        .catchError((e) => null);
    if (_coffeeBeanDetail == null) {
      _isEmpty = true;
    }
    notifyListeners();
  }

  fetchTastedRecords() async {
    if (_page.hasNext) {
      final newPage = await _coffeeBeanRepository.fetchTastedRecordsForCoffeeBean(id: id);
      _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext, count: newPage.count);
      notifyListeners();
    }
  }

  fetchRecommendedCoffeeBeans() async {
    _recommendedCoffeeBeanList = List.from(await _coffeeBeanRepository.fetchRecommendedCoffeeBean());
    notifyListeners();
  }

  Future<void> onTapSave() {
    return _coffeeBeanRepository.save(id: id, isSaved: isSaved).then((_) {
      _coffeeBeanDetail = _coffeeBeanDetail?.copyWith(isUserNoted: !isSaved);
      notifyListeners();
    });
  }

  String? _roastingPointToString(int? roastingPoint) {
    if (roastingPoint == 1) {
      return '라이트';
    } else if (roastingPoint == 2) {
      return '라이트 미디엄';
    } else if (roastingPoint == 3) {
      return '미디';
    } else if (roastingPoint == 4) {
      return '미디엄 다크';
    } else if (roastingPoint == 5) {
      return '다크';
    } else {
      return null;
    }
  }
}
