import 'dart:math';
import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/profile/model/SavedNote/saved_post.dart';
import 'package:brew_buds/profile/model/SavedNote/saved_tasting_record.dart';
import 'package:brew_buds/profile/presenter/follower_list_presenter.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:brew_buds/profile/view/filter_bottom_sheet.dart';
import 'package:brew_buds/profile/view/follower_list_pa.dart';
import 'package:brew_buds/profile/widgets/sort_criteria_bottom_sheet.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final Throttle paginationThrottle;
  final GlobalKey<NestedScrollViewState> homeTabBarScrollState = GlobalKey<NestedScrollViewState>();

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfilePresenter>().initState();
      homeTabBarScrollState.currentState?.innerController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    homeTabBarScrollState.currentState?.innerController.removeListener(_scrollListener);
    paginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if ((homeTabBarScrollState.currentState?.innerController.position.pixels ?? 0) >
        (homeTabBarScrollState.currentState?.innerController.position.maxScrollExtent ?? 0) * 0.7) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<ProfilePresenter>().paginate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: SafeArea(
        child: Consumer<ProfilePresenter>(
          builder: (context, presenter, _) {
            final physics =
                presenter.checkScrollable() ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics();
            return Scaffold(
              appBar: _buildTitle(presenter),
              body: NestedScrollView(
                physics: physics,
                key: homeTabBarScrollState,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  _buildProfile(presenter),
                ],
                body: CustomScrollView(
                  physics: physics,
                  controller: homeTabBarScrollState.currentState?.innerController,
                  slivers: [
                    _buildContentsAppBar(presenter),
                    buildContentsList(presenter),
                    if (presenter.hasNext)
                      SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorStyles.gray70,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildTitle(ProfilePresenter presenter) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(presenter.nickname, style: TextStyles.title02Bold),
            const Spacer(),
            InkWell(
              onTap: () {
                context.push('/profile_setting');
              },
              child: SvgPicture.asset(
                'assets/icons/setting.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildProfile(ProfilePresenter presenter) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    presenter.profileImageURI,
                    errorBuilder: (context, object, stackTracer) => Container(),
                  ),
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
                            Text(
                              presenter.tastingRecordCount,
                              style: TextStyles.captionMediumMedium,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '시음기록',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider<FollowerListPresenter>(
                                    create: (context) => FollowerListPresenter(
                                      id: presenter.id,
                                      nickName: presenter.nickname,
                                    ),
                                    builder: (context, presenter) => const FollowerListPA(),
                                  );
                                },
                              ),
                            ).whenComplete(() => presenter.initState());
                          },
                          child: Column(
                            children: [
                              Text(
                                presenter.followerCount,
                                style: TextStyles.captionMediumMedium,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                '팔로워',
                                style: TextStyles.captionMediumRegular,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider<FollowerListPresenter>(
                                    create: (context) => FollowerListPresenter(
                                      id: presenter.id,
                                      nickName: presenter.nickname,
                                    ),
                                    builder: (context, presenter) => const FollowerListPA(initialIndex: 1),
                                  );
                                },
                              ),
                            ).whenComplete(() => presenter.initState());
                          },
                          child: Column(
                            children: [
                              Text(
                                presenter.followingCount,
                                style: TextStyles.captionMediumMedium,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                '팔로잉',
                                style: TextStyles.captionMediumRegular,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            presenter.hasDetail
                ? _buildDetail(presenter)
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
            const SizedBox(height: 24),
            Row(
              children: [
                ButtonFactory.buildRoundedButton(
                  onTapped: () {},
                  text: '취향 리포트 보기',
                  style: RoundedButtonStyle.fill(
                    size: RoundedButtonSize.medium,
                    color: ColorStyles.black,
                    textColor: ColorStyles.white,
                  ),
                ),
                const SizedBox(width: 8),
                ButtonFactory.buildRoundedButton(
                  onTapped: () {
                    context.push('/profile_edit');
                  },
                  text: '프로필 편집',
                  style: RoundedButtonStyle.fill(
                    size: RoundedButtonSize.medium,
                    color: ColorStyles.gray30,
                    textColor: ColorStyles.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(ProfilePresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCoffeeLife(presenter),
        _buildIntroduction(presenter),
        _buildProfileLink(presenter),
      ].separator(separatorWidget: const SizedBox(height: 2)).toList(),
    );
  }

  Widget _buildCoffeeLife(ProfilePresenter presenter) {
    final coffeeLife = presenter.coffeeLife;
    return coffeeLife != null
        ? Row(
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
                      child: Text(
                        coffeeLife[index],
                        style: TextStyles.captionMediumMedium,
                      ),
                    ),
                  );
                }
              },
            ).separator(separatorWidget: const SizedBox(width: 4)).toList(),
          )
        : Container();
  }

  Widget _buildIntroduction(ProfilePresenter presenter) {
    final introduction = presenter.introduction;
    return introduction != null
        ? LayoutBuilder(builder: (context, constraints) {
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
                ? Text.rich(
                    span,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        span,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
          })
        : Container();
  }

  Widget _buildProfileLink(ProfilePresenter presenter) {
    final profileLink = presenter.profileLink;
    return profileLink != null
        ? Row(
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
          )
        : Container();
  }

  SliverAppBar _buildContentsAppBar(ProfilePresenter presenter) {
    return SliverAppBar(
      floating: true,
      titleSpacing: 0,
      toolbarHeight: presenter.tabIndex == 0 || presenter.tabIndex == 2 ? 116 : kToolbarHeight,
      title: Column(
        children: presenter.tabIndex == 0 || presenter.tabIndex == 2
            ? [
                _buildTabBar(presenter),
                _buildFilter(presenter),
              ]
            : [
                _buildTabBar(presenter),
              ],
      ),
    );
  }

  Widget _buildTabBar(ProfilePresenter presenter) {
    return TabBar(
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
        presenter.onChangeTabIndex(index);
      },
    );
  }

  Widget _buildFilter(ProfilePresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildIcon(
              onTap: () {
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
                            sortCriteria.$2.columnString,
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
              },
              text: presenter.currentSortCriteria,
              iconPath: 'assets/icons/arrow_up_down.svg',
              isLeftIcon: true,
            ),
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
          ].separator(separatorWidget: const SizedBox(width: 4)).toList(),
        ),
      ),
    );
  }

  Widget buildContentsList(ProfilePresenter presenter) {
    if (presenter.tabIndex == 0) {
      return _buildTastedRecordsList(presenter);
    } else if (presenter.tabIndex == 1) {
      return _buildPostsList(presenter);
    } else if (presenter.tabIndex == 2) {
      return _buildSavedCoffeeBeansList(presenter);
    } else {
      return _buildSavedPostsList(presenter);
    }
  }

  Widget _buildTastedRecordsList(ProfilePresenter presenter) {
    return presenter.tastingRecords.isEmpty
        ? const SliverFillRemaining(
            child: Center(
              child: Text('첫 시음기록을 작성해 보세요.', style: TextStyles.title02SemiBold),
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
                itemCount: presenter.tastingRecords.length,
                itemBuilder: (context, index) {
                  final tastingRecord = presenter.tastingRecords[index];
                  return SizedBox(
                    height: MediaQuery.of(context).size.width - 36,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            tastingRecord.imageUri,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: ColorStyles.red,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 6,
                          bottom: 6.5,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/star_fill.svg',
                                height: 18,
                                width: 18,
                                colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                              ),
                              Text(
                                '${tastingRecord.rating}',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
  }

  Widget _buildPostsList(ProfilePresenter presenter) {
    return presenter.posts.isEmpty
        ? const SliverFillRemaining(
            child: Center(
              child: Text('첫 게시글을 작성해 보세요.', style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: presenter.posts.length,
            itemBuilder: (context, index) {
              final post = presenter.posts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black70),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 12,
                                width: 12,
                                child: SvgPicture.asset(
                                  post.subject.iconPath,
                                  colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(post.subject.toString(),
                                  style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.title,
                      style: TextStyles.title01SemiBold,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          post.author,
                          style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                        ),
                        const SizedBox(width: 4),
                        Container(width: 1, height: 10, color: ColorStyles.gray30),
                        const SizedBox(width: 4),
                        Text(
                          post.createdAt,
                          style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  Widget _buildSavedCoffeeBeansList(ProfilePresenter presenter) {
    return presenter.coffeeBeans.isEmpty
        ? const SliverFillRemaining(
            child: Center(
              child: Text('관심있는 원두를 찜해 보세요.', style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: presenter.coffeeBeans.length,
            itemBuilder: (context, index) {
              final bean = presenter.coffeeBeans[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            bean.name,
                            style: TextStyles.labelMediumMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/star_fill.svg',
                                height: 14,
                                width: 14,
                                colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${bean.rating} (${bean.tastedRecordsCount})',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Image.network(
                      '',
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                      errorBuilder: (_, __, ___) => Container(
                        height: 64,
                        width: 64,
                        color: const Color(0xffd9d9d9),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(height: 1, color: ColorStyles.gray20);
            },
          );
  }

  _buildSavedPostsList(ProfilePresenter presenter) {
    return presenter.saveNotes.isEmpty
        ? const SliverFillRemaining(
            child: Center(
              child: Text('관심있는 커피노트를 저장해 보세요.', style: TextStyles.title02SemiBold),
            ),
          )
        : SliverList.separated(
            itemCount: presenter.saveNotes.length,
            itemBuilder: (context, index) {
              final note = presenter.saveNotes[index];
              if (note is SavedPost) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildPost(
                    title: note.title,
                    subject: note.subject.toString(),
                    createdAt: note.createdAt,
                    author: note.author,
                    imageUri: note.imageUri,
                  ),
                );
              } else if (note is SavedTastingRecord) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildTastedRecord(
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

  Widget _buildPost({
    required String title,
    required String subject,
    required String createdAt,
    required String author,
    String? imageUri,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '게시글',
                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    subject,
                    style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 10, color: ColorStyles.gray30),
                  const SizedBox(width: 4),
                  Text(
                    createdAt,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 10, color: ColorStyles.gray30),
                  const SizedBox(width: 4),
                  Text(
                    author,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (imageUri != null) ...[
          const SizedBox(width: 24),
          Image.network(
            imageUri,
            fit: BoxFit.cover,
            height: 64,
            width: 64,
            errorBuilder: (_, __, ___) => Container(
              height: 64,
              width: 64,
              color: const Color(0xffd9d9d9),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTastedRecord({
    required String beanName,
    required String rating,
    required String likeCount,
    required List<String> flavor,
    String? imageUri,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시음기록',
                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
              ),
              const SizedBox(height: 4),
              Text(
                beanName,
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/star_fill.svg',
                    height: 16,
                    width: 16,
                    colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                  ),
                  Text(
                    '$rating ($likeCount)',
                    style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 4),
              //Api 누락
              Row(
                children: flavor
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
              ),
            ],
          ),
        ),
        if (imageUri != null) ...[
          const SizedBox(width: 24),
          Image.network(
            imageUri,
            fit: BoxFit.cover,
            height: 64,
            width: 64,
            errorBuilder: (_, __, ___) => Container(
              height: 64,
              width: 64,
              color: const Color(0xffd9d9d9),
            ),
          ),
        ],
      ],
    );
  }

  showFilterBottomSheet(ProfilePresenter presenter, int initialIndex) {
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
              presenter.onChangeFilter(filter);
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
