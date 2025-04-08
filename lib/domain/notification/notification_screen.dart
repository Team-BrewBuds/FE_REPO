import 'package:animations/animations.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/notification/notification_item_widget.dart';
import 'package:brew_buds/domain/notification/notification_presenter.dart';
import 'package:brew_buds/model/notification/notification_model.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<String?> showNotificationPage({required BuildContext context}) {
  return showGeneralDialog<String>(
    context: context,
    barrierColor: ColorStyles.white,
    pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider<NotificationPresenter>(
      create: (_) => NotificationPresenter(),
      child: const NotificationScreen(),
    ),
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
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationPresenter>().initState();
    });
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
            body: ValueListenableBuilder(
              valueListenable: isDeletingModeNotifier,
              builder: (context, isDeletingMode, child) {
                return Column(
                  children: [
                    Container(height: 1, color: ColorStyles.gray20),
                    if (isDeletingMode)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: ColorStyles.gray20,
                        child: Row(
                          children: [
                            const Spacer(),
                            ThrottleButton(
                              onTap: () {
                                context.read<NotificationPresenter>().readAll();
                              },
                              child: Text(
                                '전체 읽기',
                                style: TextStyles.title01SemiBold,
                              ),
                            ),
                            const SizedBox(width: 24),
                            ThrottleButton(
                              onTap: () {
                                context.read<NotificationPresenter>().deleteAll();
                              },
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
                      ),
                    Expanded(
                      child: Selector<NotificationPresenter, List<NotificationModel>>(
                        selector: (context, presenter) => presenter.notificationList,
                        builder: (context, notificationList, child) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scroll) {
                              if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                                paginationThrottle.setValue(null);
                              }
                              return false;
                            },
                            child: ListView.separated(
                              itemCount: notificationList.length,
                              itemBuilder: (context, index) {
                                final notification = notificationList[index];
                                return ThrottleButton(
                                  onTap: () {
                                    context.read<NotificationPresenter>().readAt(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: isDeletingMode
                                        ? Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            spacing: 10,
                                            children: [
                                              Expanded(
                                                child: NotificationItemWidget(
                                                  body: notification.body,
                                                  date: notification.createdAt,
                                                  isRead: notification.isRead,
                                                ),
                                              ),
                                              ThrottleButton(
                                                onTap: () {
                                                  context.read<NotificationPresenter>().deleteAt(index);
                                                },
                                                child: SvgPicture.asset('assets/icons/x.svg', width: 24, height: 24),
                                              ),
                                            ],
                                          )
                                        : NotificationItemWidget(
                                            body: notification.body,
                                            date: notification.createdAt,
                                            isRead: notification.isRead,
                                          ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => Container(height: 1, color: ColorStyles.gray20),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
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
      title: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 12),
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
