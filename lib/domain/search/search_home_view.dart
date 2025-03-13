import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/search/core/search_mixin.dart';
import 'package:brew_buds/domain/search/search_home_presenter.dart';
import 'package:brew_buds/domain/search/widgets/coffee_beans_ranking_list.dart';
import 'package:brew_buds/domain/search/widgets/recent_search_words_list.dart';
import 'package:brew_buds/domain/search/widgets/recommended_coffee_beans_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

typedef SearchResultInitState = ({String searchWord, int tabIndex});

class SearchHomeView extends StatefulWidget {
  const SearchHomeView({super.key});

  @override
  State<SearchHomeView> createState() => _SearchHomeViewState();
}

class _SearchHomeViewState extends State<SearchHomeView>
    with SingleTickerProviderStateMixin, SearchMixin<SearchHomeView, SearchHomePresenter> {
  @override
  String get initialText => '';

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
            Expanded(child: buildSearchTextFiled()),
            if (showSuggestPage) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  onTappedCancelButton();
                },
                child: Text(
                  '취소',
                  style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(child: _buildSearchHome());
  }

  Widget _buildSearchHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Selector<SearchHomePresenter, List<String>>(
          selector: (context, presenter) => presenter.recentSearchWords,
          builder: (context, recentSearchWords, child) => recentSearchWords.isNotEmpty
              ? Column(
                  children: [
                    RecentSearchWordsList(
                      itemLength: recentSearchWords.length,
                      itemBuilder: (index) {
                        return (
                          recentSearchWords[index],
                          () {
                            context.read<SearchHomePresenter>().removeAtSearchRecord(index);
                          },
                        );
                      },
                      onAllDelete: () {
                        context.read<SearchHomePresenter>().removeAllSearchRecord();
                      },
                    ),
                    const SizedBox(height: 28),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Selector<SearchHomePresenter, List<RecommendedBeanState>>(
          selector: (context, presenter) => presenter.recommendedBeanList,
          builder: (context, recommendedBeanList, child) => recommendedBeanList.isNotEmpty
              ? Column(
                  children: [
                    RecommendedCoffeeBeansList(
                      itemLength: recommendedBeanList.length,
                      itemBuilder: (index) {
                        return (
                          recommendedBeanList[index].imageUrl,
                          recommendedBeanList[index].title,
                          recommendedBeanList[index].rating,
                          recommendedBeanList[index].commentsCount,
                          () {
                            //push Detail
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Selector<SearchHomePresenter, List<String>>(
          selector: (context, presenter) => presenter.beanRankingList,
          builder: (context, beanRankingList, child) => beanRankingList.isNotEmpty
              ? CoffeeBeansRankingList(
                  coffeeBeansRank: beanRankingList,
                  updatedAt: '10.27 16:00 업데이트',
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  onTappedCancelButton() {
    textFieldFocusNode.unfocus();
    showSuggestPage.value = false;
    tabController.animateTo(0);
    clearTextField();
  }

  @override
  onComplete() {
    final SearchResultInitState state = (searchWord: textEditingController.text, tabIndex: tabController.index);
    context.push('/search/result', extra: state).then((_) {
      onTappedCancelButton();
    });
  }
}
