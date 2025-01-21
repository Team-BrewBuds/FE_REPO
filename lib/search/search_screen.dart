import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:brew_buds/profile/view/filter_bottom_sheet.dart';
import 'package:brew_buds/profile/widgets/sort_criteria_bottom_sheet.dart';
import 'package:brew_buds/search/models/search_result_model.dart';
import 'package:brew_buds/search/search_presenter.dart';
import 'package:brew_buds/search/widgets/buddy_results_item.dart';
import 'package:brew_buds/search/widgets/coffee_bean_results_item.dart';
import 'package:brew_buds/search/widgets/coffee_beans_ranking_list.dart';
import 'package:brew_buds/search/widgets/post_results_item.dart';
import 'package:brew_buds/search/widgets/recent_search_words_list.dart';
import 'package:brew_buds/search/widgets/recommended_coffee_beans_list.dart';
import 'package:brew_buds/search/widgets/tatsed_record_results_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _textEditingController;
  late final FocusNode _textFieldFocusNode;
  String _searchHint = '검색어를 입력하세요';

  bool get canShowSearchCancelButton => _textEditingController.text.isNotEmpty;

  bool get canShowSearchResultPage => _textEditingController.text.isNotEmpty || _textFieldFocusNode.hasFocus;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _textEditingController = TextEditingController();
    _textFieldFocusNode = FocusNode();

    _textFieldFocusNode.addListener(() {
      setState(() {
        _searchHint = _searchHint.isEmpty ? '검색어를 입력하세요' : '';
      });
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _textEditingController.addListener(() {
        context.read<SearchPresenter>().onChangeSearchWord(_textEditingController.text);
      });

      _tabController.addListener(() {
        context.read<SearchPresenter>().onChangeTab(_tabController.index);
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_textFieldFocusNode.hasFocus) {
          _textFieldFocusNode.unfocus();
        }
      },
      child: Consumer<SearchPresenter>(
        builder: (BuildContext context, SearchPresenter presenter, Widget? child) {
          return SafeArea(
            child: Scaffold(
              appBar: _buildAppBar(presenter),
              body: _textFieldFocusNode.hasFocus
                  ? _buildSuggest(presenter)
                  : _textEditingController.text.isNotEmpty
                      ? presenter.searchResult.isNotEmpty
                          ? CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  floating: true,
                                  titleSpacing: 0,
                                  title: _buildFilter(presenter),
                                ),
                                SliverToBoxAdapter(
                                  child: _buildSearchResult(presenter),
                                ),
                              ],
                            )
                          : _buildEmptyPage(presenter)
                      : SingleChildScrollView(child: _buildDefault(presenter)),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(SearchPresenter presenter) {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: canShowSearchResultPage ? 121 : 96,
      title: Column(
        children: [
          _buildSearchBar(),
          canShowSearchResultPage ? _buildTabBar(presenter) : const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _clearTextField();
              _textFieldFocusNode.unfocus();
            },
            child: SvgPicture.asset(
              'assets/icons/back.svg',
              height: 24,
              width: 24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _textFieldFocusNode,
              maxLines: 1,
              cursorHeight: 16,
              cursorWidth: 1,
              cursorColor: ColorStyles.black,
              decoration: InputDecoration(
                hintText: _searchHint,
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
                    )),
                suffixIcon: canShowSearchCancelButton
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 4),
                        child: InkWell(
                          onTap: () {
                            _clearTextField();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/x_round.svg',
                            height: 24,
                            width: 24,
                            colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                          ),
                        ))
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(SearchPresenter presenter) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: TabBar(
        controller: _tabController,
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
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        tabs: presenter.tabs
            .map(
              (subject) => Tab(
                height: 16.8,
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Center(
                        child: Text(
                      subject.toString(),
                      style: TextStyles.title01SemiBold,
                    )),
                  );
                }),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDefault(SearchPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RecentSearchWordsList(
          itemLength: presenter.recentSearchWords.length,
          itemBuilder: (index) {
            return (
              presenter.recentSearchWords[index],
              () {
                presenter.onDeleteRecentSearchWord(index);
              },
            );
          },
          onAllDelete: () {
            presenter.onAllDeleteRecentSearchWord();
          },
        ),
        const SizedBox(height: 28),
        RecommendedCoffeeBeansList(
          itemLength: presenter.recommendedCoffeeBeans.length,
          itemBuilder: (index) {
            return (
              '',
              presenter.recommendedCoffeeBeans[index].$1,
              presenter.recommendedCoffeeBeans[index].$2,
              presenter.recommendedCoffeeBeans[index].$3,
              () {
                //push Detail
              },
            );
          },
        ),
        const SizedBox(height: 28),
        CoffeeBeansRankingList(
          coffeeBeansRank: presenter.coffeeBeansRanking,
          updatedAt: presenter.rankUpdatedAt,
        ),
      ],
    );
  }

  Widget _buildSuggest(SearchPresenter presenter) {
    return presenter.suggestWords.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: presenter.suggestWords.isNotEmpty
                      ? ListView.builder(
                          itemCount: presenter.suggestWords.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _textEditingController.text = presenter.suggestWords[index];
                                _textFieldFocusNode.unfocus();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.5),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: RichText(
                                      text: TextSpan(
                                        style: TextStyles.title01SemiBold.copyWith(
                                          color: ColorStyles.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: _getSpans(
                                          presenter.suggestWords[index],
                                          presenter.searchWord,
                                          TextStyles.title01SemiBold.copyWith(
                                            color: ColorStyles.red,
                                          ),
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    presenter.haveSearchedWords.contains(presenter.suggestWords[index])
                                        ? SvgPicture.asset(
                                            'assets/icons/clock.svg',
                                            height: 24,
                                            width: 24,
                                            colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.blue,
                        ),
                ),
              ],
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
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

  Widget _buildFilter(SearchPresenter presenter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildIcon(
              onTap: () {
                showSortCriteriaBottomSheet(presenter);
              },
              text: presenter.currentSortCriteria,
              iconPath: 'assets/icons/arrow_up_down.svg',
              isLeftIcon: true,
            ),
            if (_tabController.index == 0 || _tabController.index == 2)
              ..._buildBeanFilterBar(presenter)
            else if (_tabController.index == 3)
              ..._buildPostFilter(presenter)
          ].separator(separatorWidget: const SizedBox(width: 4)).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildBeanFilterBar(SearchPresenter presenter) {
    return [
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 0);
        },
        text: '필터',
        iconPath: 'assets/icons/union.svg',
        isLeftIcon: true,
        isActive: presenter.hasFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 0);
        },
        text: '원두유형',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: presenter.hasBeanTypeFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 1);
        },
        text: '생산 국가',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: presenter.hasCountryFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 2);
        },
        text: '평균 별점',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: presenter.hasRatingFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 4);
        },
        text: '로스팅 포인트',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: presenter.hasRoastingPointFilter,
      ),
      _buildIcon(
        onTap: () {
          showFilterBottomSheet(presenter, 3);
        },
        text: '디카페인',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: presenter.hasDecafFilter,
      ),
    ].toList();
  }

  List<Widget> _buildPostFilter(SearchPresenter presenter) {
    return [
      _buildIcon(
        onTap: () {},
        text: '전체',
        iconPath: 'assets/icons/down.svg',
        isLeftIcon: false,
        isActive: false,
      ),
    ];
  }

  Widget _buildSearchResult(SearchPresenter presenter) {
    final List<Widget> children = presenter.searchResult
        .map((result) {
          switch (result) {
            case CoffeeBeanSearchResultModel():
              return InkWell(
                onTap: () {
                  //상세페이지 연결
                  print(result.id);
                },
                child: CoffeeBeanResultsItem(
                  beanName: result.name,
                  rating: result.rating,
                  recordCount: result.recordedCount,
                  imageUri: '',
                ),
              );
            case BuddySearchResultModel():
              return InkWell(
                onTap: () {
                  //상세페이지 연결
                  print(result.id);
                },
                child: BuddyResultsItem(
                  imageUri: result.profileImageUri,
                  nickname: result.nickname,
                  followerCount: result.followerCount,
                  tastedRecordCount: result.tastedRecordsCount,
                ),
              );
            case TastedRecordSearchResultModel():
              return InkWell(
                onTap: () {
                  //상세페이지 연결
                  print(result.id);
                },
                child: TastedRecordResultsItem(
                  imageUri: result.imageUri,
                  beanName: result.title,
                  beanType: result.beanType,
                  rating: result.rating,
                  tasteList: result.taste,
                  contents: result.contents,
                  searchWord: _textEditingController.text,
                ),
              );
            case PostSearchResultModel():
              return InkWell(
                onTap: () {
                  //상세페이지 연결
                  print(result.id);
                },
                child: PostResultsItem(
                  title: result.title,
                  contents: result.contents,
                  searchWord: _textEditingController.text,
                  likeCount: result.likeCount,
                  commentsCount: result.commentCount,
                  subject: result.subject,
                  createdAt: result.createdAt,
                  hits: result.hits,
                  writerNickName: result.authorNickname,
                  imageUri: result.imageUri,
                ),
              );
          }
        })
        .separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildEmptyPage(SearchPresenter presenter) {
    final title = presenter.hasFilter ? '조건에 맞는 검색 결과가 없어요' : '검색 결과가 없어요';
    final hint = presenter.hasFilter
        ? '필터의 조건을 바꾸거나, 적용한 필터의 개수를 줄여보세요.'
        : '검색어의 철자가 정확한지 확인해 주세요.\n등록되지 않은 원두거나, 해당 검색어와 관련된글이 없으면 검색되지 않을 수 있어요.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyles.title01SemiBold,
            ),
            const SizedBox(height: 12),
            Text(
              hint,
              style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.longestLine,
            )
          ],
        ),
      ),
    );
  }

  showSortCriteriaBottomSheet(SearchPresenter presenter) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return SortCriteriaBottomSheet(
          items: presenter.sortCriteriaList.indexed.map(
            (sortCriteria) {
              return (
                sortCriteria.$2.toString(),
                () {
                  presenter.onChangeSortCriteriaIndex(sortCriteria.$1);
                },
              );
            },
          ).toList(),
          currentIndex: presenter.currentSortCriteriaIndex,
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

  showFilterBottomSheet(SearchPresenter presenter, int initialIndex) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider<FilterPresenter>(
          create: (_) => FilterPresenter(),
          child: FilterBottomSheet(
            onDone: (filter) {
              presenter.onChangeCoffeeBeanFilter(filter);
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

  _clearTextField() {
    _textEditingController.value = const TextEditingValue();
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
    return InkWell(
      onTap: onTap,
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

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord.isEmpty) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);

      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: textStyle));

      spanBoundary = endIndex;
    } while (spanBoundary < text.length);

    return spans;
  }
}
