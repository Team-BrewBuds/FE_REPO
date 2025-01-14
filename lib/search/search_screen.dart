import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/search/models/search_subject.dart';
import 'package:brew_buds/search/search_presenter.dart';
import 'package:brew_buds/search/views/search_main_view.dart';
import 'package:brew_buds/search/widgets/coffee_bean_results_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  bool get canShowSearchResultPage => _textEditingController.text.isNotEmpty || _textFieldFocusNode.hasFocus;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _textEditingController = TextEditingController();
    _textFieldFocusNode = FocusNode();
    _textFieldFocusNode.addListener(() {
      setState(() {});
    });
    _textEditingController.addListener(() {
      setState(() {});
    });
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
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
        builder: (BuildContext context, SearchPresenter value, Widget? child) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: _buildAppBar(),
              body: canShowSearchResultPage
                  ? CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          floating: true,
                          titleSpacing: 0,
                          title: _buildFilter(),
                        ),
                        _textEditingController.text.isEmpty
                            ? SliverToBoxAdapter(child: _buildSearchDefaultPage())
                            : SliverToBoxAdapter(child: _buildSearchResult()),
                      ],
                    )
                  : SearchMainView(),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: canShowSearchResultPage ? 121 : 96,
      title: Column(
        children: [
          _buildSearchBar(),
          canShowSearchResultPage ? _buildTabBar() : const SizedBox(height: 24),
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
                    child: InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                      ),
                    )),
                suffixIcon: _textEditingController.text.isNotEmpty
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

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: TabBar(
        controller: _tabController,
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
        tabs: SearchSubject.values
            .map(
              (subject) => Tab(
                text: subject.toString(),
                height: 31,
              ),
            )
            .toList(),
        onTap: (index) {},
      ),
    );
  }

  Widget _buildFilter() {
    if (_tabController.index == 0) {
      return _buildBeanFilterBar();
    } else if (_tabController.index == 1) {
      return _buildBuddyFilter();
    } else if (_tabController.index == 2) {
      return _buildBeanFilterBar();
    } else {
      return _buildPostFilter();
    }
  }

  Widget _buildBeanFilterBar() {
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

  Widget _buildBuddyFilter() {
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

  Widget _buildPostFilter() {
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

  Widget _buildSearchDefaultPage() {
    final List<String> _recentSearchWordsDummy = ['게샤 워시드', '에티오피아', 'G1', '예카체프', '원두추천'];
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('최근 검색어', style: TextStyles.title02SemiBold),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Text('모두 지우기', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50)),
              )
            ],
          ),
          const SizedBox(height: 24),
          ..._recentSearchWordsDummy
              .map(
                (word) => InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/search.svg',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(word, style: TextStyles.bodyRegular)),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/x.svg',
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .separator(separatorWidget: const SizedBox(height: 8)),
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    if (_tabController.index == 0) {
      return _buildCoffeeBeanSearchResult();
    } else if (_tabController.index == 1) {
      return _buildBuddySearchResult();
    } else if (_tabController.index == 2) {
      return _buildTastedRecordSearchResult();
    } else {
      return _buildPostSearchResult();
    }
  }

  Widget _buildCoffeeBeanSearchResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: coffeeBeanDummy
          .map((searchResult) {
            return CoffeeBeanResultsItem(
              beanName: searchResult.$1,
              rating: searchResult.$2,
              recordCount: searchResult.$3,
            );
          })
          .separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20))
          .toList(),
    );
  }

  Widget _buildBuddySearchResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buddyDummy
          .map((searchResult) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffd9d9d9),
                    ),
                    child: Image.network(
                      searchResult.$1,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${searchResult.$2}',
                          style: TextStyles.labelMediumMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              '팔로워 ${searchResult.$3}',
                              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                            ),
                            const SizedBox(width: 4),
                            Container(width: 1, height: 10, color: ColorStyles.gray30),
                            const SizedBox(width: 4),
                            Text(
                              '시음기록 ${searchResult.$4}',
                              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })
          .separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20))
          .toList(),
    );
  }

  Widget _buildTastedRecordSearchResult() {
    return Column(
      children: tastedRecordDummy
          .map(
            (result) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Text(
                              result.$2,
                              style: TextStyles.title01Bold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/star_fill.svg',
                                  height: 16,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                ),
                                Text(
                                  '${result.$3}',
                                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const SizedBox(width: 2),
                                Container(width: 1, height: 10, color: ColorStyles.gray30),
                                const SizedBox(width: 2),
                                Text(
                                  '${result.$4}',
                                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: result.$5
                                  .map(
                                    (taste) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: ColorStyles.gray70, width: 0.8),
                                            borderRadius: BorderRadius.circular(6)),
                                        child: Center(
                                          child: Text(
                                            taste,
                                            style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  .separator(separatorWidget: const SizedBox(width: 2))
                                  .toList(),
                            )
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 64,
                          width: 64,
                          color: const Color(0xffd9d9d9),
                          child: Image.network(
                            result.$1,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                    if (result.$6.isNotEmpty) ...[
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray20,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 18.2 / 14,
                              letterSpacing: -0.02,
                              color: ColorStyles.black,
                            ),
                            children: _getSpans(result.$6, '에티오피아', TextStyles.labelSmallSemiBold),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          )
          .separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20))
          .toList(),
    );
  }

  Widget _buildPostSearchResult() {
    return Column(
      children: postDummy
          .map(
            (result) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                                children: _getSpans(result.$1, '에티오피아', TextStyles.title01Bold),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                                children: _getSpans(
                                  result.$2,
                                  '에티오피아',
                                  TextStyles.bodyNarrowRegular.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/like.svg',
                                  height: 16,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                                ),
                                Text(
                                  '${result.$3}',
                                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const SizedBox(width: 4),
                                SvgPicture.asset(
                                  'assets/icons/message.svg',
                                  height: 16,
                                  width: 16,
                                  colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                                ),
                                Text(
                                  '${result.$4}',
                                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${result.$5}',
                                  style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                                ),
                                const SizedBox(width: 4),
                                Container(width: 1, height: 10, color: ColorStyles.gray30),
                                const SizedBox(width: 4),
                                Text(
                                  '${result.$6}',
                                  style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                                ),
                                const SizedBox(width: 4),
                                Container(width: 1, height: 10, color: ColorStyles.gray30),
                                const SizedBox(width: 4),
                                Text(
                                  '${result.$7}',
                                  style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                                ),
                                const SizedBox(width: 4),
                                Container(width: 1, height: 10, color: ColorStyles.gray30),
                                const SizedBox(width: 4),
                                Text(
                                  '${result.$8}',
                                  style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 64,
                          width: 64,
                          color: const Color(0xffd9d9d9),
                          child: Image.network(
                            result.$1,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )
          .separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20))
          .toList(),
    );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

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
