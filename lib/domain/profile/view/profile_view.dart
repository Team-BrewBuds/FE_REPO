import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/profile/presenter/modal_profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/profile_mixin.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with ProfileMixin<ProfileView, ModalProfilePresenter>, CenterDialogMixin<ProfileView> {
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
    return Selector<ModalProfilePresenter, bool>(
      selector: (context, presenter) => presenter.isError,
      builder: (context, isError, child) {
        if (isError) {
          showEmptyDialog();
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
              final canShowTastingReport = context.select<ModalProfilePresenter, bool>(
                (presenter) => presenter.canShowTastingReport,
              );
              return AbsorbPointer(
                absorbing: !canShowTastingReport,
                child: FutureButton(
                  onTap: () {
                    final id = context.read<ModalProfilePresenter>().id;
                    final nickname = context.read<ModalProfilePresenter>().nickName;
                    return ScreenNavigator.pushToTasteReport(context: context, id: id, nickname: nickname);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                      color: canShowTastingReport ? ColorStyles.black : ColorStyles.gray20,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      '취향 리포트 보기',
                      style: TextStyles.labelSmallMedium.copyWith(
                        color: canShowTastingReport ? ColorStyles.white : ColorStyles.gray50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Builder(
              builder: (context) {
                final isMine = context.select<ModalProfilePresenter, bool>((presenter) => presenter.isMine);
                if (isMine) {
                  return FutureButton(
                    onTap: () {
                      final nickname = context.read<ModalProfilePresenter>().nickName;
                      final introduction = context.read<ModalProfilePresenter>().profile?.introduction ?? '';
                      final profileLink = context.read<ModalProfilePresenter>().profile?.profileLink ?? '';
                      final profileImageURI = context.read<ModalProfilePresenter>().profile?.profileImageUrl ?? '';
                      final coffeeLife = context.read<ModalProfilePresenter>().profile?.coffeeLife ?? [];

                      return ScreenNavigator.showProfileEditScreen(
                        context: context,
                        selectedCoffeeLifeList: coffeeLife,
                        imageUrl: profileImageURI,
                        nickname: nickname,
                        introduction: introduction,
                        link: profileLink,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      decoration: const BoxDecoration(
                        color: ColorStyles.gray30,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        '프로필 편집',
                        style: TextStyles.labelSmallMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return FutureButton(
                  onTap: () => context.read<ModalProfilePresenter>().onTappedFollowButton(),
                  child: Selector<ModalProfilePresenter, bool>(
                    selector: (context, presenter) => presenter.isFollow,
                    builder: (context, isFollow, child) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isFollow ? ColorStyles.gray30 : ColorStyles.red,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(
                        isFollow ? '팔로잉' : '팔로우',
                        style: TextStyles.labelSmallMedium.copyWith(
                          color: isFollow ? ColorStyles.black : ColorStyles.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
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
            Selector<ModalProfilePresenter, String>(
              selector: (context, presenter) => presenter.nickName,
              builder: (context, nickName, child) => Text(nickName, style: TextStyles.title02Bold),
            ),
            const Spacer(),
            Builder(builder: (context) {
              final isVisible = context.select<ModalProfilePresenter, bool>((presenter) => !presenter.isMine);
              return Visibility(
                visible: isVisible,
                child: ThrottleButton(
                  onTap: () async {
                    final context = this.context;
                    final nickname = context.read<ModalProfilePresenter>().nickName;
                    final bottomSheetResult = await _showBlockBottomSheet();
                    if (bottomSheetResult != null && bottomSheetResult && context.mounted) {
                      await showCenterDialog(
                        title: '이 사용자를 차단하시겠어요?',
                        centerTitle: true,
                        content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
                        cancelText: '취소',
                        doneText: '차단하기',
                        onDone: () async {
                          try {
                            await context.read<ModalProfilePresenter>().onTappedBlockButton();
                            if (context.mounted) {
                              EventBus.instance.fire(MessageEvent(message: '$nickname님을 차단했어요.'));
                              context.pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              EventBus.instance.fire(const MessageEvent(message: '차단에 실패했어요.'));
                            }
                          }
                        },
                      );
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons/more.svg',
                    fit: BoxFit.cover,
                    height: 24,
                    width: 24,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> pushFollowList(int index) {
    final profile = context.read<ModalProfilePresenter>().profile;
    if (profile != null) {
      return ScreenNavigator.pushToFollowListPB(
        context: context,
        id: profile.id,
        nickName: profile.nickname,
        initialIndex: index,
      );
    } else {
      return Future.error(Error);
    }
  }

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
                              '차단하기',
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

  Future<void> showEmptyDialog() async {
    final context = this.context;
    await showBarrierDialog(
      context: context,
      barrierColor: ColorStyles.black90,
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
    if (context.mounted) {
      context.pop();
    }
  }
}
