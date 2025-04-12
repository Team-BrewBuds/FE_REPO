import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/profile/presenter/other_profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/profile_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OtherProfileView extends StatefulWidget {
  const OtherProfileView({super.key});

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView>
    with ProfileMixin<OtherProfileView, OtherProfilePresenter>, CenterDialogMixin<OtherProfileView> {
  @override
  String get beansEmptyText => '찜한 원두가 없습니다.';

  @override
  String get postsEmptyText => '작성한 게시글이 없습니다.';

  @override
  String get savedNotesEmptyText => '저장한 노트가 없습니다.';

  @override
  String get tastingRecordsEmptyText => '작성한 시음기록이 없습니다.';

  @override
  Widget build(BuildContext context) {
    return Selector<OtherProfilePresenter, bool>(
      selector: (context, presenter) => presenter.isEmpty,
      builder: (context, isEmpty, child) {
        if (isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showEmptyDialog().then((value) => context.pop());
          });
        }
        return super.build(context);
      },
    );
  }

  @override
  Widget buildProfileBottomButtons() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: Builder(builder: (context) {
              final canShowTastingReport = context.select<OtherProfilePresenter, bool>(
                (presenter) => presenter.canShowTastingReport,
              );
              return AbsorbPointer(
                absorbing: !canShowTastingReport,
                child: ThrottleButton(
                  onTap: () {
                    final id = context.read<OtherProfilePresenter>().id;
                    final nickname = context.read<OtherProfilePresenter>().nickName;
                    pushToTasteReport(context: context, id: id, nickname: nickname);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                      color: canShowTastingReport ? ColorStyles.black : ColorStyles.gray20,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      '취향 리포트 보기',
                      style: TextStyles.labelSmallMedium
                          .copyWith(color: canShowTastingReport ? ColorStyles.white : ColorStyles.gray50),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ThrottleButton(
              onTap: () {
                context.read<OtherProfilePresenter>().onTappedFollowButton();
              },
              child: Selector<OtherProfilePresenter, bool>(
                selector: (context, presenter) => presenter.isFollow,
                builder: (context, isFollow, child) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isFollow ? ColorStyles.gray30 : ColorStyles.red,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    isFollow ? '팔로잉' : '팔로우',
                    style:
                        TextStyles.labelSmallMedium.copyWith(color: isFollow ? ColorStyles.black : ColorStyles.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AppBar buildTitle() {
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
                'assets/icons/x.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Selector<OtherProfilePresenter, String>(
              selector: (context, presenter) => presenter.nickName,
              builder: (context, nickName, child) => Text(nickName, style: TextStyles.title02Bold),
            ),
            const Spacer(),
            ThrottleButton(
              onTap: () {
                _showBlockBottomSheet().then((value) {
                  if (value != null && value) {
                    _showAskForResponseToBlockModal().then((value) {
                      if (value != null && value) {
                        context.pop('차단을 완료했어요.');
                      } else {
                        showSnackBar(message: '차단을 실패했어요.');
                      }
                    });
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/icons/more.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  pushFollowList(int index) {
    final profile = context.read<OtherProfilePresenter>().profile;
    if (profile != null) {
      pushToFollowListPB(context: context, id: profile.id, nickName: profile.nickname, initialIndex: index);
    }
  }

  @override
  onTappedSettingDetailButton() {}

  Future<bool?> _showBlockBottomSheet() {
    return showBarrierDialog<bool>(
      context: context,
      pageBuilder: (context, __, ___) {
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
                              '차단 하기',
                              style: TextStyles.title02SemiBold,
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

  Future<bool?> _showAskForResponseToBlockModal() {
    return showCenterDialog(
      title: '이 사용자를 차단하시겠어요?',
      centerTitle: true,
      content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
      cancelText: '취소',
      doneText: '차단하기',
    ).then((result) {
      if (result != null && result) {
        return context.read<OtherProfilePresenter>().onTappedBlockButton();
      } else {
        return null;
      }
    });
  }

  Future<void> showEmptyDialog() {
    return showBarrierDialog(
      context: context,
      barrierColor: ColorStyles.black.withOpacity(0.95),
      pageBuilder: (context, _, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '유저 정보를 불러올 수 없습니다.',
                          style: TextStyles.title02SemiBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.gray30,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '닫기',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
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
                            ),
                          ],
                        ),
                      ],
                    ),
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
