import 'dart:math';
import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:brew_buds/profile/view/filter_bottom_sheet.dart';
import 'package:brew_buds/profile/widgets/sort_criteria_bottom_sheet.dart';
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
  int currentIndex = 0;
  bool isRefresh = false;
  late final ScrollController scrollController;
  final GlobalKey<NestedScrollViewState> homeTabBarScrollState = GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfilePresenter>().initState();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: SafeArea(
        child: Consumer<ProfilePresenter>(
          builder: (context, presenter, _) => Scaffold(
            appBar: _buildTitle(presenter),
            body: NestedScrollView(
              key: homeTabBarScrollState,
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildProfile(presenter),
              ],
              body: CustomScrollView(
                controller: homeTabBarScrollState.currentState?.innerController,
                slivers: [
                  _buildContentsAppBar(presenter),
                  buildContentsList(presenter),
                ],
              ),
            ),
          ),
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
                            context.push('/follow/pa?initialIndex=0');
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
                            context.push('/follow/pa?initialIndex=1');
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
      toolbarHeight: currentIndex == 0 || currentIndex == 2 ? 116 : kToolbarHeight,
      title: Column(
        children: currentIndex == 0 || currentIndex == 2
            ? [
                _buildTabBar(),
                _buildFilter(presenter),
              ]
            : [
                _buildTabBar(),
              ],
      ),
    );
  }

  Widget _buildTabBar() {
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
        if (currentIndex == index) {
          setState(() {
            isRefresh = true;
          });
          Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
            setState(() {
              isRefresh = false;
            });
          });
        } else {
          setState(() {
            currentIndex = index;
          });
        }
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
    if (currentIndex == 0) {
      return SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16), sliver: _buildTastedRecordsList(presenter));
    } else if (currentIndex == 1) {
      return _buildPostsList(presenter);
    } else if (currentIndex == 2) {
      return _buildSavedCoffeeBeansList(presenter);
    } else {
      return _buildSavedPostsList(presenter);
    }
  }

  Widget _buildTastedRecordsList(ProfilePresenter presenter) {
    final _dummy = [
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
      ('https://picsum.photos/600/400', 4.8),
    ];
    return SliverGrid(
      delegate: SliverChildListDelegate(
        _dummy
            .map(
              (item) => SizedBox(
                height: MediaQuery.of(context).size.width - 36,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        item.$1,
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
                            '${item.$2}',
                            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
    );
  }

  Widget _buildPostsList(ProfilePresenter presenter) {
    final _dummy = [
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
      (PostSubject.beans, '제목', '아이디', '시간'),
    ];
    return SliverList.separated(
      itemCount: _dummy.length,
      itemBuilder: (context, index) {
        final item = _dummy[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black70),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 12,
                          width: 12,
                          child: SvgPicture.asset(
                            item.$1.iconPath,
                            colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(item.$1.toString(),
                            style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.$2,
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    item.$3,
                    style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 10, color: ColorStyles.gray30),
                  const SizedBox(width: 4),
                  Text(
                    item.$4,
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
    final _dummy = [
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
      ('', '제목', 4.5, 2000),
    ];
    return SliverList.separated(
      itemCount: _dummy.length,
      itemBuilder: (context, index) {
        final item = _dummy[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.$2,
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
                          '${item.$3} (${item.$4})',
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
                item.$1,
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
    return SliverList.separated(
      itemCount: 50,
      itemBuilder: (context, index) {
        return Padding(padding: const EdgeInsets.all(16), child: index % 2 == 0 ? _buildPost() : _buildTastedRecord());
      },
      separatorBuilder: (context, index) {
        return Container(height: 1, color: ColorStyles.gray20);
      },
    );
  }

  Widget _buildPost() {
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
              const Text(
                '바스켓 크기에 따라서 맛 차이가 나나요?',
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '정보',
                    style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 10, color: ColorStyles.gray30),
                  const SizedBox(width: 4),
                  Text(
                    '10/3',
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                  const SizedBox(width: 4),
                  Container(width: 1, height: 10, color: ColorStyles.gray30),
                  const SizedBox(width: 4),
                  Text(
                    '커피의신',
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
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
    );
  }

  Widget _buildTastedRecord() {
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
              const Text(
                '에티오피아 할로 하르투메 G1 워시드',
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
                    '4.5 (21)',
                    style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: ['트로피칼', '트로피칼', '트로피칼', '트로피칼']
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
