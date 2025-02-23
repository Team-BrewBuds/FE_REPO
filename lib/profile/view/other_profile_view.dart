import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/profile/presenter/other_profile_presenter.dart';
import 'package:brew_buds/profile/view/profile_mixin.dart';
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
    with ProfileMixin<OtherProfileView, OtherProfilePresenter> {
  @override
  String get beansEmptyText => '찜한 원두가 없습니다.';

  @override
  String get postsEmptyText => '작성한 게시글이 없습니다.';

  @override
  String get savedNotesEmptyText => '저장한 노트가 없습니다.';

  @override
  String get tastingRecordsEmptyText => '작성한 시음기록이 없습니다.';

  @override
  Widget buildProfileBottomButtons() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          ButtonFactory.buildRoundedButton(
            onTapped: () {
              pushToTasteReport(context: context);
            },
            text: '취향 리포트 보기',
            style: RoundedButtonStyle.fill(
              size: RoundedButtonSize.medium,
              color: ColorStyles.black,
              textColor: ColorStyles.white,
            ),
          ),
          const SizedBox(width: 8),
          Selector<OtherProfilePresenter, bool>(
            selector: (context, presenter) => presenter.isFollow,
            builder: (context, isFollow, child) => ButtonFactory.buildRoundedButton(
              onTapped: () {},
              text: isFollow ? '팔로잉' : '팔로우',
              style: RoundedButtonStyle.fill(
                size: RoundedButtonSize.medium,
                color: isFollow ? ColorStyles.gray30 : ColorStyles.red,
                textColor: isFollow ? ColorStyles.black : ColorStyles.white,
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
            Selector<OtherProfilePresenter, String>(
              selector: (context, presenter) => presenter.nickName,
              builder: (context, nickName, child) => Text(nickName, style: TextStyles.title02Bold),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                _showBlockBottomSheet();
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

  Future<void> onTappedBlock() async {
    final result = await context.read<OtherProfilePresenter>().onTappedBlockButton();
    if (result) {
      context.pop();
      context.pop();
    }
  }

  _showBlockBottomSheet() {
    showBarrierDialog(
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
                      InkWell(
                        onTap: () {
                          context.pop();
                          _showAskForResponseToBlockModal();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
                          child: const Center(
                            child: Text(
                              '차단 하기',
                              style: TextStyles.title02SemiBold,
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

  _showAskForResponseToBlockModal() {
    showBarrierDialog(
      context: context,
      pageBuilder: (context, __, ___) {
        return Stack(
          children: [
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: Text('정말 차단하시겠어요?', style: TextStyles.title02SemiBold),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: ColorStyles.gray30,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(child: Text('취소', style: TextStyles.labelMediumMedium)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await onTappedBlock.call();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: ColorStyles.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '차단하기',
                                      style: TextStyles.labelMediumMedium.copyWith(
                                        color: ColorStyles.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
