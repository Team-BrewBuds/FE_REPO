import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/search/core/search_mixin.dart';
import 'package:brew_buds/domain/search/search_home_presenter.dart';
import 'package:brew_buds/domain/search/widgets/coffee_beans_ranking_list.dart';
import 'package:brew_buds/domain/search/widgets/recent_search_words_list.dart';
import 'package:brew_buds/domain/search/widgets/recommended_coffee_beans_list.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:flutter/cupertino.dart';
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
  int get initialIndex => 0;

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
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () {
            return context.read<SearchHomePresenter>().onRefresh();
          },
          builder: (
            BuildContext context,
            RefreshIndicatorMode refreshState,
            double pulledExtent,
            double refreshTriggerPullDistance,
            double refreshIndicatorExtent,
          ) {
            switch (refreshState) {
              case RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh:
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: const Center(
                    child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                  ),
                );
              default:
                return Container();
            }
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final recentSearchWords = context.select<SearchHomePresenter, List<String>>(
                (presenter) => presenter.recentSearchWords,
              );
              return RecentSearchWordsList(
                itemLength: recentSearchWords.length,
                isLoading: context.select<SearchHomePresenter, bool>(
                  (presenter) => presenter.isLoadingRecentSearchWords,
                ),
                itemBuilder: (index) {
                  return (
                    word: recentSearchWords[index],
                    onTap: () {
                      onComplete(recentSearchWords[index]);
                    },
                    onDelete: () {
                      context.read<SearchHomePresenter>().removeAtRecentSearchWord(index);
                    },
                  );
                },
                onAllDelete: () {
                  context.read<SearchHomePresenter>().removeAllRecentSearchWord();
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final recommendedBeanList = context.select<SearchHomePresenter, List<RecommendedCoffeeBean>>(
                (presenter) => presenter.recommendedBeanList,
              );
              return RecommendedCoffeeBeansList(
                itemLength: recommendedBeanList.length,
                isLoading: context.select<SearchHomePresenter, bool>(
                  (presenter) => presenter.isLoadingRecommendedBeanList,
                ),
                itemBuilder: (index) {
                  final recommendedBean = recommendedBeanList[index];
                  return (
                    imgaeUrl: recommendedBean.imageUrl,
                    name: recommendedBean.name,
                    rating: recommendedBean.rating,
                    recordCount: recommendedBean.recordCount,
                    onTapped: () {
                      showCoffeeBeanDetail(context: context, id: recommendedBean.id);
                    },
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<SearchHomePresenter, List<String>>(
            selector: (context, presenter) => presenter.beanRankingList,
            builder: (context, beanRankingList, child) => beanRankingList.isNotEmpty
                ? CoffeeBeansRankingList(
                    coffeeBeansRank: beanRankingList,
                    updatedAt: '10.27 16:00 업데이트',
                  )
                : const SizedBox.shrink(),
          ),
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
  onComplete(String searchWord) {
    final SearchResultInitState state = (searchWord: searchWord, tabIndex: tabController.index);
    context.read<SearchHomePresenter>().onComplete(searchWord);
    context.push('/search/result', extra: state).then((_) {
      onTappedCancelButton();
      onRefresh();
    });
  }

  onRefresh() {
    context.read<SearchHomePresenter>().onRefresh();
  }
}
