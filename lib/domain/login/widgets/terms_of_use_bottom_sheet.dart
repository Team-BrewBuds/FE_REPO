import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/web_view/web_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TermsOfUseBottomSheet extends StatefulWidget {
  const TermsOfUseBottomSheet({super.key});

  @override
  State<TermsOfUseBottomSheet> createState() => _TermsOfUseBottomSheetState();
}

class _TermsOfUseBottomSheetState extends State<TermsOfUseBottomSheet> {
  List<bool> _checkList = List<bool>.filled(5, false);

  bool get isAllChecked => _checkList[0] && _checkList[1] && _checkList[2] && _checkList[3] && _checkList[4];

  bool get isRequiredChecked => _checkList[0] && _checkList[1] && _checkList[2] && _checkList[3];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: ColorStyles.gray40)),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              '서비스 이용약관에 동의해주세요',
                              style: TextStyles.title01SemiBold,
                            ),
                          ),
                          Positioned(
                            right: 16,
                            child: Center(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: SvgPicture.asset('assets/icons/x.svg', width: 16, height: 16, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: ColorStyles.gray20,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ThrottleButton(
                            onTap: () {
                              setState(() {
                                if (isAllChecked) {
                                  _checkList = List<bool>.filled(5, false);
                                } else {
                                  _checkList = List<bool>.filled(5, true);
                                }
                              });
                            },
                            child: SvgPicture.asset('assets/icons/${isAllChecked ? 'checked.svg' : 'uncheck.svg'}',
                                height: 18, width: 18),
                          ),
                          const SizedBox(width: 8),
                          Text('약관 전체 동의', style: TextStyles.labelSmallSemiBold),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
                      ),
                      child: Column(
                        children: [
                          ThrottleButton(
                            onTap: () {
                              showCupertinoModalPopup(
                                barrierColor: ColorStyles.white,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const WebScreen(
                                    url: 'https://brewbuds.notion.site/19497baa9f4880d68698c9a8218a5f0c'),
                              );
                            },
                            child: Row(
                              children: [
                                ThrottleButton(
                                  onTap: () {
                                    setState(() {
                                      _checkList[0] = !_checkList[0];
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${_checkList[0] ? 'checked.svg' : 'uncheck.svg'}',
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(필수) 브루버즈 이용약관 동의',
                                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/arrow.svg',
                                  height: 24,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ThrottleButton(
                            onTap: () {
                              showCupertinoModalPopup(
                                barrierColor: ColorStyles.white,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const WebScreen(
                                    url: 'https://brewbuds.notion.site/19497baa9f48809a9b64e120aeb07b1d'),
                              );
                            },
                            child: Row(
                              children: [
                                ThrottleButton(
                                  onTap: () {
                                    setState(() {
                                      _checkList[1] = !_checkList[1];
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${_checkList[1] ? 'checked.svg' : 'uncheck.svg'}',
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(필수) 개인정보 수집 및 이용 동의',
                                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/arrow.svg',
                                  height: 24,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ThrottleButton(
                            onTap: () {
                              showCupertinoModalPopup(
                                barrierColor: ColorStyles.white,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const WebScreen(
                                    url: 'https://brewbuds.notion.site/1e797baa9f48803ab48fede661655611'),
                              );
                            },
                            child: Row(
                              children: [
                                ThrottleButton(
                                  onTap: () {
                                    setState(() {
                                      _checkList[2] = !_checkList[2];
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/${_checkList[2] ? 'checked.svg' : 'uncheck.svg'}',
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(필수) 개인정보 국외 이전 동의',
                                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray70),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  'assets/icons/arrow.svg',
                                  height: 24,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThrottleButton(
                                onTap: () {
                                  setState(() {
                                    _checkList[3] = !_checkList[3];
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/${_checkList[3] ? 'checked.svg' : 'uncheck.svg'}',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '(필수) 14세 이상 확인',
                                    style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray70),
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text(
                                      '14세 미만의 회원가입은 불가합니다.',
                                      style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray70),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ThrottleButton(
                                onTap: () {
                                  setState(() {
                                    _checkList[4] = !_checkList[4];
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/${_checkList[4] ? 'checked.svg' : 'uncheck.svg'}',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(선택) 개인정보 마케팅 활용 동의',
                                style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray70),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: !isRequiredChecked,
                      child: Container(
                        padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 24),
                        width: double.infinity,
                        child: ThrottleButton(
                          onTap: () {
                            context.pop(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isRequiredChecked ? ColorStyles.black : ColorStyles.gray30,
                            ),
                            child: Center(
                              child: Text(
                                '다음',
                                style: TextStyles.labelMediumMedium.copyWith(
                                  color: isRequiredChecked ? ColorStyles.white : ColorStyles.gray40,
                                ),
                              ),
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
        ),
      ],
    );
  }
}
