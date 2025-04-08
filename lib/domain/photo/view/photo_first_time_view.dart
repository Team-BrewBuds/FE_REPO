import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhotoFirstTimeView extends StatelessWidget {
  final Function() onNext;

  const PhotoFirstTimeView({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: ColorStyles.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 46),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Brewbuds에서 회원님의\n사진 보관함에 접근하도록 허용',
                style: TextStyles.title05Bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/coffee_note_with_gallery.svg', width: 24, height: 24),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('이 권한을 사용하는 방식', style: TextStyles.title01SemiBold),
                        Text(
                          '커피노트를 작성할 때 사진 보관함의 사진을 추가하고 다른 버디와 공유할 수 있습니다.',
                          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/coffee_note_with_camera.svg', width: 24, height: 24),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('이 권한을 사용되는 방식', style: TextStyles.title01SemiBold),
                        Text(
                          '회원님이 Brewbuds에 사진 보관함의 사진을 다른 버디와 공유할 수 있도록 지원합니다.',
                          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/setting.svg', width: 24, height: 24),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('이 권한 설정 방법', style: TextStyles.title01SemiBold),
                        Text(
                          '디바이스 설정에서 언제든지 권한 설정을 변경할 수 있습니다. 지금 접근 허용을 하면, 다시 허용하지 않아도 됩니다.',
                          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  onNext.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration:
                      const BoxDecoration(color: ColorStyles.black, borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    '다음',
                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
