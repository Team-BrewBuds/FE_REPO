import 'dart:ui';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/domain/home/comments/comments_presenter.dart';
import 'package:brew_buds/domain/home/comments/comments_view.dart';
import 'package:brew_buds/domain/home/feed/post_feed_widget.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/post_feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/tasted_record_feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/tasting_record_feed_widget.dart';
import 'package:brew_buds/domain/home/home_presenter.dart';
import 'package:brew_buds/domain/home/widgets/recommended_buddy_list.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/views/login_bottom_sheet.dart';
import 'package:brew_buds/domain/notification/notification_screen.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late final Throttle paginationThrottle;
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;
  bool isRefresh = false;
  int currentIndex = 0;

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
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    _scrollController.removeListener(_scrollListener);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
  }

  _fetchMoreData() {
    context.read<HomePresenter>().fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return buildApp(context);
  }

  Widget buildApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        titleSpacing: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 130,
              ),
              const Spacer(),
              if (context.select<AccountRepository, bool>((repository) => !repository.isGuest)) ...[
                ThrottleButton(
                  onTap: () {
                    AccountRepository.instance.readNotification();
                    showNotificationPage(context: context);
                  },
                  child: Builder(
                    builder: (context) {
                      final hasNotification =
                          context.select<AccountRepository, bool>((repository) => repository.hasNotification);
                      return SvgPicture.asset(
                        hasNotification ? 'assets/icons/alarm_active.svg' : 'assets/icons/alarm.svg',
                        width: 24,
                        height: 24,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      body: Container(
        color: ColorStyles.gray20,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            Builder(builder: (context) {
              final isPostFeed = context.select<HomePresenter, bool>((presenter) => presenter.isPostFeed);
              return SliverAppBar(
                floating: true,
                titleSpacing: 0,
                toolbarHeight: isPostFeed ? 116 : kToolbarHeight,
                title: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2, color: ColorStyles.black),
                        insets: EdgeInsets.only(top: 4),
                      ),
                      labelPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: TextStyles.title02SemiBold,
                      labelColor: ColorStyles.black,
                      unselectedLabelStyle: TextStyles.title02SemiBold,
                      unselectedLabelColor: ColorStyles.gray50,
                      dividerColor: Colors.white,
                      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                      tabs: const [
                        Tab(text: '전체', height: 31),
                        Tab(text: '시음기록', height: 31),
                        Tab(text: '게시글', height: 31),
                      ],
                      onTap: (index) {
                        if (_tabController.index == _tabController.previousIndex) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          context.read<HomePresenter>().onChangeTab(index);
                        }
                      },
                    ),
                    if (isPostFeed)
                      buildSubjectFilterBar(
                        currentSubject:
                            context.select<HomePresenter, PostSubject>((presenter) => presenter.currentSubject),
                      ),
                  ],
                ),
              );
            }),
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 56,
              refreshIndicatorExtent: 56,
              builder: (
                BuildContext context,
                RefreshIndicatorMode refreshState,
                double pulledExtent,
                double refreshTriggerPullDistance,
                double refreshIndicatorExtent,
              ) {
                switch (refreshState) {
                  case RefreshIndicatorMode.drag:
                    final double percentageComplete = clampDouble(
                      pulledExtent / refreshTriggerPullDistance,
                      0.0,
                      1.0,
                    );
                    const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
                    return Opacity(
                      opacity: opacityCurve.transform(percentageComplete),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CupertinoActivityIndicator.partiallyRevealed(
                              progress: percentageComplete,
                              color: ColorStyles.gray70,
                            ),
                          ),
                        ),
                      ),
                    );
                  case RefreshIndicatorMode.armed || RefreshIndicatorMode.refresh:
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                        ),
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
              onRefresh: () {
                return context.read<HomePresenter>().onRefresh();
              },
            ),
            Builder(
              builder: (context) {
                final feedPresenters = context.select<HomePresenter, List<FeedPresenter>>(
                  (presenter) => presenter.feedPresenters,
                );
                return SliverPadding(
                  padding: const EdgeInsets.only(top: 12),
                  sliver: SliverList.separated(
                    itemCount: feedPresenters.length,
                    itemBuilder: (context, index) {
                      final feedPresenter = feedPresenters[index];
                      final isGuest = AccountRepository.instance.isGuest;
                      if (feedPresenter is PostFeedPresenter) {
                        return ChangeNotifierProvider.value(
                          value: feedPresenter,
                          child: PostFeedWidget(
                            isGuest: isGuest,
                            onGuest: () {
                              showLoginBottomSheet();
                            },
                            onTapComments: (isPost, id, author) {
                              showCommentsBottomSheet(isPost: isPost, id: id, author: author);
                            },
                          ),
                        );
                      } else if (feedPresenter is TastedRecordFeedPresenter) {
                        return ChangeNotifierProvider.value(
                          value: feedPresenter,
                          child: TastedRecordFeedWidget(
                            isGuest: isGuest,
                            onGuest: () {
                              showLoginBottomSheet();
                            },
                            onTapComments: (isPost, id, author) {
                              showCommentsBottomSheet(isPost: isPost, id: id, author: author);
                            },
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    separatorBuilder: (context, index) => index % 12 != 11
                        ? Container(height: 12, color: ColorStyles.gray20)
                        : Builder(
                            builder: (context) {
                              final pageIndex = (index / 12).toInt();
                              final page = context.select<HomePresenter, RecommendedPage?>(
                                  (presenter) => presenter.getRecommendedPage(pageIndex));
                              if (page != null) {
                                return RecommendedBuddyList(
                                  page: page,
                                  onTappedFollowButton: (int index) {
                                    if (context.read<HomePresenter>().isGuest) {
                                      showLoginBottomSheet();
                                    } else {
                                      context.read<HomePresenter>().onTappedRecommendedUserFollowButton(
                                            page.users[index],
                                            pageNo: pageIndex,
                                          );
                                    }
                                  },
                                );
                              } else {
                                return Container(height: 12, color: ColorStyles.gray20);
                              }
                            },
                          ),
                  ),
                );
              },
            ),
            if (context.select<HomePresenter, bool>((presenter) => presenter.isLoading))
              SliverFillRemaining(
                child: Container(
                  color: ColorStyles.gray20,
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      color: ColorStyles.gray70,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  showCommentsBottomSheet({required bool isPost, required int id, required User author}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: ColorStyles.black50,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider<CommentsPresenter>(
          create: (_) => CommentsPresenter(
            isPost: isPost,
            id: id,
            author: author,
          ),
          child: CommentBottomSheet(minimumHeight: MediaQuery.of(context).size.height * 0.7),
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

  showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black70,
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

  Widget buildSubjectFilterBar({required PostSubject currentSubject}) {
    const subjectList = PostSubject.values;
    final isGuest = context.read<HomePresenter>().isGuest;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 6,
          children: List<Widget>.generate(
            subjectList.length + 1,
            (index) {
              if (index == 0) {
                return ThrottleButton(
                  onTap: () {
                    if (isGuest) {
                      showLoginBottomSheet();
                    } else {
                      context.push('/home/popular_post');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: ColorStyles.background,
                      border: Border.all(color: ColorStyles.red),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      '인기',
                      style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.red),
                    ),
                  ),
                );
              } else {
                final subject = subjectList[index - 1];
                return ThrottleButton(
                  onTap: () {
                    context.read<HomePresenter>().onSelectPostSubject(subject);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: subject == currentSubject
                        ? const BoxDecoration(
                            color: ColorStyles.black,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          )
                        : BoxDecoration(
                            border: Border.all(color: ColorStyles.gray70),
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                    child: Text(
                      subject.toString(),
                      style: TextStyles.labelMediumMedium.copyWith(
                        color: subject == currentSubject ? ColorStyles.white : ColorStyles.gray70,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  showLoginBottomSheet() async {
    final context = this.context;
    final result = await showBarrierDialog<Result<LoginResult>>(
      context: context,
      pageBuilder: (context, _, __) => LoginBottomSheet.buildWithPresenter(),
    );

    if (result != null && context.mounted) {
      switch (result) {
        case Success<LoginResult>():
          switch (result.data) {
            case LoginResult.login:
              context.read<HomePresenter>().login();
              break;
            case LoginResult.needSignUp:
              context.push('/login/signup/1');
              break;
          }
          break;
        case Error<LoginResult>():
          showSnackBar(message: result.e);
          break;
      }
    }
  }
}
