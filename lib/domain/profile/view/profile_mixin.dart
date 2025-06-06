import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/expandable_coffee_life.dart';
import 'package:brew_buds/common/widgets/expandable_text.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/profile_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
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
import 'package:brew_buds/model/noted/noted_object.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/profile/item_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

mixin ProfileMixin<T extends StatefulWidget, Presenter extends ProfilePresenter> on State<T> {
  late final Throttle paginationThrottle;
  final GlobalKey<NestedScrollViewState> scrollKey = GlobalKey<NestedScrollViewState>();
  final TextStyle emptyTextStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16.sp, height: 1.2, letterSpacing: -0.02, color: ColorStyles.gray70);

  bool isExpandedIntro = false;

  String get tastingRecordsEmptyText;

  String get postsEmptyText;

  String get beansEmptyText;

  String get savedNotesEmptyText;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
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

  Future<void> pushFollowList(int index);

  AppBar buildTitle();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Stack(
        children: [
          Scaffold(
            appBar: buildTitle(),
            body: NestedScrollView(
              key: scrollKey,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                Selector<Presenter, ProfileState>(
                  selector: (context, presenter) => presenter.profileState,
                  builder: (context, profileState, child) => _buildProfile(
                    imageUrl: profileState.imageUrl,
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
                top: false,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                      paginationThrottle.setValue(null);
                    }
                    return false;
                  },
                  child: CustomScrollView(
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
                      Builder(
                        builder: (context) {
                          final isLoading = context.select<Presenter, bool>(
                            (presenter) => presenter.isLoadingData && presenter.items.isEmpty && !presenter.isLoading,
                          );
                          return isLoading
                              ? const SliverFillRemaining(
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      color: ColorStyles.gray70,
                                    ),
                                  ),
                                )
                              : buildContentsList();
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final hasNext = context.select<Presenter, bool>(
                            (presenter) => presenter.hasNext && presenter.items.isNotEmpty,
                          );
                          return SliverToBoxAdapter(
                            child: hasNext
                                ? const SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: CupertinoActivityIndicator(
                                        color: ColorStyles.gray70,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Builder(
              builder: (context) {
                final isLoading = context.select<Presenter, bool>(
                  (presenter) => presenter.isLoading && presenter.items.isEmpty,
                );
                return isLoading ? const LoadingBarrier() : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildProfile({
    required String imageUrl,
    required int tastingRecordCount,
    required int followerCount,
    required int followingCount,
  }) {
    String countToString(int count) {
      if (count == 0) {
        return '0';
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
                ProfileImage(
                  imageUrl: imageUrl,
                  height: 80,
                  width: 80,
                  border: Border.all(color: ColorStyles.gray20, width: 1),
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
                        FutureButton(
                          onTap: () => pushFollowList(0),
                          child: Column(
                            children: [
                              Text(countToString(followerCount), style: TextStyles.captionMediumMedium),
                              const SizedBox(height: 6),
                              Text('팔로워', style: TextStyles.captionMediumRegular),
                            ],
                          ),
                        ),
                        FutureButton(
                          onTap: () => pushFollowList(1),
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
      child: hasDetail
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
              ),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(right: 6, left: 12, bottom: 4, top: 4),
                decoration: BoxDecoration(
                  color: ColorStyles.gray20,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ← 이걸 유지하는 게 핵심!
                  children: [
                    Text(
                      '내 커피 생활 소개하기',
                      style: TextStyles.captionMediumRegular,
                    ),
                    const SizedBox(width: 4),
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
        FutureButton(
          onTap: () => showCupertinoModalPopup(
            barrierColor: ColorStyles.white,
            barrierDismissible: false,
            context: context,
            builder: (context) => WebScreen(url: profileLink),
          ),
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
              text: '원산지',
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
    return Selector<Presenter, List<ItemInProfile>>(
      selector: (context, presenter) => presenter.items,
      builder: (context, items, child) {
        final currentTabIndex = context.select<Presenter, int>((presenter) => presenter.currentTabIndex);
        final result = items.map((item) {
          switch (item) {
            case TastedRecordInProfileItem():
              return item.data;
            case PostInProfileItem():
              return item.data;
            case SavedBeanInProfileItem():
              return item.data;
            case SavedNoteInProfileItem():
              return item.data;
          }
        }).toList();

        try {
          if (currentTabIndex == 0) {
            return _buildTastedRecordsList(tastingRecords: result.cast<TastedRecordInProfile>());
          } else if (currentTabIndex == 1) {
            return _buildPostsList(posts: result.cast<PostInProfile>());
          } else if (currentTabIndex == 2) {
            return _buildSavedCoffeeBeansList(beans: result.cast<BeanInProfile>());
          } else {
            return _buildSavedPostsList(savedNotes: result.cast<NotedObject>());
          }
        } catch (_) {
          return const SliverToBoxAdapter();
        }
      },
    );
  }

  Widget _buildTastedRecordsList({required List<TastedRecordInProfile> tastingRecords}) {
    return Builder(builder: (context) {
      return tastingRecords.isEmpty &&
              context.select<Presenter, bool>(
                (presenter) => !presenter.isLoading && !presenter.isLoadingData,
              )
          ? SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Column(
                    spacing: 1,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExtendedImage.asset(
                        'assets/images/profile/empty_coffee_note.png',
                        width: 140.w,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                      Text(tastingRecordsEmptyText, style: emptyTextStyle),
                    ],
                  ),
                ),
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
                  return FutureButton(
                    onTap: () => ScreenNavigator.showTastedRecordDetail(context: context, id: tastingRecords[index].id),
                    child: TastingRecordItemWidget(
                      imageUrl: tastingRecord.imageUrl,
                      rating: tastingRecord.rating,
                    ),
                  );
                },
              ),
            );
    });
  }

  Widget _buildPostsList({required List<PostInProfile> posts}) {
    return Builder(builder: (context) {
      return posts.isEmpty &&
              context.select<Presenter, bool>(
                (presenter) => !presenter.isLoading && !presenter.isLoadingData,
              )
          ? SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Column(
                    spacing: 1,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExtendedImage.asset(
                        'assets/images/profile/empty_coffee_note.png',
                        width: 140.w,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                      Text(postsEmptyText, style: emptyTextStyle),
                    ],
                  ),
                ),
              ),
            )
          : SliverList.separated(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return FutureButton(
                  onTap: () => ScreenNavigator.showPostDetail(context: context, id: post.id),
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
    });
  }

  Widget _buildSavedCoffeeBeansList({required List<BeanInProfile> beans}) {
    return Builder(builder: (context) {
      return beans.isEmpty &&
              context.select<Presenter, bool>(
                (presenter) => !presenter.isLoading && !presenter.isLoadingData,
              )
          ? SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Column(
                    spacing: 1,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExtendedImage.asset(
                        'assets/images/profile/empty_default.png',
                        width: 140.w,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                      Text(beansEmptyText, style: emptyTextStyle),
                    ],
                  ),
                ),
              ),
            )
          : SliverList.separated(
              itemCount: beans.length,
              itemBuilder: (context, index) {
                final bean = beans[index];
                return FutureButton(
                  onTap: () => ScreenNavigator.showCoffeeBeanDetail(context: context, id: bean.id),
                  child: SavedCoffeeBeanWidget(
                    name: bean.name,
                    rating: bean.rating,
                    tastedRecordsCount: bean.tastedRecordsCount,
                    imagePath: bean.imagePath,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(height: 1, color: ColorStyles.gray20);
              },
            );
    });
  }

  _buildSavedPostsList({required List<NotedObject> savedNotes}) {
    return Builder(builder: (context) {
      return savedNotes.isEmpty &&
              context.select<Presenter, bool>(
                (presenter) => !presenter.isLoading && !presenter.isLoadingData,
              )
          ? SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Column(
                    spacing: 1,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExtendedImage.asset(
                        'assets/images/profile/empty_default.png',
                        width: 140.w,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                      Text(savedNotesEmptyText, style: emptyTextStyle),
                    ],
                  ),
                ),
              ),
            )
          : SliverList.separated(
              itemCount: savedNotes.length,
              itemBuilder: (context, index) {
                final note = savedNotes[index];
                switch (note) {
                  case NotedPost():
                    return FutureButton(
                      onTap: () => ScreenNavigator.showPostDetail(context: context, id: note.id),
                      child: SavedPostWidget(
                        title: note.title,
                        subject: note.subject.toString(),
                        createdAt: note.createdAt,
                        author: note.author,
                        imageUrl: note.imageUrl,
                      ),
                    );
                  case NotedTastedRecord():
                    return FutureButton(
                      onTap: () => ScreenNavigator.showTastedRecordDetail(context: context, id: note.id),
                      child: SavedTastingRecordWidget(
                        beanName: note.beanName,
                        rating: '${note.rating}',
                        flavor: note.flavor,
                        imageUrl: note.imageUrl,
                      ),
                    );
                }
              },
              separatorBuilder: (context, index) {
                return Container(height: 1, color: ColorStyles.gray20);
              },
            );
    });
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
}
