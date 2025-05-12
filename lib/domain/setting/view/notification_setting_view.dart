import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/domain/setting/presenter/notification_setting_presenter.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NotificationSettingView extends StatefulWidget {
  const NotificationSettingView({super.key});

  @override
  State<NotificationSettingView> createState() => _NotificationSettingViewState();
}

class _NotificationSettingViewState extends State<NotificationSettingView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationSettingPresenter>().requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isLoading = context.select<NotificationSettingPresenter, bool>(
              (presenter) => presenter.isLoading,
        );
        return Stack(
          children: [
            Scaffold(
              appBar: _buildAppBar(),
              body: _buildBody(),
            ),
            if (isLoading) const Positioned.fill(child: LoadingBarrier()),
          ],
        );
      }
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
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
            Text('알림 설정', style: TextStyles.title02Bold),
            const Spacer(),
            const SizedBox(
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) {
          final isGranted = context.select<NotificationSettingPresenter, bool>(
                (presenter) => presenter.isGranted,
          );
          final settings = context.select<NotificationSettingPresenter, NotificationSetting?>(
                (presenter) => presenter.notificationSetting,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('기기 알림 설정', style: TextStyles.labelMediumMedium),
                          const SizedBox(height: 8),
                          Text(
                            '모든 알림 차단',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.gray50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    SizedBox(
                      width: 50,
                      height: 30,
                      child: Builder(builder: (context) {
                        return CupertinoSwitch(
                          value: isGranted,
                          activeTrackColor: ColorStyles.red,
                          onChanged: (value) {
                            openAppSettings();
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              if (isGranted && settings != null) ...[
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('팔로우', style: TextStyles.labelSmallSemiBold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: ColorStyles.gray20), bottom: BorderSide(color: ColorStyles.gray20)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('새로운 팔로워', style: TextStyles.labelMediumMedium),
                            const SizedBox(height: 8),
                            Text(
                              '나를 팔로우하는 버디 안내',
                              style: TextStyles.captionMediumMedium.copyWith(
                                color: ColorStyles.gray50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: CupertinoSwitch(
                          value: settings.follow,
                          activeTrackColor: ColorStyles.red,
                          onChanged: (value) {
                            context.read<NotificationSettingPresenter>().onChangeFollowNotifyState();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('커피노트', style: TextStyles.labelSmallSemiBold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('좋아요', style: TextStyles.labelMediumMedium),
                            const SizedBox(height: 8),
                            Text(
                              '내가 작성한 커피노트 좋아요 안내',
                              style: TextStyles.captionMediumMedium.copyWith(
                                color: ColorStyles.gray50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: CupertinoSwitch(
                          value: settings.like,
                          activeTrackColor: ColorStyles.red,
                          onChanged: (value) {
                            context.read<NotificationSettingPresenter>().onChangeLikeNotifyState();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: ColorStyles.gray20), bottom: BorderSide(color: ColorStyles.gray20)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('댓글', style: TextStyles.labelMediumMedium),
                            const SizedBox(height: 8),
                            Text(
                              '내가 작성한 커피노트의 댓글 또는 댓글의 답글 안내',
                              style: TextStyles.captionMediumMedium.copyWith(
                                color: ColorStyles.gray50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: CupertinoSwitch(
                          value: settings.comment,
                          activeTrackColor: ColorStyles.red,
                          onChanged: (value) {
                            context.read<NotificationSettingPresenter>().onChangeCommentNotifyState();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('마케팅', style: TextStyles.labelSmallSemiBold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: ColorStyles.gray20), bottom: BorderSide(color: ColorStyles.gray20)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('혜택 정보 수신', style: TextStyles.labelMediumMedium),
                            const SizedBox(height: 8),
                            Text(
                              '개인 맞춤 혜택과 이벤트 소식을 안내',
                              style: TextStyles.captionMediumMedium.copyWith(
                                color: ColorStyles.gray50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: CupertinoSwitch(
                          value: settings.marketing,
                          activeTrackColor: ColorStyles.red,
                          onChanged: (value) {
                            context.read<NotificationSettingPresenter>().onChangeMarketingNotifyState();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          );
        }
      ),
    );
  }
}
