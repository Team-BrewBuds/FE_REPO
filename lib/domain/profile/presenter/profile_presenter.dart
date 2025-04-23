import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/profile/model/profile_sort_criteria.dart';
import 'package:brew_buds/model/events/profile_update_event.dart';
import 'package:brew_buds/model/profile/item_in_profile.dart';
import 'package:brew_buds/model/profile/profile.dart';

typedef ProfileState = ({String imageUrl, int tastingRecordCount, int followerCount, int followingCount});
typedef ProfileDetailState = ({List<String> coffeeLife, String introduction, String profileLink});
typedef FilterBarState = ({
  bool canShowFilterBar,
  List<String> sortCriteriaList,
  int currentIndex,
  List<CoffeeBeanFilter> filters,
});

class ProfilePresenter extends Presenter {
  final ProfileRepository repository = ProfileRepository.instance;
  late final StreamSubscription _profileUpdateSub;
  final int _id;
  Profile? profile;
  final List<ItemInProfile> _profileItem = List.empty(growable: true);
  bool _isLoading = false;
  bool _isLoadingData = false;
  int _currentSortCriteriaIndex = 0;
  final List<CoffeeBeanFilter> _filters = [];
  int _tabIndex = 0;
  int _pageNo = 1;
  bool _hasNext = true;

  ProfilePresenter({required int id}) : _id = id {
    _profileUpdateSub = EventBus.instance.on<ProfileUpdateEvent>().listen(onProfileUpdateEvent);
  }

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<ProfileSortCriteria> get sortCriteriaList => switch (_tabIndex) {
        0 => ProfileSortCriteria.tastedRecord(),
        1 => [],
        2 => ProfileSortCriteria.notedCoffeeBean(),
        3 => [],
        int() => throw UnimplementedError(),
      };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  bool get isLoading => _isLoading;

  bool get isLoadingData => _isLoadingData;

  int get id => _id;

  String get nickName => profile?.nickname ?? '';

  int get currentTabIndex => _tabIndex;

  ProfileState get profileState => (
        imageUrl: profile?.profileImageUrl ?? '',
        tastingRecordCount: profile?.tastedRecordCnt ?? 0,
        followerCount: profile?.followerCount ?? 0,
        followingCount: profile?.followingCount ?? 0,
      );

  ProfileDetailState get profileDetailState => (
        coffeeLife: profile?.coffeeLife.map((coffeeLife) => coffeeLife.title).toList() ?? [],
        introduction: profile?.introduction ?? '',
        profileLink: profile?.profileLink ?? '',
      );

  FilterBarState get filterBarState => (
        canShowFilterBar: (_tabIndex == 0 && _profileItem.isNotEmpty) ||
            (_tabIndex == 2 && _profileItem.isNotEmpty),
        sortCriteriaList: sortCriteriaList.map((sortCriteria) => sortCriteria.toString()).toList(),
        currentIndex: _currentSortCriteriaIndex,
        filters: _filters,
      );

  List<ItemInProfile> get items => List.unmodifiable(_profileItem);

  bool get hasNext => _hasNext;

  Future<void> initState() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchProfile(),
      paginate(isPageChanged: true),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchProfile(),
      paginate(isPageChanged: true),
    ]);
    _isLoading = false;
    notifyListeners();
  }

  onProfileUpdateEvent(ProfileUpdateEvent event) {
    if (event.senderId != presenterId && id == event.userId && profile != null) {
      final updatedNickname = event.profileUpdateModel.nickname;
      final updatedIntroduction = event.profileUpdateModel.userDetail.introduction;
      final updatedIsCertificated = event.profileUpdateModel.userDetail.isCertificated;
      final updatedProfileLink = event.profileUpdateModel.userDetail.profileLink;
      final updatedCoffeeLife = event.profileUpdateModel.userDetail.coffeeLife;
      final updatedPreferredBeanTaste = event.profileUpdateModel.userDetail.preferredBeanTaste;
      if (updatedNickname != null) {
        profile = profile?.copyWith(nickname: updatedNickname);
      }
      if (updatedIntroduction != null) {
        profile = profile?.copyWith(introduction: updatedIntroduction);
      }
      if (updatedIsCertificated != null) {
        profile = profile?.copyWith(isCertificated: updatedIsCertificated);
      }
      if (updatedProfileLink != null) {
        profile = profile?.copyWith(profileLink: updatedProfileLink);
      }
      if (updatedCoffeeLife != null) {
        profile = profile?.copyWith(coffeeLife: List.from(updatedCoffeeLife));
      }
      if (updatedPreferredBeanTaste != null) {
        profile = profile?.copyWith(preferredBeanTaste: updatedPreferredBeanTaste.copyWith());
      }
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    profile = await repository.fetchMyProfile();
  }

  Future<void> paginate({bool isPageChanged = false}) async {
    if (isPageChanged) {
      _profileItem.clear();
      _pageNo = 1;
      _hasNext = true;
      notifyListeners();
    }

    if (hasNext) {
      await _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    _isLoadingData = true;
    notifyListeners();

    if (_tabIndex == 0) {
      final nextPage = await repository.fetchTastedRecordPage(
        userId: _id,
        pageNo: _pageNo,
        orderBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toJson(),
        isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
        country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
        roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
        roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
        ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
        ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
      );
      _profileItem.addAll(nextPage.results.map((e) => TastedRecordInProfileItem(data: e)));
      _hasNext = nextPage.hasNext;
      _pageNo++;
      _isLoadingData = false;
      notifyListeners();
    } else if (_tabIndex == 1) {
      final nextPage = await repository.fetchPostPage(userId: _id);
      _profileItem.addAll(nextPage.results.map((e) => PostInProfileItem(data: e)));
      _hasNext = nextPage.hasNext;
      _isLoadingData = false;
      notifyListeners();
    } else if (_tabIndex == 2) {
      final nextPage = await repository.fetchCoffeeBeanPage(
        userId: _id,
        pageNo: _pageNo,
        orderBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
        isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
        country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
        roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
        roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
        ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
        ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
      );
      _profileItem.addAll(nextPage.results.map((e) => SavedBeanInProfileItem(data: e)));
      _hasNext = nextPage.hasNext;
      _pageNo++;
      _isLoadingData = false;
      notifyListeners();
    } else {
      final nextPage = await repository.fetchNotePage(userId: _id, pageNo: _pageNo);
      _profileItem.addAll(nextPage.results.map((e) => SavedNoteInProfileItem(data: e)));
      _hasNext = nextPage.hasNext;
      _pageNo++;
      _isLoadingData = false;
      notifyListeners();
    }
  }

  onChangeTabIndex(int index) {
    if (_tabIndex == index) {
      refresh();
    } else {
      _tabIndex = index;
      _currentSortCriteriaIndex = 0;
      _filters.clear();
      paginate(isPageChanged: true);
    }
    notifyListeners();
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    paginate(isPageChanged: true);
    notifyListeners();
  }

  onChangeFilter(List<CoffeeBeanFilter> newFilters) {
    _filters.clear();
    _filters.addAll(newFilters);
    paginate(isPageChanged: true);
    notifyListeners();
  }
}
