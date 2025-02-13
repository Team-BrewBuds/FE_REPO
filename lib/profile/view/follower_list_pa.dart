import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/profile/presenter/follower_list_presenter.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FollowerListPA extends StatefulWidget {
  final int initialIndex;

  const FollowerListPA({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<FollowerListPA> createState() => _FollowerListPAState();
}

class _FollowerListPAState extends State<FollowerListPA> {
  late final Throttle paginationThrottle;
  late final ScrollController scrollController;
  bool isRefresh = false;

  @override
  void initState() {
    scrollController = ScrollController();
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
      context.read<FollowerListPresenter>().init(widget.initialIndex);
      scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    paginationThrottle.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<FollowerListPresenter>().moreData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerListPresenter>(builder: (context, presenter, _) {
      return Scaffold(
        appBar: _buildTitle(nickName: presenter.nickName),
        body: DefaultTabController(
          length: 2,
          initialIndex: widget.initialIndex,
          child: Column(
            children: [
              _buildTabBar(presenter),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: presenter.users.length,
                  itemBuilder: (context, index) {
                    final user = presenter.users[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffD9D9D9),
                            ),
                            child: Image.network(
                              user.user.profileImageUri,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              user.user.nickname,
                              style: TextStyles.labelMediumMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ButtonFactory.buildOvalButton(
                            onTapped: () {
                              presenter.onTappedFollowButton(user, index);
                            },
                            text: user.isFollowing ? '팔로우 취소' : '맞팔로우',
                            style: user.isFollowing
                                ? OvalButtonStyle.fill(
                                    color: ColorStyles.gray20,
                                    textColor: ColorStyles.gray80,
                                    size: OvalButtonSize.large)
                                : OvalButtonStyle.fill(
                                    color: ColorStyles.red, textColor: ColorStyles.white, size: OvalButtonSize.large),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  AppBar _buildTitle({required String nickName}) {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Text(nickName, style: TextStyles.title02SemiBold),
            const Spacer(),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(FollowerListPresenter presenter) {
    return TabBar(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorWeight: 2,
      indicatorPadding: const EdgeInsets.only(top: 4, left: 16, right: 16),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: ColorStyles.black,
      labelPadding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      labelStyle: TextStyles.title01SemiBold,
      labelColor: ColorStyles.black,
      unselectedLabelStyle: TextStyles.title01SemiBold,
      unselectedLabelColor: ColorStyles.gray50,
      dividerHeight: 1,
      dividerColor: ColorStyles.gray20,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      tabs: const [
        Tab(text: '팔로워', height: 31),
        Tab(text: '팔로잉', height: 31),
      ],
      onTap: (index) {
        presenter.onChangeTab(index);
      },
    );
  }
}
