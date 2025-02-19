import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/setting/model/setting_category.dart';
import 'package:brew_buds/setting/model/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: ColorStyles.gray20,
      body: SafeArea(
        child: ListView.separated(
          itemCount: SettingCategory.values.length,
          itemBuilder: (context, index) {
            final category = SettingCategory.values[index];
            final title = category.toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: ColorStyles.white,
                    child: Text(title, style: TextStyles.title01SemiBold),
                  ),
                ...category.items.map((item) {
                  return GestureDetector(
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
              ].separator(separatorWidget: const SizedBox(height: 1)).toList(),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
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
            const Text('설정', style: TextStyles.title02Bold),
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

  onTapped(SettingItem item) {
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
        context.go('/profile/setting/account_detail');
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
        showLogoutBottomSheet();
        break;
      case SettingItem.signOut:
        break;
    }
  }

  showLogoutBottomSheet() {
    showBarrierDialog(
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
                      InkWell(
                        onTap: () {
                          AccountRepository.instance.logout();
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
                        child: InkWell(
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
