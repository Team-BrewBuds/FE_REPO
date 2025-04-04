import 'dart:math';

import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/detail/detail_builder.dart';
import 'package:brew_buds/filter/filter_bottom_sheet.dart';
import 'package:brew_buds/filter/filter_presenter.dart';
import 'package:brew_buds/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/filter/sort_criteria_bottom_sheet.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/profile/model/in_profile/bean_in_profile.dart';
import 'package:brew_buds/profile/model/in_profile/post_in_profile.dart';
import 'package:brew_buds/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:brew_buds/profile/model/saved_note/saved_note.dart';
import 'package:brew_buds/profile/model/saved_note/saved_post.dart';
import 'package:brew_buds/profile/model/saved_note/saved_tasting_record.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/widgets/profile_post_item_widget.dart';
import 'package:brew_buds/profile/widgets/saved_coffee_bean_widget.dart';
import 'package:brew_buds/profile/widgets/saved_post_widget.dart';
import 'package:brew_buds/profile/widgets/saved_tasting_record_widget.dart';
import 'package:brew_buds/profile/widgets/tasting_record_item_widget.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

mixin ProfileMixin<T extends StatefulWidget, Presenter extends ProfilePresenter> on State<T> {
  late final Throttle paginationThrottle;
  final GlobalKey<NestedScrollViewState> scrollKey = GlobalKey<NestedScrollViewState>();

  String get tastingRecordsEmptyText;

  String get postsEmptyText;

  String get beansEmptyText;

  String get savedNotesEmptyText;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Presenter>().initState();
      scrollKey.currentState?.innerController.addListener(_scrollListener);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollKey.currentState?.innerController.removeListener(_scrollListener);
    paginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if ((scrollKey.currentState?.innerController.position.pixels ?? 0) >
        (scrollKey.currentState?.innerController.position.maxScrollExtent ?? 0) * 0.7) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<Presenter>().paginate();
  }

  Widget buildProfileBottomButtons();

  pushFollowList(int index);

  onTappedSettingDetailButton();

  AppBar buildTitle();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: buildTitle(),
        body: Selector<Presenter, bool>(
            selector: (context, presenter) => presenter.isScrollable,
            builder: (context, isScrollable, child) {
              final physics = isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics();
              return NestedScrollView(
                key: scrollKey,
                physics: physics,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  Selector<Presenter, ProfileState>(
                    selector: (context, presenter) => presenter.profileState,
                    builder: (context, profileState, child) => _buildProfile(
                      imageUri: profileState.imageUri,
                      tastingRecordCount: profileState.tastingRecordCount,
                      followerCount: profileState.followerCount,
                      followingCount: profileState.followingCount,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  Selector<Presenter, ProfileDetailState>(
                    selector: (context, presenter) => presenter.profileDetailState,
                    builder: (context, profileDetailState, child) => _buildDetail(
                      coffeeLife: profileDetailState.coffeeLife,
                      introduction: profileDetailState.introduction,
                      profileLink: profileDetailState.profileLink,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: buildProfileBottomButtons(),
                  ),
                ],
                body: SafeArea(
                  child: CustomScrollView(
                    physics: physics,
                    controller: scrollKey.currentState?.innerController,
                    slivers: [
                      _buildTabBar(),
                      Selector<Presenter, FilterBarState>(
                        selector: (context, presenter) => presenter.filterBarState,
                        builder: (context, filterBarState, child) => filterBarState.canShowFilterBar
                            ? _buildFilterBar(
                                sortCriteriaList: filterBarState.sortCriteriaList,
                                currentIndex: filterBarState.currentIndex,
                                filters: filterBarState.filters,
                              )
                            : const SliverToBoxAdapter(child: SizedBox.shrink()),
                      ),
                      buildContentsList(),
                      Selector<Presenter, bool>(
                        selector: (context, presenter) => presenter.hasNext,
                        builder: (context, hasNext, child) => hasNext
                            ? const SliverToBoxAdapter(
                                child: Center(
                                  child: CircularProgressIndicator(color: ColorStyles.gray70),
                                ),
                              )
                            : const SliverToBoxAdapter(child: SizedBox.shrink()),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  SliverToBoxAdapter _buildProfile({
    required String imageUri,
    required int tastingRecordCount,
    required int followerCount,
    required int followingCount,
  }) {
    String countToString(int count) {
      if (count == 0) {
        return '000';
      } else if (count >= 1000 && count < 1000000) {
        return '${count / 1000}.${count / 100}K';
      } else if (count >= 1000000 && count < 1000000000) {
        return '${count / 1000000}.${count / 100000}M';
      } else if (count >= 1000000000) {
        return '${count / 1000000000}.${count / 10000000}G';
      } else {
        return '$count';
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                MyNetworkImage(
                  imageUri: imageUri,
                  height: 80,
                  width: 80,
                  color: const Color(0xffD9D9D9),
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(countToString(tastingRecordCount), style: TextStyles.captionMediumMedium),
                            const SizedBox(height: 6),
                            const Text('시음기록', style: TextStyles.captionMediumRegular),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            pushFollowList(0);
                          },
                          child: Column(
                            children: [
                              Text(countToString(followerCount), style: TextStyles.captionMediumMedium),
                              const SizedBox(height: 6),
                              const Text('팔로워', style: TextStyles.captionMediumRegular),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            pushFollowList(1);
                          },
                          child: Column(
                            children: [
                              Text(countToString(followingCount), style: TextStyles.captionMediumMedium),
                              const SizedBox(height: 6),
                              const Text('팔로잉', style: TextStyles.captionMediumRegular),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail({
    required List<String> coffeeLife,
    required String introduction,
    required String profileLink,
  }) {
    final hasDetail = coffeeLife.isNotEmpty || introduction.isNotEmpty || profileLink.isNotEmpty;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: hasDetail
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (introduction.isNotEmpty) _buildIntroduction(introduction: introduction),
                  if (coffeeLife.isNotEmpty) _buildCoffeeLife(coffeeLife: coffeeLife),
                  if (profileLink.isNotEmpty) _buildProfileLink(profileLink: profileLink),
                ].separator(separatorWidget: const SizedBox(height: 8)).toList(),
              )
            : InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 6),
                  decoration: const BoxDecoration(
                    color: ColorStyles.gray20,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      const Text('버디님이 즐기는 커피 생활을 알려주세요', style: TextStyles.captionMediumRegular),
                      const SizedBox(width: 2),
                      SvgPicture.asset('assets/icons/arrow.svg', height: 18, width: 18),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCoffeeLife({required List<String> coffeeLife}) {
    return Row(
      children: List<Widget>.generate(
        min(coffeeLife.length, 3),
        (index) {
          if (index == 2) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: ColorStyles.white,
                border: Border.all(color: ColorStyles.gray70),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                child: Text(
                  '+ ${coffeeLife.length - 2}',
                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                ),
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: const BoxDecoration(
                color: ColorStyles.gray20,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                child: Text(coffeeLife[index], style: TextStyles.captionMediumMedium),
              ),
            );
          }
        },
      ).separator(separatorWidget: const SizedBox(width: 4)).toList(),
    );
  }

  Widget _buildIntroduction({required String introduction}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: introduction.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
          style: TextStyles.captionMediumRegular,
        );

        final painter = TextPainter(
          maxLines: 2,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        );

        painter.layout(maxWidth: constraints.maxWidth);

        final exceeded = painter.didExceedMaxLines;
        return !exceeded
            ? Text.rich(span, maxLines: 2, overflow: TextOverflow.ellipsis)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(span, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      '더보기',
                      style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              );
      },
    );
  }

  Widget _buildProfileLink({required String profileLink}) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: const BoxDecoration(
              color: ColorStyles.gray20,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/link.svg', height: 18, width: 18),
                const SizedBox(width: 2),
                Text(profileLink, style: TextStyles.captionMediumRegular),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SliverAppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      floating: true,
      titleSpacing: 0,
      title: TabBar(
        padding: const EdgeInsets.only(top: 16),
        indicatorWeight: 2,
        indicatorPadding: const EdgeInsets.only(top: 4),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: ColorStyles.black,
        labelPadding: const EdgeInsets.only(top: 8),
        labelStyle: TextStyles.title01SemiBold,
        labelColor: ColorStyles.black,
        unselectedLabelStyle: TextStyles.title01SemiBold,
        unselectedLabelColor: ColorStyles.gray50,
        dividerHeight: 1,
        dividerColor: ColorStyles.gray20,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        tabs: const [
          Tab(text: '시음기록', height: 31),
          Tab(text: '게시글', height: 31),
          Tab(text: '찜한 원두', height: 31),
          Tab(text: '저장한 노트', height: 31),
        ],
        onTap: (index) {
          context.read<Presenter>().onChangeTabIndex(index);
        },
      ),
    );
  }

  Widget _buildFilterBar({
    required List<String> sortCriteriaList,
    required int currentIndex,
    required List<CoffeeBeanFilter> filters,
  }) {
    final String currentSortCriteria = sortCriteriaList[currentIndex].toString();
    final bool hasFilter = filters.isNotEmpty;
    final bool hasBeanTypeFilter = filters.whereType<BeanTypeFilter>().isNotEmpty;
    final bool hasCountryFilter = filters.whereType<CountryFilter>().isNotEmpty;
    final bool hasRatingFilter = filters.whereType<RatingFilter>().isNotEmpty;
    final bool hasRoastingPointFilter = filters.whereType<DecafFilter>().isNotEmpty;
    final bool hasDecafFilter = filters.whereType<RoastingPointFilter>().isNotEmpty;

    return SliverAppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      floating: true,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildIcon(
                onTap: () {
                  _showSortCriteriaBottomSheet(sortCriteriaList: sortCriteriaList, currentIndex: currentIndex);
                },
                text: currentSortCriteria,
                iconPath: 'assets/icons/arrow_up_down.svg',
                isLeftIcon: true,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters);
                },
                text: '필터',
                iconPath: 'assets/icons/union.svg',
                isLeftIcon: true,
                isActive: hasFilter,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters);
                },
                text: '원두유형',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
                isActive: hasBeanTypeFilter,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters, initialIndex: 1);
                },
                text: '생산 국가',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
                isActive: hasCountryFilter,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters, initialIndex: 2);
                },
                text: '평균 별점',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
                isActive: hasRatingFilter,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters, initialIndex: 4);
                },
                text: '로스팅 포인트',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
                isActive: hasRoastingPointFilter,
              ),
              _buildIcon(
                onTap: () {
                  _showCoffeeBeanFilterBottomSheet(filters: filters, initialIndex: 3);
                },
                text: '디카페인',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
                isActive: hasDecafFilter,
              ),
            ].separator(separatorWidget: const SizedBox(width: 4)).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildContentsList() {
    return Selector<Presenter, DefaultPage?>(
      selector: (context, presenter) => presenter.currentPage,
      builder: (context, page, child) {
        final currentPage = page;
        if (currentPage != null) {
          final result = currentPage.result;
          if (result is List<TastingRecordInProfile>) {
            return _buildTastedRecordsList(tastingRecords: result);
          } else if (result is List<PostInProfile>) {
            return _buildPostsList(posts: result);
          } else if (result is List<BeanInProfile>) {
            return _buildSavedCoffeeBeansList(beans: result);
          } else if (result is List<SavedNote>) {
            return _buildSavedPostsList(savedNotes: result);
          }
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildTastedRecordsList({required List<TastingRecordInProfile> tastingRecords}) {
    return tastingRecords.isEmpty
        ? SliverFillRemaining(
            child: Center(
              child: Text(tastingRecordsEmptyText, style: TextStyles.title02SemiBold),
            ),
          )
        : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: tastingRecords.length,
                itemBuilder: (context, index) {
                  final tastingRecord = tastingRecords[index];
                  return buildOpenableTastingRecordDetailView(
                    id: tastingRecord.id,
                    closeBuilder: (context, action) => TastingRecordItemWidget(
                      imageUri: tastingRecord.imageUri,
                      rating: tastingRecord.rating,
                    ),
                  );
                }),
          );
  }

  Widget _buildPostsList({required List<PostInProfile> posts}) {
    return posts.isEmpty
        ? SliverFillRemaining(
            child: Center(
              child: Text(postsEmptyText, style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return buildOpenablePostDetailView(
                id: post.id,
                closeBuilder: (context, action) => ProfilePostItemWidget(
                  title: post.title,
                  author: post.author,
                  createdAt: post.createdAt,
                  subject: post.subject,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  Widget _buildSavedCoffeeBeansList({required List<BeanInProfile> beans}) {
    return beans.isEmpty
        ? SliverFillRemaining(
            child: Center(
              child: Text(beansEmptyText, style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: beans.length,
            itemBuilder: (context, index) {
              final bean = beans[index];
              return SavedCoffeeBeanWidget(
                name: bean.name,
                rating: bean.rating,
                tastedRecordsCount: bean.tastedRecordsCount,
                imageUri: '',
              );
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  _buildSavedPostsList({required List<SavedNote> savedNotes}) {
    return savedNotes.isEmpty
        ? SliverFillRemaining(
            child: Center(
              child: Text(savedNotesEmptyText, style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: savedNotes.length,
            itemBuilder: (context, index) {
              final note = savedNotes[index];
              if (note is SavedPost) {
                return buildOpenablePostDetailView(
                  id: note.id,
                  closeBuilder: (context, action) => SavedPostWidget(
                    title: note.title,
                    subject: note.subject.toString(),
                    createdAt: note.createdAt,
                    author: note.author,
                    imageUri: note.imageUri,
                  ),
                );
              } else if (note is SavedTastingRecord) {
                return buildOpenableTastingRecordDetailView(
                  id: note.id,
                  closeBuilder: (context, action) => SavedTastingRecordWidget(
                    beanName: note.beanName,
                    rating: '4.5',
                    likeCount: '22',
                    flavor: note.flavor,
                    imageUri: note.imageUri,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  _showCoffeeBeanFilterBottomSheet({required List<CoffeeBeanFilter> filters, initialIndex = 0}) {
    showBarrierDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider<FilterPresenter>(
          create: (_) => FilterPresenter(filter: List.from(filters)),
          child: FilterBottomSheet(
            initialTab: initialIndex,
            onDone: (filters) {
              context.read<Presenter>().onChangeFilter(filters);
            },
          ),
        );
      },
    );
  }

  _showSortCriteriaBottomSheet({required List<String> sortCriteriaList, required int currentIndex}) {
    showBarrierDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return SortCriteriaBottomSheet(
          items: sortCriteriaList.indexed.map(
            (indexedSortCriteria) {
              return (
                indexedSortCriteria.$2.toString(),
                () {
                  context.read<Presenter>().onChangeSortCriteriaIndex(indexedSortCriteria.$1);
                },
              );
            },
          ).toList(),
          currentIndex: currentIndex,
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
