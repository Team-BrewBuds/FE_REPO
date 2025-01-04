import 'dart:math';

import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/profile/model/filter.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:brew_buds/profile/view/filter_bottom_sheet.dart';
import 'package:brew_buds/profile/widgets/sort_criteria_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
                  SliverGrid(
                    delegate: SliverChildListDelegate(
                      [
                        Container(color: Colors.red, height: 150.0),
                        Container(color: Colors.purple, height: 150.0),
                        Container(color: Colors.green, height: 150.0),
                        Container(color: Colors.cyan, height: 150.0),
                        Container(color: Colors.indigo, height: 150.0),
                        Container(color: Colors.black, height: 150.0),
                        Container(color: Colors.red, height: 150.0),
                        Container(color: Colors.purple, height: 150.0),
                        Container(color: Colors.green, height: 150.0),
                        Container(color: Colors.cyan, height: 150.0),
                        Container(color: Colors.indigo, height: 150.0),
                        Container(color: Colors.black, height: 150.0),
                        Container(color: Colors.red, height: 150.0),
                        Container(color: Colors.purple, height: 150.0),
                        Container(color: Colors.green, height: 150.0),
                        Container(color: Colors.cyan, height: 150.0),
                        Container(color: Colors.indigo, height: 150.0),
                        Container(color: Colors.black, height: 150.0),
                        Container(color: Colors.red, height: 150.0),
                        Container(color: Colors.purple, height: 150.0),
                        Container(color: Colors.green, height: 150.0),
                        Container(color: Colors.cyan, height: 150.0),
                        Container(color: Colors.indigo, height: 150.0),
                        Container(color: Colors.black, height: 150.0),
                        Container(color: Colors.red, height: 150.0),
                        Container(color: Colors.purple, height: 150.0),
                        Container(color: Colors.green, height: 150.0),
                        Container(color: Colors.cyan, height: 150.0),
                        Container(color: Colors.indigo, height: 150.0),
                        Container(color: Colors.black, height: 150.0),
                      ],
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                  // SliverToBoxAdapter(child:isRefresh ? Container() : _buildGridView(presenter)),
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
                        Column(
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
                        Column(
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
                  onTapped: () {},
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
      toolbarHeight: currentIndex == 0 || currentIndex == 2 ? 114 : kToolbarHeight,
      title: Column(
        children: currentIndex == 0 || currentIndex == 2
            ? [
                _buildTabBar(),
                Container(height: 1, width: double.infinity, color: ColorStyles.gray30),
                _buildFilter(presenter),
              ]
            : [
                _buildTabBar(),
                Container(height: 1, width: double.infinity, color: ColorStyles.gray30),
              ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      indicatorWeight: 2,
      indicatorPadding: const EdgeInsets.only(top: 4),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: ColorStyles.black,
      labelPadding: const EdgeInsets.only(top: 8),
      labelStyle: TextStyles.title01SemiBold,
      labelColor: ColorStyles.black,
      unselectedLabelStyle: TextStyles.title01SemiBold,
      unselectedLabelColor: ColorStyles.gray50,
      dividerHeight: 0,
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
                      itemCount: 3,
                      itemBuilder: (index) {
                        return InkWell(
                          onTap: () {
                            presenter.onChangeSortCriteriaIndex(index);
                            context.pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  presenter.sortCriteriaList[index].columnString,
                                  style: TextStyles.labelMediumMedium.copyWith(
                                    color: presenter.currentSortCriteriaIndex == index
                                        ? ColorStyles.red
                                        : ColorStyles.black,
                                  ),
                                ),
                                const Spacer(),
                                presenter.currentSortCriteriaIndex == index
                                    ? const Icon(Icons.check, size: 15, color: ColorStyles.red)
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
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
                showFilterBottomSheet(presenter);
              },
              text: '필터',
              iconPath: 'assets/icons/union.svg',
              isLeftIcon: true,
              isActive: presenter.hasFilter,
            ),
            _buildIcon(
              onTap: () {
                showFilterBottomSheet(presenter);
              },
              text: '원두유형',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: presenter.hasBeanTypeFilter,
            ),
            _buildIcon(
              onTap: () {
                showFilterBottomSheet(presenter);
              },
              text: '생산 국가',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: presenter.hasCountryFilter,
            ),
            _buildIcon(
              onTap: () {
                showFilterBottomSheet(presenter);
              },
              text: '평균 별점',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: presenter.hasRatingFilter,
            ),
            _buildIcon(
              onTap: () {
                showFilterBottomSheet(presenter);
              },
              text: '로스팅 포인트',
              iconPath: 'assets/icons/down.svg',
              isLeftIcon: false,
              isActive: presenter.hasRoastingPointFilter,
            ),
            _buildIcon(
              onTap: () {
                showFilterBottomSheet(presenter);
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

  showFilterBottomSheet(ProfilePresenter presenter) {
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
