import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/my_refresh_control.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/notification/notification_item_presenter.dart';
import 'package:brew_buds/domain/notification/notification_item_widget.dart';
import 'package:brew_buds/domain/notification/notification_presenter.dart';
import 'package:brew_buds/domain/notification/notification_tap_action.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<String?> showNotificationPage({required BuildContext context}) {
  return showGeneralDialog<String>(
    context: context,
    barrierColor: ColorStyles.white,
    pageBuilder: (context, animation, secondaryAnimation) => const NotificationScreen(),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ValueNotifier<bool> isDeletingModeNotifier = ValueNotifier(false);
  late final Throttle paginationThrottle;

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
    super.initState();
  }

  @override
  dispose() {
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<NotificationPresenter>().fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(),
            body: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: isDeletingModeNotifier,
                  builder: (context, isDeletingMode, child) {
                    return isDeletingMode
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            color: ColorStyles.gray20,
                            child: Row(
                              children: [
                                const Spacer(),
                                FutureButton(
                                  onTap: () => context.read<NotificationPresenter>().deleteAll(),
                                  child: Text(
                                    '전체 삭제',
                                    style: TextStyles.title01SemiBold,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                ThrottleButton(
                                  onTap: () {
                                    isDeletingModeNotifier.value = false;
                                  },
                                  child: Text(
                                    '닫기',
                                    style: TextStyles.title01SemiBold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent - 300) {
                        paginationThrottle.setValue(null);
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      slivers: [
                        MyRefreshControl(onRefresh: () => context.read<NotificationPresenter>().onRefresh()),
                        Selector<NotificationPresenter, List<NotificationItemPresenter>>(
                          selector: (context, presenter) => presenter.notificationList,
                          builder: (context, presenters, child) {
                            return SliverList.separated(
                              itemCount: presenters.length,
                              itemBuilder: (context, index) {
                                final presenter = presenters[index];
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: NotificationItemWidget.buildWithPresenter(
                                          presenter: presenter,
                                          onComplete: (action) {
                                            switch (action) {
                                              case JustTap():
                                                break;
                                              case PushToPostDetail():
                                                ScreenNavigator.showPostDetail(
                                                  context: context,
                                                  id: action.id,
                                                );
                                                break;
                                              case PushToTastedRecordDetail():
                                                ScreenNavigator.showTastedRecordDetail(
                                                  context: context,
                                                  id: action.id,
                                                );
                                                break;
                                              case PushToProfile():
                                                ScreenNavigator.showProfile(
                                                  context: context,
                                                  id: action.id,
                                                );
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: isDeletingModeNotifier,
                                        builder: (context, isDeletingMode, child) {
                                          if (isDeletingMode) {
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: FutureButton(
                                                onTap: () => context.read<NotificationPresenter>().deleteAt(index),
                                                child: SvgPicture.asset('assets/icons/x.svg', width: 24, height: 24),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => Container(height: 1, color: ColorStyles.gray20),
                            );
                          },
                        ),
                        Selector<NotificationPresenter, bool>(
                          selector: (context, presenter) => presenter.hasNext,
                          builder: (context, hasNext, child) {
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
              ],
            ),
          ),
        ),
        if (context.select<NotificationPresenter, bool>(
          (presenter) => presenter.isLoading && presenter.notificationList.isEmpty,
        ))
          const Positioned.fill(child: LoadingBarrier()),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      centerTitle: false,
      toolbarHeight: 65,
      title: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
        child: Row(
          children: [
            ThrottleButton(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 24,
                height: 24,
              ),
            ),
            const Spacer(),
            Text('알림', style: TextStyles.title02SemiBold),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: isDeletingModeNotifier,
              builder: (context, isDeletingMode, child) {
                return isDeletingMode
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                      )
                    : ThrottleButton(
                        onTap: () {
                          isDeletingModeNotifier.value = true;
                        },
                        child: SvgPicture.asset(
                          'assets/icons/delete.svg',
                          width: 24,
                          height: 24,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
