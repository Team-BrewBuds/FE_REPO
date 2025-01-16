import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/search/models/search_result_model.dart';
import 'package:brew_buds/search/search_presenter.dart';
import 'package:brew_buds/search/widgets/buddy_results_item.dart';
import 'package:brew_buds/search/widgets/coffee_bean_results_item.dart';
import 'package:brew_buds/search/widgets/coffee_beans_ranking_list.dart';
import 'package:brew_buds/search/widgets/post_results_item.dart';
import 'package:brew_buds/search/widgets/recent_search_words_list.dart';
import 'package:brew_buds/search/widgets/recommended_coffee_beans_list.dart';
import 'package:brew_buds/search/widgets/tatsed_record_results_item.dart';
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

  bool get canShowSearchCancelButton => _textEditingController.text.isNotEmpty;

  bool get canShowSearchResultPage => _textEditingController.text.isNotEmpty || _textFieldFocusNode.hasFocus;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _textEditingController = TextEditingController();
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
      setState(() {});
    });

    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _textEditingController.addListener(() {
        context.read<SearchPresenter>().onChangeSearchWord(_textEditingController.text);
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
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: _buildAppBar(presenter),
              body: canShowSearchResultPage
                  ? CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          titleSpacing: 0,
                          title: _buildFilter(presenter),
                        ),
                        _textEditingController.text.isEmpty
                            ? SliverToBoxAdapter(child: SizedBox.shrink())
                            : SliverToBoxAdapter(child: _buildSearchResult(presenter)),
                      ],
                    )
                  : _buildDefault(presenter),
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
              cursorColor: ColorStyles.gray50,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
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
                contentPadding: const EdgeInsets.only(left: 4, top: 12, bottom: 12, right: 4),
                prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                    )),
                suffixIcon: canShowSearchCancelButton
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 12),
                        child: InkWell(
                          onTap: () {
                            _clearTextField();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/x_round.svg',
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: TabBar(
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: ColorStyles.black, width: 2),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        labelPadding: const EdgeInsets.only(top: 16),
        labelStyle: TextStyles.title01SemiBold,
        labelColor: ColorStyles.black,
        unselectedLabelStyle: TextStyles.title01SemiBold,
        unselectedLabelColor: ColorStyles.gray50,
        dividerHeight: 0,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        tabs: presenter.tabs
            .map(
              (subject) => Tab(
                text: subject.toString(),
                height: 31,
              ),
            )
            .toList(),
        onTap: (index) {
          presenter.onChangeTab(index);
        },
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
        Expanded(
          child: CoffeeBeansRankingList(
            coffeeBeansRank: presenter.coffeeBeansRanking,
            updatedAt: presenter.rankUpdatedAt,
          ),
        ),
      ],
    );
  }

  Widget _buildFilter(SearchPresenter presenter) {
    if (_tabController.index == 0) {
      return _buildBeanFilterBar(presenter);
    } else if (_tabController.index == 1) {
      return _buildBuddyFilter(presenter);
    } else if (_tabController.index == 2) {
      return _buildBeanFilterBar(presenter);
    } else {
      return _buildPostFilter(presenter);
    }
  }

  Widget _buildBeanFilterBar(SearchPresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildIcon(
              onTap: () {},
              text: '별점 높은 순',
              iconPath: 'assets/icons/arrow_up_down.svg',
              isLeftIcon: true,
            ),
            _buildIcon(
              onTap: () {},
              text: '필터',
              iconPath: 'assets/icons/union.svg',
              isLeftIcon: true,
              isActive: false,
            ),
            _buildIcon(
              onTap: () {},
              text: '원두유형',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: false,
            ),
            _buildIcon(
              onTap: () {},
              text: '생산 국가',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: false,
            ),
            _buildIcon(
              onTap: () {},
              text: '평균 별점',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: false,
            ),
            _buildIcon(
              onTap: () {},
              text: '로스팅 포인트',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: false,
            ),
            _buildIcon(
              onTap: () {},
              text: '디카페인',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: false,
            ),
          ].separator(separatorWidget: const SizedBox(width: 4)).toList(),
        ),
      ),
    );
  }

  Widget _buildBuddyFilter(SearchPresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          _buildIcon(
            onTap: () {},
            text: '팔로우 많은 순',
            iconPath: 'assets/icons/arrow_up_down.svg',
            isLeftIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPostFilter(SearchPresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          _buildIcon(
            onTap: () {},
            text: '팔로우 많은 순',
            iconPath: 'assets/icons/arrow_up_down.svg',
            isLeftIcon: true,
          ),
          const SizedBox(width: 4),
          _buildIcon(
            onTap: () {},
            text: '전체',
            iconPath: 'assets/icons/down.svg',
            isLeftIcon: false,
            isActive: false,
          ),
        ],
      ),
    );
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
}
