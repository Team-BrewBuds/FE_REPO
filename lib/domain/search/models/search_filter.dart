import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/model/search_sort_criteria.dart';

sealed class SearchFilter {
  SortCriteria get sortCriteria;
  bool get hasFilter;

  factory SearchFilter.coffeeBean({
    SortCriteria? sortCriteria,
    List<CoffeeBeanFilter>? filters,
  }) => CoffeeBeanSearchFilter(sortCriteria: sortCriteria ?? SortCriteria.rating, filters: filters ?? []);

  factory SearchFilter.buddy({
    SortCriteria? sortCriteria,
  }) => BuddySearchFilter(sortCriteria: sortCriteria ?? SortCriteria.follower);

  factory SearchFilter.tastedRecord({
    SortCriteria? sortCriteria,
    List<CoffeeBeanFilter>? filters,
  }) => TastedRecordSearchFilter(sortCriteria: sortCriteria ?? SortCriteria.upToDate, filters: filters ?? []);

  factory SearchFilter.post({
    SortCriteria? sortCriteria,
    PostSubject? subject,
  }) => PostSearchFilter(sortCriteria: sortCriteria ?? SortCriteria.upToDate, subject: subject);
}

class CoffeeBeanSearchFilter implements SearchFilter {
  final SortCriteria sortCriteria;
  final List<CoffeeBeanFilter> filters;

  @override
  bool get hasFilter => filters.isNotEmpty;

  const CoffeeBeanSearchFilter({
    required this.sortCriteria,
    required this.filters,
  });
}

class BuddySearchFilter implements SearchFilter {
  final SortCriteria sortCriteria;

  @override
  bool get hasFilter => false;

  const BuddySearchFilter({
    required this.sortCriteria,
  });
}

class TastedRecordSearchFilter implements SearchFilter {
  final SortCriteria sortCriteria;
  final List<CoffeeBeanFilter> filters;

  @override
  bool get hasFilter => filters.isNotEmpty;

  const TastedRecordSearchFilter({
    required this.sortCriteria,
    required this.filters,
  });
}

class PostSearchFilter implements SearchFilter {
  final SortCriteria sortCriteria;
  final PostSubject? subject;

  @override
  bool get hasFilter => subject != null;

  const PostSearchFilter({
    required this.sortCriteria,
    this.subject,
  });
}
