import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedView extends StatelessWidget {
  final String title;
  final String subtitle;

  const PermissionDeniedView({
    super.key,
    required this.title,
    required this.subtitle,
  });

  factory PermissionDeniedView.photo() => const PermissionDeniedView(
        title: '사진 보관함에 접근할 수 있도록 허가해 주세요.',
        subtitle: '커피노트를 작성할 때 사진 보관함의 사진을 추가하고 다른 버디와 공유할 수 있습니다.',
      );

  factory PermissionDeniedView.camera() => const PermissionDeniedView(
        title: '카메라에 접근할 수 있도록 허가해 주세요.',
        subtitle: '커피노트를 작성할 때 촬영한 사진을 첨부하여 다른 버디와 공유할 수 있습니다.',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.black,
      appBar: AppBar(
        backgroundColor: ColorStyles.black,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 19, right: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/x.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.white)),
                  const SizedBox(height: 8),
                  Text(
                    subtitle.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
                    style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      openAppSettings();
                    },
                    child: Text(
                      '라이브러리 액세스 허용',
                      style: TextStyles.title01SemiBold.copyWith(color: Colors.indigoAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
