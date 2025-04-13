import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/expandable_coffee_life.dart';
import 'package:brew_buds/common/widgets/expandable_text.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/filter/filter_bottom_sheet.dart';
import 'package:brew_buds/domain/filter/filter_presenter.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/sort_criteria_bottom_sheet.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/domain/profile/widgets/profile_post_item_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_coffee_bean_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_post_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_tasting_record_widget.dart';
import 'package:brew_buds/domain/profile/widgets/tasting_record_item_widget.dart';
import 'package:brew_buds/domain/web_view/web_screen.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/noted/noted_object.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

mixin ProfileMixin<T extends StatefulWidget, Presenter extends ProfilePresenter> on State<T> {
  late final Throttle paginationThrottle;
  final GlobalKey<NestedScrollViewState> scrollKey = GlobalKey<NestedScrollViewState>();

  bool isExpandedIntro = false;

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
    });
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    super.dispose();
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
        body: context.select<Presenter, bool>((presenter) => presenter.isLoading)
            ? const Center(child: CupertinoActivityIndicator(color: ColorStyles.gray70))
            : Selector<Presenter, bool>(
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
                          imageUri: profileState.imageUrl,
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
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scroll) {
                          if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                            paginationThrottle.setValue(null);
                          }
                          return false;
                        },
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
                            if (context.select<Presenter, bool>((presenter) => presenter.isLoadingData))
                              const SliverFillRemaining(
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: ColorStyles.gray70,
                                  ),
                                ),
                              )
                            else
                              buildContentsList(),
                          ],
                        ),
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
                  imageUrl: imageUri,
                  height: 80,
                  width: 80,
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
                            Text('시음기록', style: TextStyles.captionMediumRegular),
                          ],
                        ),
                        ThrottleButton(
                          onTap: () {
                            pushFollowList(0);
                          },
                          child: Column(
                            children: [
                              Text(countToString(followerCount), style: TextStyles.captionMediumMedium),
                              const SizedBox(height: 6),
                              Text('팔로워', style: TextStyles.captionMediumRegular),
                            ],
                          ),
                        ),
                        ThrottleButton(
                          onTap: () {
                            pushFollowList(1);
                          },
                          child: Column(
                            children: [
                              Text(countToString(followingCount), style: TextStyles.captionMediumMedium),
                              const SizedBox(height: 6),
                              Text('팔로잉', style: TextStyles.captionMediumRegular),
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
                  if (introduction.isNotEmpty) ...[
                    ExpandableText(
                      text: introduction,
                      style: TextStyles.captionMediumRegular,
                      maxLine: 2,
                      expandText: '펼치기',
                      shrinkText: '접기',
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (coffeeLife.isNotEmpty) ...[
                    ExpandableCoffeeLife(coffeeLifeList: coffeeLife, maxLength: 2),
                    const SizedBox(height: 8),
                  ],
                  if (profileLink.isNotEmpty) ...[
                    _buildProfileLink(profileLink: profileLink),
                    const SizedBox(height: 8),
                  ]
                ],
              )
            : Container(
                padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 6),
                decoration: const BoxDecoration(
                  color: ColorStyles.gray20,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Row(
                  children: [
                    Text('버디님이 즐기는 커피 생활을 알려주세요', style: TextStyles.captionMediumRegular),
                    const SizedBox(width: 2),
                    SvgPicture.asset('assets/icons/arrow.svg', height: 18, width: 18),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileLink({required String profileLink}) {
    return Row(
      children: [
        ThrottleButton(
          onTap: () {
            showCupertinoModalPopup(
              barrierColor: ColorStyles.white,
              barrierDismissible: false,
              context: context,
              builder: (context) => WebScreen(url: profileLink),
            );
          },
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
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
          child: Row(spacing: 4, children: [
            _buildIcon(
              onTap: () {
                _showSortCriteriaBottomSheet(
                  sortCriteriaList: sortCriteriaList,
                  currentIndex: currentIndex,
                );
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
                _showCoffeeBeanFilterBottomSheet(filters: filters, initialIndex: 3);
              },
              text: '디카페인',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: hasDecafFilter,
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
          ]),
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
          final result = currentPage.results;
          if (result is List<TastedRecordInProfile>) {
            return _buildTastedRecordsList(tastingRecords: result);
          } else if (result is List<PostInProfile>) {
            return _buildPostsList(posts: result);
          } else if (result is List<BeanInProfile>) {
            return _buildSavedCoffeeBeansList(beans: result);
          } else if (result is List<NotedObject>) {
            return _buildSavedPostsList(savedNotes: result);
          }
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildTastedRecordsList({required List<TastedRecordInProfile> tastingRecords}) {
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
                return ThrottleButton(
                  onTap: () {
                    showTastingRecordDetail(context: context, id: tastingRecords[index].id).then((value) {
                      if (value != null) {
                        showSnackBar(message: value);
                      }
                    });
                  },
                  child: TastingRecordItemWidget(
                    imageUri: tastingRecord.imageUrl,
                    rating: tastingRecord.rating,
                  ),
                );
              },
            ),
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
              return ThrottleButton(
                onTap: () {
                  showPostDetail(context: context, id: post.id).then((value) {
                    if (value != null) {
                      showSnackBar(message: value);
                    }
                  });
                },
                child: ProfilePostItemWidget(
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
              return ThrottleButton(
                onTap: () {
                  showCoffeeBeanDetail(context: context, id: bean.id);
                },
                child: SavedCoffeeBeanWidget(
                  name: bean.name,
                  rating: bean.rating,
                  tastedRecordsCount: bean.tastedRecordsCount,
                  imageUri: '',
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  _buildSavedPostsList({required List<NotedObject> savedNotes}) {
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
              switch (note) {
                case NotedPost():
                  return ThrottleButton(
                    onTap: () {
                      showPostDetail(context: context, id: note.id).then((value) {
                        if (value != null) {
                          showSnackBar(message: value);
                        }
                      });
                    },
                    child: SavedPostWidget(
                      title: note.title,
                      subject: note.subject.toString(),
                      createdAt: note.createdAt,
                      author: note.author,
                      imageUri: note.imageUrl,
                    ),
                  );
                case NotedTastedRecord():
                  return ThrottleButton(
                    onTap: () {
                      showTastingRecordDetail(context: context, id: note.id).then((value) {
                        if (value != null) {
                          showSnackBar(message: value);
                        }
                      });
                    },
                    child: SavedTastingRecordWidget(
                      beanName: note.beanName,
                      rating: '${note.rating}',
                      flavor: note.flavor,
                      imageUri: note.imageUrl,
                    ),
                  );
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
    return ThrottleButton(
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

  showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black90,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
