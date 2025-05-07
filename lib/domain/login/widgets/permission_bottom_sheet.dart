import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PermissionBottomSheet extends StatefulWidget {
  const PermissionBottomSheet({super.key});

  @override
  State<PermissionBottomSheet> createState() => _PermissionBottomSheetState();
}

class _PermissionBottomSheetState extends State<PermissionBottomSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              decoration:
                  const BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '브루버즈를 사용하기 위해 필요한\n접근권한을 안내해 드릴게요.',
                    textAlign: TextAlign.center,
                    style: TextStyles.title02Bold,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '카메라 (선택)',
                    textAlign: TextAlign.start,
                    style: TextStyles.title01SemiBold,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '커피 노트 작성 시 사진 촬영',
                    textAlign: TextAlign.start,
                    style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '사진 권한 (선택)',
                    textAlign: TextAlign.start,
                    style: TextStyles.title01SemiBold,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '프로필 설정, 커피 노트 작성 시 사진 첨부',
                    textAlign: TextAlign.start,
                    style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '위치 권한 (선택)',
                    textAlign: TextAlign.start,
                    style: TextStyles.title01SemiBold,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '커피 노트 작성 시 장소 검색',
                    textAlign: TextAlign.start,
                    style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '알림 (선택)',
                    textAlign: TextAlign.start,
                    style: TextStyles.title01SemiBold,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '좋아요, 댓글 등 반응 및 이벤트 혜택 알림',
                    textAlign: TextAlign.start,
                    style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '브루버즈는  더 나은 서비스를 제공하기 위해 서비스에 꼭 필요한 기능들에 접근하고 있습니다. 서비스 제공에 접근 권한이 꼭 필요한 경우에만 동의를 받고 있으며, 해당 기능을 허용하지 않으셔도 브루버즈를 이용하실 수 있습니다. ',
                    textAlign: TextAlign.start,
                    style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                    maxLines: null,
                  ),
                  const SizedBox(height: 26),
                  FutureButton(
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      return PermissionRepository.instance.initPermission();
                    },
                    onComplete: (_) async {
                      await Future.wait([
                        AccountRepository.instance.init(),
                        NotificationRepository.instance.init(),
                        SharedPreferencesRepository.instance.setLogin(),
                      ]);
                      PhotoRepository.instance.initState();
                      if (context.mounted) {
                        context.pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      decoration: const BoxDecoration(
                        color: ColorStyles.black,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        '확인',
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
        if (_isLoading)
          const Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: LoadingBarrier(),
            ),
          ),
      ],
    );
  }
}
