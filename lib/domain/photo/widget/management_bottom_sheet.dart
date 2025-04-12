import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ManagementBottomSheetResult {
  management,
  openSetting;
}

class ManagementBottomSheet extends StatelessWidget {
  const ManagementBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ThrottleButton(
                        onTap: () {
                          context.pop(ManagementBottomSheetResult.management);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: ColorStyles.gray40),
                            ),
                          ),
                          child: Text(
                            '더 많은 사진 선택',
                            textAlign: TextAlign.center,
                            style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
                          ),
                        ),
                      ),
                      ThrottleButton(
                        onTap: () {
                          context.pop(ManagementBottomSheetResult.openSetting);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            '설정 변경',
                            textAlign: TextAlign.center,
                            style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
                          ),
                        ),
                      ),
                      ThrottleButton(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          decoration: BoxDecoration(
                            color: ColorStyles.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '닫기',
                            textAlign: TextAlign.center,
                            style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
