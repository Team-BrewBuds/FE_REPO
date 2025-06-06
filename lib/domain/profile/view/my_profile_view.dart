import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/profile_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> with ProfileMixin<MyProfileView, ProfilePresenter> {
  @override
  String get beansEmptyText => '찜한 원두가 없습니다.';

  @override
  String get postsEmptyText => '첫 게시글을 작성해 보세요.';

  @override
  String get savedNotesEmptyText => '저장한 노트가 없습니다.';

  @override
  String get tastingRecordsEmptyText => '첫 시음기록을 작성해 보세요.';

  @override
  AppBar buildTitle() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Selector<ProfilePresenter, String>(
              selector: (context, presenter) => presenter.nickName,
              builder: (context, nickName, child) => Text(nickName, style: TextStyles.title02Bold),
            ),
            const Spacer(),
            FutureButton(
              onTap: () => context.push('/profile/setting'),
              child: SvgPicture.asset(
                'assets/icons/setting.svg',
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
  Widget buildProfileBottomButtons() {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Expanded(
            child: FutureButton(
              onTap: () {
                final id = context.read<ProfilePresenter>().id;
                final nickname = context.read<ProfilePresenter>().nickName;
                return ScreenNavigator.showTasteReport(context: context, id: id, nickname: nickname);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  color: ColorStyles.black,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  '취향 리포트 보기',
                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FutureButton(
              onTap: () {
                final nickname = context.read<ProfilePresenter>().nickName;
                final introduction = context.read<ProfilePresenter>().profile?.introduction ?? '';
                final profileLink = context.read<ProfilePresenter>().profile?.profileLink ?? '';
                final profileImageUrl = context.read<ProfilePresenter>().profile?.profileImageUrl ?? '';
                final coffeeLife = context.read<ProfilePresenter>().profile?.coffeeLife ?? [];

                return ScreenNavigator.showProfileEditScreen(
                  context: context,
                  selectedCoffeeLifeList: coffeeLife,
                  imageUrl: profileImageUrl,
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> pushFollowList(int index) {
    final profile = context.read<ProfilePresenter>().profile;
    if (profile != null) {
      return ScreenNavigator.showFollowListPA(
        context: context,
        id: profile.id,
        nickName: profile.nickname,
        initialIndex: index,
      );
    } else {
      return Future.error(Error());
    }
  }
}
