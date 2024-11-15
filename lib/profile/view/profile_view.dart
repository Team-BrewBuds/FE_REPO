import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:brew_buds/profile/view/filter_bottom_sheet.dart';
import 'package:brew_buds/profile/widgets/sort_criteria_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final Widget child;

  const ProfileView({
    super.key,
    required this.child,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int currentIndex = 0;
  bool isRefresh = false;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
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
          builder: (context, presenter, _) => CustomScrollView(
            controller: scrollController,
            slivers: [
              _buildTitle(),
              _buildProfile(),
              _buildTabBar(),
              SliverToBoxAdapter(child: Container(height: 1, width: double.infinity, color: ColorStyles.gray30)),
              currentIndex == 0 || currentIndex == 2 ? _buildFilter(presenter) : const SliverToBoxAdapter(),
              SliverFillRemaining(child: isRefresh ? Container() : _buildGridView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    switch (currentIndex) {
      case 0:
        return const Center(child: Text('첫 시음기록을 작성해 보세요.', style: TextStyles.bodyRegular));
      case 1:
        return const Center(child: Text('첫 게시글을 작성해 보세요.', style: TextStyles.bodyRegular));
      case 2:
        return const Center(child: Text('찜한 원두가 없습니다.', style: TextStyles.bodyRegular));
      case 3:
        return const Center(child: Text('저장한 노트가 없습니다.', style: TextStyles.bodyRegular));
      default:
        return Container();
    }
  }

  SliverAppBar _buildTitle() {
    return SliverAppBar(
      titleSpacing: 0,
      pinned: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('출근하자마자커피한잔'),
            const Spacer(),
            InkWell(
              onTap: () {},
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

  SliverToBoxAdapter _buildProfile() {
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
                  child: Container(),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '000',
                              style: TextStyles.captionMediumMedium,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '시음기록',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '000',
                              style: TextStyles.captionMediumMedium,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '팔로워',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '000',
                              style: TextStyles.captionMediumMedium,
                            ),
                            SizedBox(height: 6),
                            Text(
                              '팔로잉',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 6),
                  decoration: const BoxDecoration(
                    color: ColorStyles.gray20,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      const Text('버디님이 즐기는 커피 생활을 알려주세요', style: TextStyles.captionMediumRegular),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset('assets/icons/arrow.svg', height: 18, width: 18),
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ],
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

  SliverAppBar _buildTabBar() {
    return SliverAppBar(
      floating: true,
      titleSpacing: 0,
      title: TabBar(
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
      ),
    );
  }

  SliverAppBar _buildFilter(ProfilePresenter presenter) {
    return SliverAppBar(
      titleSpacing: 0,
      floating: true,
      title: Padding(
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
                  showGeneralDialog(
                    barrierLabel: "Barrier",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: const Duration(milliseconds: 300),
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return ChangeNotifierProvider<FilterPresenter>(
                        create: (_) => FilterPresenter(),
                        child: FilterBottomSheet(),
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
                text: '필터',
                iconPath: 'assets/icons/union.svg',
                isLeftIcon: true,
              ),
              _buildIcon(
                onTap: () {},
                text: '원두유형',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
              ),
              _buildIcon(
                onTap: () {},
                text: '생산 국가',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
              ),
              _buildIcon(
                onTap: () {},
                text: '평균 별점',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
              ),
              _buildIcon(
                onTap: () {},
                text: '로스팅 포인트',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
              ),
              _buildIcon(
                onTap: () {},
                text: '디카페인',
                iconPath: 'assets/icons/down.svg',
                isLeftIcon: false,
              ),
            ].separator(separatorWidget: const SizedBox(width: 4)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon({
    required void Function() onTap,
    required String text,
    required String iconPath,
    required bool isLeftIcon,
  }) {
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
          border: Border.all(color: ColorStyles.gray70, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            isLeftIcon
                ? SvgPicture.asset(iconPath, height: 18, width: 18, fit: BoxFit.cover)
                : Text(text, style: TextStyles.captionMediumRegular),
            const SizedBox(width: 2),
            isLeftIcon
                ? Text(text, style: TextStyles.captionMediumRegular)
                : SvgPicture.asset(iconPath, height: 18, width: 18, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
