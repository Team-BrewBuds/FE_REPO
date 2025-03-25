import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
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
                    activeColor: ColorStyles.red,
                    onChanged: (value) {
                      openAppSettings();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          FutureBuilder(
            future: FirebaseMessaging.instance.getToken(),
            initialData: '',
            builder: (context, snapshot) {
              final token = snapshot.data;
              if (token != null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Firebase FCM Token', style: TextStyles.labelMediumMedium),
                      SizedBox(height: 8),
                      SelectableText(token, style: TextStyles.captionMediumMedium, maxLines: null),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
              return SelectableText(snapshot.data!);
            },
          ),
        ],
      ),
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
}
