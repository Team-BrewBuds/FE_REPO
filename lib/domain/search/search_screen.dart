import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_refresh_control.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/filter/filter_bottom_sheet.dart';
import 'package:brew_buds/domain/filter/filter_presenter.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/sort_criteria_bottom_sheet.dart';
import 'package:brew_buds/domain/search/models/search_sort_criteria.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:brew_buds/domain/search/search_presenter.dart';
import 'package:brew_buds/domain/search/widgets/coffee_beans_ranking_list.dart';
import 'package:brew_buds/domain/search/widgets/recent_search_words_list.dart';
import 'package:brew_buds/domain/search/widgets/recommended_coffee_beans_list.dart';
import 'package:brew_buds/domain/search/widgets/search_result/buddy_results_item.dart';
import 'package:brew_buds/domain/search/widgets/search_result/coffee_bean_results_item.dart';
import 'package:brew_buds/domain/search/widgets/search_result/post_results_item.dart';
import 'package:brew_buds/domain/search/widgets/search_result/search_result_presenter.dart';
import 'package:brew_buds/domain/search/widgets/search_result/tatsed_record_results_item.dart';
import 'package:brew_buds/domain/search/widgets/suggest_word.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_simple.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomTextSelectionControls extends MaterialTextSelectionControls {
  final Color handleColor;
  final Color selectionColor;

  CustomTextSelectionControls({required this.handleColor, required this.selectionColor});

  Color getHandleColor(BuildContext context) {
    return handleColor;
  }

  Color getSelectionColor(BuildContext context) {
    return selectionColor;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final TextEditingController textEditingController;
  late final FocusNode textFieldFocusNode;
  late final Throttle paginationThrottle;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    textEditingController = TextEditingController();
    textFieldFocusNode = FocusNode();
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
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
    tabController.dispose();
    textEditingController.dispose();
    textFieldFocusNode.dispose();
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<SearchPresenter>().fetchMoreData();
  }

  onTapBackButton() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<SearchPresenter>().onTapGoBackState();
    switch (context.read<SearchPresenter>().previousViewState) {
      case SearchState.main:
        textEditingController.value = TextEditingValue.empty;
        tabController.index = 0;
        break;
      case SearchState.suggesting:
        return;
      case SearchState.result:
        textEditingController.value = TextEditingValue(text: context.read<SearchPresenter>().previousSearchWord);
        tabController.animateTo(context.read<SearchPresenter>().previousTabIndex);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Selector<SearchPresenter, SearchState>(
          selector: (context, presenter) => presenter.viewState,
          builder: (context, state, child) {
            switch (state) {
              case SearchState.main:
                return _buildMainView();
              case SearchState.suggesting:
                return _buildSuggestBody();
              case SearchState.result:
                return _buildResultBody();
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
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
            Builder(
              builder: (context) {
                final canBack =
                    context.select<SearchPresenter, bool>((presenter) => presenter.viewState == SearchState.result);
                return canBack
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ThrottleButton(
                          onTap: () {
                            onTapBackButton();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            Expanded(child: buildSearchTextFiled()),
            Builder(
              builder: (context) {
                final canPop =
                    context.select<SearchPresenter, bool>((presenter) => presenter.viewState == SearchState.suggesting);
                return canPop
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ThrottleButton(
                          onTap: () {
                            onTapBackButton();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: ColorStyles.white,
                            child: Text('닫기', style: TextStyles.labelSmallMedium),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchTextFiled() {
    return TextField(
      controller: textEditingController,
      focusNode: textFieldFocusNode,
      maxLines: 1,
      cursorHeight: 16,
      cursorWidth: 1,
      cursorColor: ColorStyles.black,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: '검색어를 입력하세요',
        hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
        fillColor: ColorStyles.gray10,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.gray40),
          borderRadius: BorderRadius.all(Radius.circular(34)),
          gapPadding: 8,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.gray40),
          borderRadius: BorderRadius.all(Radius.circular(34)),
          gapPadding: 8,
        ),
        contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 4),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
          ),
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: textEditingController,
          builder: (context, value, _) {
            final hasWord = value.text.isNotEmpty;
            final canDelete = context.select<SearchPresenter, bool>(
              (presenter) => presenter.viewState == SearchState.suggesting,
            );
            return hasWord && canDelete
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 4),
                    child: ThrottleButton(
                      onTap: clearTextField,
                      child: SvgPicture.asset(
                        'assets/icons/x_round.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
      onTap: () {
        context.read<SearchPresenter>().onChangeViewStateWithSuggesting();
      },
      onTapAlwaysCalled: false,
      onChanged: (text) {
        context.read<SearchPresenter>().onChangeSearchWord(text);
      },
      onSubmitted: (searchWord) {
        FocusManager.instance.primaryFocus?.unfocus();
        onComplete(searchWord);
      },
    );
  }

  Widget _buildMainView() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        MyRefreshControl(
          onRefresh: () {
            return context.read<SearchPresenter>().onRefreshMain();
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final isLoading = context.select<SearchPresenter, bool>(
                (presenter) => presenter.isLoadingSearchHistory,
              );
              final searchHistory = context.select<SearchPresenter, List<String>>(
                (presenter) => presenter.searchHistory,
              );
              return SearchHistoryList(
                itemLength: searchHistory.length,
                isLoading: isLoading,
                itemBuilder: (index) {
                  return (
                    word: searchHistory[index],
                    onTap: () {
                      onSelectedWord(searchHistory[index]);
                    },
                    onDelete: () {
                      context.read<SearchPresenter>().removeSearchHistoryAt(index);
                    },
                  );
                },
                onAllDelete: () {
                  context.read<SearchPresenter>().removeAllSearchHistory();
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final isLoading = context.select<SearchPresenter, bool>(
                (presenter) => presenter.isLoadingRecommendedBeanList,
              );
              final recommendedBeanList = context.select<SearchPresenter, List<RecommendedCoffeeBean>>(
                (presenter) => presenter.recommendedBeanList,
              );
              return RecommendedCoffeeBeansList(
                itemLength: recommendedBeanList.length,
                isLoading: isLoading,
                itemBuilder: (index) {
                  final recommendedBean = recommendedBeanList[index];
                  return (
                  imagePath: recommendedBean.imagePath,
                    name: recommendedBean.name,
                    rating: recommendedBean.rating,
                    recordCount: recommendedBean.recordCount,
                    onTapped: () {
                      ScreenNavigator.showCoffeeBeanDetail(context: context, id: recommendedBean.id);
                    },
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<SearchPresenter, List<CoffeeBeanSimple>>(
            selector: (context, presenter) => presenter.coffeeBeanRanking,
            builder: (context, coffeeBeanRanking, child) => coffeeBeanRanking.isNotEmpty
                ? CoffeeBeansRankingList(coffeeBeansRank: coffeeBeanRanking)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        _buildTabBar(),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: textEditingController,
            builder: (context, controller, child) {
              final isLoading = context.select<SearchPresenter, bool>((presenter) => presenter.isLoadingSuggest);
              final suggestWordList =
                  context.select<SearchPresenter, List<String>>((presenter) => presenter.suggestWordList);
              if (isLoading) {
                return const Center(child: CupertinoActivityIndicator(color: ColorStyles.gray70));
              } else if (suggestWordList.isNotEmpty) {
                return _buildSuggestSearchWords(suggestSearchWords: suggestWordList, searchWord: controller.text);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTabBar(),
        _buildFilter(),
        Expanded(
          child: Builder(
            builder: (context) {
              final hasFilter = context.select<SearchPresenter, bool>((presenter) => presenter.hasFilter);
              final isLoading = context.select<SearchPresenter, bool>((presenter) => presenter.isLoadingSearch);
              final searchResultList = context.select<SearchPresenter, List<SearchResultPresenter>>(
                (presenter) => presenter.searchResultModel,
              );
              final hasNext = context.select<SearchPresenter, bool>((presenter) => presenter.hasNext);

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                    paginationThrottle.setValue(null);
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    MyRefreshControl(onRefresh: () => context.read<SearchPresenter>().onRefreshResult()),
                    if (isLoading && searchResultList.isEmpty)
                      const SliverFillRemaining(
                        child: Center(
                          child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                        ),
                      )
                    else if (searchResultList.isEmpty && !hasFilter)
                      SliverFillRemaining(child: _buildEmpty())
                    else if (searchResultList.isEmpty && hasFilter)
                      SliverFillRemaining(child: _buildEmpty())
                    else
                      _buildSearchResult(searchResultList: searchResultList),
                    if (hasNext)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult({required List<SearchResultPresenter> searchResultList}) {
    return SliverList.separated(
      itemCount: searchResultList.length,
      itemBuilder: (context, index) {
        final searchWord = context.read<SearchPresenter>().searchWord;
        final presenter = searchResultList[index];
        switch (presenter) {
          case TastedRecordSearchResultPresenter():
            return ChangeNotifierProvider.value(
              value: presenter,
              child: TastedRecordResultsItem(searchWord: searchWord),
            );
          case PostSearchResultPresenter():
            return ChangeNotifierProvider.value(
              value: presenter,
              child: PostResultsItem(searchWord: searchWord),
            );
          case CoffeeBeanSearchResultPresenter():
            return ChangeNotifierProvider.value(
              value: presenter,
              child: const CoffeeBeanResultsItem(),
            );
          case BuddySearchResultPresenter():
            return ChangeNotifierProvider.value(
              value: presenter,
              child: const BuddyResultsItem(),
            );
        }
      },
      separatorBuilder: (context, index) => Container(height: 1, color: ColorStyles.gray20),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: TabBar(
        controller: tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: ColorStyles.black),
        ),
        labelPadding: const EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        labelStyle: TextStyles.title01SemiBold,
        labelColor: ColorStyles.black,
        unselectedLabelStyle: TextStyles.title01SemiBold,
        unselectedLabelColor: ColorStyles.gray50,
        dividerHeight: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        tabs: SearchSubject.values
            .map(
              (subject) => Tab(
                height: 16.8,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Center(
                        child: Text(subject.toString(), style: TextStyles.title01SemiBold),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
        onTap: (index) {
          context.read<SearchPresenter>().onChangeTab(index);
        },
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Selector<SearchPresenter, FilterBarState>(
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

  Widget _buildSuggestSearchWords({required List<String> suggestSearchWords, required String searchWord}) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      itemCount: suggestSearchWords.length,
      itemBuilder: (context, index) {
        final word = suggestSearchWords[index];
        return ThrottleButton(
          onTap: () {
            onSelectedWord(word);
          },
          child: SuggestWord(word: word, searchWord: searchWord),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '검색 결과가 없어요',
              style: TextStyles.title01SemiBold,
            ),
            Text(
              '검색어의 철자가 정확한지 확인해 주세요.\n등록되지 않은 원두거나, 해당 검색어와 관련된글이 없으면 검색되지 않을 수 있어요.',
              style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ],
        ),
      ),
    );
  }

  onComplete(String searchWord) {
    context.read<SearchPresenter>().search(searchWord);
  }

  onSelectedWord(String word) {
    textEditingController.value = TextEditingValue(text: word);
    context.read<SearchPresenter>().onChangeSearchWord(word);
    onComplete(word);
  }

  clearTextField() {
    textEditingController.value = TextEditingValue.empty;
    context.read<SearchPresenter>().onChangeSearchWord('');
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
    ];
  }

  Widget _buildPostFilter() {
    return Selector<SearchPresenter, PostFilterState>(
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
      },
    );
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
                  context.read<SearchPresenter>().onChangeSortCriteriaIndex(sortCriteria.$1);
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
              context.read<SearchPresenter>().onChangeCoffeeBeanFilter(filters);
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
                                  context.read<SearchPresenter>().onChangePostSubjectFilter(index);
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
