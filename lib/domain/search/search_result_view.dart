import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/filter/filter_bottom_sheet.dart';
import 'package:brew_buds/domain/filter/filter_presenter.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/sort_criteria_bottom_sheet.dart';
import 'package:brew_buds/domain/search/core/search_mixin.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';
import 'package:brew_buds/domain/search/models/search_sort_criteria.dart';
import 'package:brew_buds/domain/search/search_result_presenter.dart';
import 'package:brew_buds/domain/search/widgets/buddy_results_item.dart';
import 'package:brew_buds/domain/search/widgets/coffee_bean_results_item.dart';
import 'package:brew_buds/domain/search/widgets/post_results_item.dart';
import 'package:brew_buds/domain/search/widgets/tatsed_record_results_item.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchResultView extends StatefulWidget {
  final int currentTabIndex;
  final String initialText;

  const SearchResultView({
    required this.currentTabIndex,
    required this.initialText,
    super.key,
  });

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView>
    with SingleTickerProviderStateMixin, SearchMixin<SearchResultView, SearchResultPresenter> {
  late final Throttle paginationThrottle;

  @override
  String get initialText => widget.initialText;

  @override
  int get initialIndex => widget.currentTabIndex;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<SearchResultPresenter>().fetchMoreData();
  }

  @override
  AppBar buildAppBar({required bool showSuggestPage}) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      centerTitle: false,
      toolbarHeight: 72,
      title: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Row(
          children: [
            Visibility(
              visible: !showSuggestPage,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: ThrottleButton(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/back.svg',
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
            Expanded(child: buildSearchTextFiled()),
            Visibility(
              visible: showSuggestPage,
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: ThrottleButton(
                  onTap: () {
                    onTappedCancelButton();
                  },
                  child: Text(
                    '취소',
                    style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTabBar(),
        _buildFilter(),
        Expanded(
          child: Builder(
            builder: (context) {
              final isLoading = context.select<SearchResultPresenter, bool>((presenter) => presenter.isLoading);
              final searchResultList = context.select<SearchResultPresenter, List<SearchResultModel>>(
                (presenter) => presenter.resultList,
              );

              if (isLoading && searchResultList.isEmpty) {
                return const Center(child: CupertinoActivityIndicator(color: ColorStyles.gray70));
              } else {
                return searchResultList.isNotEmpty
                    ? _buildSearchResult(searchResultList: searchResultList)
                    : buildEmpty();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult({required List<SearchResultModel> searchResultList}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
          paginationThrottle.setValue(null);
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16, bottom: 20),
        itemCount: searchResultList.length,
        itemBuilder: (context, index) {
          final result = searchResultList[index];
          switch (result) {
            case CoffeeBeanSearchResultModel():
              return _buildBeanResultItem(result);
            case BuddySearchResultModel():
              return _buildUserResultItem(result);
            case TastedRecordSearchResultModel():
              return _buildTastingRecordResultItem(result);
            case PostSearchResultModel():
              return _buildPostResultItem(result);
          }
        },
        separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
      ),
    );
  }

  Widget _buildBeanResultItem(CoffeeBeanSearchResultModel model) {
    return ThrottleButton(
      onTap: () {
        showCoffeeBeanDetail(context: context, id: model.id);
      },
      child: CoffeeBeanResultsItem(
        beanName: model.name,
        rating: model.rating,
        recordCount: model.recordedCount,
        imageUri: model.imageUrl,
      ),
    );
  }

  Widget _buildUserResultItem(BuddySearchResultModel model) {
    return ThrottleButton(
      onTap: () {
        pushToProfile(context: context, id: model.id).then((result) {
          if (result != null) {
            showSnackBar(message: result);
          }
        });
      },
      child: BuddyResultsItem(
        imageUri: model.profileImageUri,
        nickname: model.nickname,
        followerCount: model.followerCount,
        tastedRecordCount: model.tastedRecordsCount,
      ),
    );
  }

  Widget _buildTastingRecordResultItem(TastedRecordSearchResultModel model) {
    return ThrottleButton(
      onTap: () {
        showTastingRecordDetail(context: context, id: model.id).then((result) {
          if (result != null) {
            showSnackBar(message: result);
          }
        });
      },
      child: TastedRecordResultsItem(
        imageUri: model.imageUri,
        beanName: model.title,
        beanType: model.beanType,
        rating: model.rating,
        tasteList: model.taste,
        contents: model.contents,
        searchWord: textEditingController.text,
      ),
    );
  }

  Widget _buildPostResultItem(PostSearchResultModel model) {
    return ThrottleButton(
      onTap: () {
        showPostDetail(context: context, id: model.id).then((result) {
          if (result != null) {
            showSnackBar(message: result);
          }
        });
      },
      child: PostResultsItem(
        title: model.title,
        contents: model.contents,
        searchWord: textEditingController.text,
        likeCount: model.likeCount,
        commentsCount: model.commentCount,
        subject: model.subject,
        createdAt: model.createdAt,
        hits: model.hits,
        writerNickName: model.authorNickname,
        imageUri: model.imageUri,
      ),
    );
  }

  @override
  Widget buildEmpty() {
    return Selector<SearchResultPresenter, bool>(
      selector: (context, presenter) => presenter.hasFilter,
      builder: (context, hasFilter, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  !showSuggestPage.value && hasFilter ? '조건에 맞는 검색 결과가 없어요' : '검색 결과가 없어요',
                  style: TextStyles.title01SemiBold,
                ),
                const SizedBox(height: 8),
                Text(
                  !showSuggestPage.value && hasFilter
                      ? '필터의 조건을 바꾸거나, 적용한 필터의 개수를 줄여보세요.'
                      : '검색어의 철자가 정확한지 확인해 주세요.\n등록되지 않은 원두거나, 해당 검색어와 관련된글이 없으면 검색되지 않을 수 있어요.',
                  style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray50),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  onComplete(String searchWord) {
    showSuggestPage.value = false;
    textFieldFocusNode.unfocus();
    context.read<SearchResultPresenter>().onComplete(searchWord);
  }

  @override
  onTappedCancelButton() {
    textEditingController.value = TextEditingValue(text: context.read<SearchResultPresenter>().previousSearchWord);
    textFieldFocusNode.unfocus();
    tabController.animateTo(context.read<SearchResultPresenter>().previousTabIndex);
    showSuggestPage.value = false;
  }

  Widget _buildFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Selector<SearchResultPresenter, FilterBarState>(
          selector: (context, presenter) => presenter.filterBarState,
          builder: (context, filterBarState, child) {
            return Row(
              spacing: 4,
              children: [
                _buildIcon(
                  onTap: () {
                    showSortCriteriaBottomSheet(
                      sortCriteriaList: filterBarState.currentSortCriteriaList,
                      currentSortCriteriaIndex: filterBarState.currentSortCriteriaIndex,
                    );
                  },
                  text: filterBarState.currentSortCriteria,
                  iconPath: 'assets/icons/arrow_up_down.svg',
                  isLeftIcon: true,
                ),
                if (filterBarState.currentTabIndex == 0 || filterBarState.currentTabIndex == 2)
                  ..._buildBeanFilterBar(filters: filterBarState.filters)
                else if (filterBarState.currentTabIndex == 3)
                  _buildPostFilter()
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBeanFilterBar({required List<CoffeeBeanFilter> filters}) {
    final bool hasFilter = filters.isNotEmpty;
    final bool hasBeanTypeFilter = filters.whereType<BeanTypeFilter>().isNotEmpty;
    final bool hasCountryFilter = filters.whereType<CountryFilter>().isNotEmpty;
    final bool hasRatingFilter = filters.whereType<RatingFilter>().isNotEmpty;
    final bool hasRoastingPointFilter = filters.whereType<RoastingPointFilter>().isNotEmpty;
    final bool hasDecafFilter = filters.whereType<DecafFilter>().isNotEmpty;
    return [
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(0, filters);
        },
        text: '필터',
        iconPath: 'assets/icons/union.svg',
        isLeftIcon: true,
        isActive: hasFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(0, filters);
        },
        text: '원두유형',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: hasBeanTypeFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(1, filters);
        },
        text: '원산지',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: hasCountryFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(2, filters);
        },
        text: '평균 별점',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: hasRatingFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(3, filters);
        },
        text: '디카페인',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: hasDecafFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(4, filters);
        },
        text: '로스팅 포인트',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: hasRoastingPointFilter,
      ),
    ].toList();
  }

  Widget _buildPostFilter() {
    return Selector<SearchResultPresenter, PostFilterState>(
        selector: (context, presenter) => presenter.postFilterState,
        builder: (context, postFilterState, child) {
          return _buildIcon(
            onTap: () {
              showPostSubjectFilterBottomSheet(postFilterState.currentPostSubjectIndex);
            },
            text: postFilterState.currentPostSubject,
            iconPath: 'assets/icons/down.svg',
            isLeftIcon: false,
            isActive: false,
          );
        });
  }

  showSortCriteriaBottomSheet({
    required List<SearchSortCriteria> sortCriteriaList,
    required int currentSortCriteriaIndex,
  }) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: ColorStyles.black50,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return SortCriteriaBottomSheet(
          items: sortCriteriaList.indexed.map(
            (sortCriteria) {
              return (
                sortCriteria.$2.toString(),
                () {
                  context.read<SearchResultPresenter>().onChangeSortCriteriaIndex(sortCriteria.$1);
                },
              );
            },
          ).toList(),
          currentIndex: currentSortCriteriaIndex,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  showFilterBottomSheet(int initialIndex, List<CoffeeBeanFilter> filters) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: ColorStyles.black50,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider<FilterPresenter>(
          create: (_) => FilterPresenter(filter: List.from(filters)),
          child: FilterBottomSheet(
            onDone: (filters) {
              context.read<SearchResultPresenter>().onChangeCoffeeBeanFilter(filters);
            },
            initialTab: initialIndex,
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  showPostSubjectFilterBottomSheet(int initialIndex) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: ColorStyles.black50,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Wrap(
                        children: [
                          Container(
                            height: 59,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1))),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 24,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text('게시글 주제', style: TextStyles.title02SemiBold),
                                  ),
                                ),
                                Positioned(
                                  top: 21,
                                  right: 16,
                                  child: ThrottleButton(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/x.svg',
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                      colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...List<Widget>.generate(
                            PostSubject.values.length,
                            (index) {
                              final subject = PostSubject.values[index];
                              return ThrottleButton(
                                onTap: () {
                                  context.read<SearchResultPresenter>().onChangePostSubjectFilter(index);
                                  context.pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        subject.toString(),
                                        style: TextStyles.labelMediumMedium.copyWith(
                                          color: initialIndex == index ? ColorStyles.red : ColorStyles.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      initialIndex == index
                                          ? const Icon(Icons.check, size: 18, color: ColorStyles.red)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget _buildIcon({
    required void Function() onTap,
    required String text,
    required String iconPath,
    required bool isLeftIcon,
    bool isActive = false,
  }) {
    final iconWidget = SvgPicture.asset(
      iconPath,
      height: 18,
      width: 18,
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(isActive ? ColorStyles.red : ColorStyles.black, BlendMode.srcIn),
    );

    final textWidget = Text(
      text,
      style: TextStyles.captionMediumRegular.copyWith(
        color: isActive ? ColorStyles.red : ColorStyles.black,
      ),
    );
    return ThrottleButton(
      onTap: () {
        onTap.call();
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 4,
          right: isLeftIcon ? 8 : 4,
          bottom: 4,
          left: isLeftIcon ? 4 : 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: isActive ? ColorStyles.red : ColorStyles.gray70, width: 1),
          color: isActive ? ColorStyles.background : ColorStyles.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            isLeftIcon ? iconWidget : textWidget,
            const SizedBox(width: 2),
            isLeftIcon ? textWidget : iconWidget,
          ],
        ),
      ),
    );
  }
}
