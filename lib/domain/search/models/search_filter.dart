import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/search/models/search_sort_criteria.dart';
import 'package:brew_buds/model/post/post_subject.dart';

sealed class SearchFilter {
  SearchSortCriteria get sortCriteria;

  bool get hasFilter;

  factory SearchFilter.coffeeBean({
    SearchSortCriteria? sortCriteria,
    List<CoffeeBeanFilter>? filters,
  }) =>
      CoffeeBeanSearchFilter(sortCriteria: sortCriteria ?? SearchSortCriteria.avgStar, filters: filters ?? []);

  factory SearchFilter.buddy({
    SearchSortCriteria? sortCriteria,
  }) =>
      BuddySearchFilter(sortCriteria: sortCriteria ?? SearchSortCriteria.followerCnt);

  factory SearchFilter.tastedRecord({
    SearchSortCriteria? sortCriteria,
    List<CoffeeBeanFilter>? filters,
  }) =>
      TastedRecordSearchFilter(sortCriteria: sortCriteria ?? SearchSortCriteria.latest, filters: filters ?? []);

  factory SearchFilter.post({
    SearchSortCriteria? sortCriteria,
    PostSubject? subject,
  }) =>
      PostSearchFilter(sortCriteria: sortCriteria ?? SearchSortCriteria.latest, subject: subject);
}

class CoffeeBeanSearchFilter implements SearchFilter {
  @override
  final SearchSortCriteria sortCriteria;
  final List<CoffeeBeanFilter> filters;

  @override
  bool get hasFilter => filters.isNotEmpty;

  const CoffeeBeanSearchFilter({
    required this.sortCriteria,
    required this.filters,
  });
}

class BuddySearchFilter implements SearchFilter {
  @override
  final SearchSortCriteria sortCriteria;

  @override
  bool get hasFilter => false;

  const BuddySearchFilter({
    required this.sortCriteria,
  });
}

class TastedRecordSearchFilter implements SearchFilter {
  @override
  final SearchSortCriteria sortCriteria;
  final List<CoffeeBeanFilter> filters;

  @override
  bool get hasFilter => filters.isNotEmpty;

  const TastedRecordSearchFilter({
    required this.sortCriteria,
    required this.filters,
  });
}

class PostSearchFilter implements SearchFilter {
  @override
  final SearchSortCriteria sortCriteria;
  final PostSubject? subject;

  @override
  bool get hasFilter => subject != null;

  const PostSearchFilter({
    required this.sortCriteria,
    this.subject,
  });
}
