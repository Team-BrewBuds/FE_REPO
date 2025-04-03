import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignOutView extends StatefulWidget {
  const SignOutView({super.key});

  @override
  State<SignOutView> createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> with CenterDialogMixin<SignOutView>, SnackBarMixin<SignOutView> {
  final ProfileApi _api = ProfileApi();
  final List<String> _reason = [
    '시음 기록 과정이 복잡해요.',
    '원두 정보가 부족해요.',
    '원두 추천이 만족스럽지 못해요.',
    '렉이 걸리고 속도가 느려서 불편해요.',
    '사용 도중에 오류가 많아서 불편해요.',
    '원하는 기능이 없거나 이용이 불편해요.',
    '대체할 만한 다른 서비스가 있어요.',
    '다른 계정으로 가입하고 싶어요.',
    '비매너 버디를 만났어요.',
    '운영 정책에 아쉬운 부분이 있어요.',
  ];
  int? _selectedReasonIndex;

  bool get _isSelectedReason => _selectedReasonIndex != null;
  bool _isAgreeSignOut = false;
  int _index = 0;

  Widget get body {
    if (_index == 0) {
      return _buildGuidelines();
    } else if (_index == 1) {
      return _buildReasonSelection();
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: body),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Center(
                child: GestureDetector(
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
              ),
            ),
            const Center(child: Text('회원 탈퇴', style: TextStyles.title02Bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelines() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('버디님, 브루버즈와 함께하며\n내 커피 취향을 찾으셨나요?', style: TextStyles.title05Bold),
          const SizedBox(height: 16),
          const Text('만약, 버디님이 아직 내 커피 취향을 못 찾았다면\n브루버즈와 다시 함께해봐요!', style: TextStyles.title01SemiBold),
          const SizedBox(height: 64),
          const Text('버디님 탈퇴하기 전 아래 내용을 확인해 주세요.', style: TextStyles.bodyNarrowRegular),
          const SizedBox(height: 12),
          const Text(
            '버디님의 모든 활동 정보는 다른 회원이 식별할 수 없도록 바로 삭제되며, 삭제된 데이터는 복구할 수 없어요. (닉네임, 프로필 사진, 작성한 커피 노트, 찜한 원두, 저장한 커피 노트, 취향 리포트, 팔로워, 팔로잉, 댓글, 좋아요 내역 등 ',
            style: TextStyles.bodyNarrowRegular,
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyles.bodyNarrowRegular,
              children: _getSpans('탈퇴 후 30일 동안 브루버즈에 다시 가입할 수 없어요.', '30일', TextStyles.title01SemiBold),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAgreeSignOut = !_isAgreeSignOut;
                  });
                },
                child: _isAgreeSignOut
                    ? SvgPicture.asset(
                        'assets/icons/check_red_filled.svg',
                        width: 18,
                        height: 18,
                      )
                    : Container(
                        width: 18,
                        height: 18,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorStyles.gray50)),
                      ),
              ),
              const SizedBox(width: 8),
              const Text('안내 사항을 확인하였으며, 이에 동의합니다.', style: TextStyles.labelMediumMedium),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              setState(() {
                _index = 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                color: _isAgreeSignOut ? ColorStyles.black : ColorStyles.gray20,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '다음',
                style: TextStyles.labelMediumMedium.copyWith(
                  color: _isAgreeSignOut ? ColorStyles.white : ColorStyles.gray40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReasonSelection() {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 46),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('탈퇴하시려는 이유를 선택해 주세요.', style: TextStyles.title04SemiBold),
          const SizedBox(height: 48),
          ...List.generate(_reason.length, (index) {
            final isSelected = index == _selectedReasonIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedReasonIndex = null;
                  } else {
                    _selectedReasonIndex = index;
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    isSelected
                        ? SvgPicture.asset(
                            'assets/icons/check_red_filled.svg',
                            width: 18,
                            height: 18,
                          )
                        : Container(
                            width: 18,
                            height: 18,
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorStyles.gray50)),
                          ),
                    const SizedBox(width: 8),
                    Text(_reason[index], style: TextStyles.labelMediumMedium),
                  ],
                ),
              ),
            );
          }).separator(separatorWidget: const SizedBox(height: 20)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Text(
              '브루버즈와 다시 함께할래요',
              style: TextStyles.captionMediumMedium.copyWith(
                decoration: TextDecoration.underline,
                color: ColorStyles.gray60,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () async {
              final context = this.context;
              final result = await  _showSignOutDialog().then((value) => value ?? false).onError((_, __) => false);
              if (result) {
                final signOutResult = await _api.signOut().then((_) => true).onError((_, __) => false);
                if (signOutResult && context.mounted) {
                  await AccountRepository.instance.logout();
                  await NotificationRepository.instance.deleteToken();
                  if (context.mounted) {
                    context.go('/');
                  }
                } else {
                  showSnackBar(message: '회원탈퇴에 실패했습니다.');
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                color: _isSelectedReason ? ColorStyles.black : ColorStyles.gray20,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '회원 탈퇴하기',
                style: TextStyles.labelMediumMedium.copyWith(
                  color: _isSelectedReason ? ColorStyles.white : ColorStyles.gray40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> _showSignOutDialog() {
    return showCenterDialog(
      title: '정말 탈퇴 하시겠어요?',
      centerTitle: true,
      cancelText: '취소',
      doneText: '탈퇴하기',
    );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord.isEmpty) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);

      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: textStyle));

      spanBoundary = endIndex;
    } while (spanBoundary < text.length);

    return spans;
  }
}
