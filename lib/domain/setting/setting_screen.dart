import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/domain/setting/model/setting_category.dart';
import 'package:brew_buds/domain/setting/model/setting_item.dart';
import 'package:brew_buds/domain/setting/view/sign_out_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with CenterDialogMixin<SettingScreen>, SnackBarMixin<SettingScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: ListView.separated(
          itemCount: SettingCategory.values.length,
          itemBuilder: (context, index) {
            final category = SettingCategory.values[index];
            final title = category.toString();
            return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 1, children: [
              if (title.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: ColorStyles.white,
                  child: Text(title, style: TextStyles.title01SemiBold),
                ),
              ...category.items.map((item) {
                if (item == SettingItem.version) {
                  return ThrottleButton(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: ColorStyles.white,
                      child: Row(
                        children: [
                          Text(item.toString(), style: TextStyles.labelMediumMedium),
                          const Spacer(),
                          Text(_packageInfo.version, style: TextStyles.labelMediumMedium),
                        ],
                      ),
                    ),
                  );
                }
                return ThrottleButton(
                  onTap: () {
                    onTapped(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: ColorStyles.white,
                    child: Row(
                      children: [
                        Text(item.toString(), style: TextStyles.labelMediumMedium),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/arrow.svg',
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ]);
          },
          separatorBuilder: (context, index) => Container(height: 12, color: ColorStyles.gray20),
        ),
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
            Text('설정', style: TextStyles.title02Bold),
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

  onTapped(SettingItem item) async {
    final context = this.context;
    switch (item) {
      case SettingItem.notification:
        context.go('/profile/setting/notification');
        break;
      case SettingItem.block:
        context.go('/profile/setting/block');
        break;
      case SettingItem.account:
        context.go('/profile/setting/account_info');
        break;
      case SettingItem.detail:
        context.push<String>('/profile/setting/account_detail').then((value) {
          if (value != null) {
            showSnackBar(message: value);
          }
        });
        break;
      case SettingItem.notice:
        break;
      case SettingItem.help:
        break;
      case SettingItem.improvements:
        break;
      case SettingItem.evaluation:
        break;
      case SettingItem.registrationOfBeans:
        break;
      case SettingItem.inquiry:
        break;
      case SettingItem.terms:
        break;
      case SettingItem.policy:
        break;
      case SettingItem.openSourceLicense:
        break;
      case SettingItem.version:
        break;
      case SettingItem.logout:
        final result = await showLogoutBottomSheet().then((value) => value ?? false).onError((_, __) => false);

        if (result) {
          final notificationResult =
              await NotificationRepository.instance.deleteToken().then((_) => true).onError((_, __) => false);
          if (notificationResult) {
            final logoutResult = await AccountRepository.instance.logout().then((_) => true).onError((_, __) => false);
            if (logoutResult) {
              if (context.mounted) {
                context.go('/');
                break;
              }
            }
          }
          showSnackBar(message: '로그아웃에 실패했습니다.');
          break;
        }
        break;
      case SettingItem.signOut:
        final result = await showSignOutBottomSheet();

        if (result != null && result && context.mounted) {
          showCupertinoModalPopup(
            barrierColor: ColorStyles.white,
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const SignOutView();
            },
          );
        }
        break;
    }
  }

  Future<bool?> showLogoutBottomSheet() {
    return showBarrierDialog<bool>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      ThrottleButton(
                        onTap: () {
                          context.pop(true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
                          child: Center(
                            child: Text(
                              '로그아웃',
                              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: ThrottleButton(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorStyles.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '닫기',
                                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showSignOutBottomSheet() {
    return showBarrierDialog<bool>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      ThrottleButton(
                        onTap: () {
                          context.pop(true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
                          child: Center(
                            child: Text(
                              '회원탈퇴',
                              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: ThrottleButton(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            decoration: BoxDecoration(
                              color: ColorStyles.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '닫기',
                                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
