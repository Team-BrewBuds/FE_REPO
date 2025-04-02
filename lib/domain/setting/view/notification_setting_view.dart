import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/domain/setting/presenter/notification_setting_presenter.dart';
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
  bool _isGranted = PermissionRepository.instance.notification.isGranted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationSettingPresenter>().initState();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await PermissionRepository.instance.requestNotification();
      setState(() {
        _isGranted = PermissionRepository.instance.notification.isGranted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: _isGranted ? _buildGrantedBody() : _buildDeniedBody(),
        ),
        if (context.select<NotificationSettingPresenter, bool>((presenter) => presenter.isLoading))
          const Positioned.fill(child: LoadingBarrier()),
      ],
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
            GestureDetector(
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
            const Text('알림 설정', style: TextStyles.title02Bold),
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

  Widget _buildGrantedBody() {
    return SingleChildScrollView(
      child: Column(
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
                      const Text('기기 알림 설정', style: TextStyles.labelMediumMedium),
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
                  child: CupertinoSwitch(
                    value: _isGranted,
                    activeTrackColor: ColorStyles.red,
                    onChanged: (value) {
                      openAppSettings();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                      const Text('새로운 팔로워', style: TextStyles.labelMediumMedium),
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
                Builder(builder: (context) {
                  final value = context.select<NotificationSettingPresenter, bool>(
                      (presenter) => presenter.notificationSetting?.follow ?? false);
                  return SizedBox(
                    width: 50,
                    height: 30,
                    child: CupertinoSwitch(
                      value: value,
                      activeTrackColor: ColorStyles.red,
                      onChanged: (value) {
                        context.read<NotificationSettingPresenter>().onChangeFollowNotifyState();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                      const Text('좋아요', style: TextStyles.labelMediumMedium),
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
                Builder(builder: (context) {
                  final value = context.select<NotificationSettingPresenter, bool>(
                      (presenter) => presenter.notificationSetting?.like ?? false);
                  return SizedBox(
                    width: 50,
                    height: 30,
                    child: CupertinoSwitch(
                      value: value,
                      activeTrackColor: ColorStyles.red,
                      onChanged: (value) {
                        context.read<NotificationSettingPresenter>().onChangeLikeNotifyState();
                      },
                    ),
                  );
                }),
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
                      const Text('댓글', style: TextStyles.labelMediumMedium),
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
                Builder(
                  builder: (context) {
                    final value = context.select<NotificationSettingPresenter, bool>(
                            (presenter) => presenter.notificationSetting?.comment ?? false);
                    return SizedBox(
                      width: 50,
                      height: 30,
                      child: CupertinoSwitch(
                        value: value,
                        activeTrackColor: ColorStyles.red,
                        onChanged: (value) {
                          context.read<NotificationSettingPresenter>().onChangeCommentNotifyState();
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                      const Text('혜택 정보 수신', style: TextStyles.labelMediumMedium),
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
                Builder(
                  builder: (context) {
                    final value = context.select<NotificationSettingPresenter, bool>(
                            (presenter) => presenter.notificationSetting?.marketing ?? false);
                    return SizedBox(
                      width: 50,
                      height: 30,
                      child: CupertinoSwitch(
                        value: value,
                        activeTrackColor: ColorStyles.red,
                        onChanged: (value) {
                          context.read<NotificationSettingPresenter>().onChangeMarketingNotifyState();
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeniedBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('기기 알림 설정', style: TextStyles.labelMediumMedium),
                const SizedBox(height: 8),
                Text(
                  '내가 작성한 커피 노트에 대한 반응과 나를 팔로우 하는 버디 등 꼭 필요한 것만 알려드려요.',
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
              value: _isGranted,
              activeTrackColor: ColorStyles.red,
              onChanged: (value) {
                openAppSettings();
              },
            ),
          ),
        ],
      ),
    );
  }
}
