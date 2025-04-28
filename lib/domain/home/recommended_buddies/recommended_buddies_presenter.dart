import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddy_presenter.dart';
import 'package:brew_buds/model/recommended/recommended_category.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';

final class RecommendedBuddiesPresenter extends Presenter {
  final RecommendedCategory _category;
  final List<RecommendedBuddyPresenter> _presenters;

  RecommendedBuddiesPresenter({required RecommendedPage page})
      : _category = page.category,
        _presenters = List.from(page.users.map((e) => RecommendedBuddyPresenter(user: e)));

  String get title => _category.title();

  String get contents => _category.contents();

  List<RecommendedBuddyPresenter> get presenters => List.unmodifiable(_presenters);
}
