import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/domain/profile/view/profile_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

typedef EditProfileData = ({
  String nickname,
  String introduction,
  String link,
  String imageUrl,
  List<CoffeeLife> coffeeLife,
});

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
            InkWell(
              onTap: () {
                context.push('/profile/setting');
              },
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
          ButtonFactory.buildRoundedButton(
            onTapped: () {
              final id = context.read<ProfilePresenter>().id;
              final nickname = context.read<ProfilePresenter>().nickName;
              pushToTasteReport(context: context, id: id, nickname: nickname);
            },
            text: '취향 리포트 보기',
            style: RoundedButtonStyle.fill(
              size: RoundedButtonSize.medium,
              color: ColorStyles.black,
              textColor: ColorStyles.white,
            ),
          ),
          const SizedBox(width: 8),
          ButtonFactory.buildRoundedButton(
            onTapped: () {
              final nickname = context.read<ProfilePresenter>().nickName;
              final introduction = context.read<ProfilePresenter>().profile?.introduction ?? '';
              final profileLink = context.read<ProfilePresenter>().profile?.profileLink ?? '';
              final profileImageURI = context.read<ProfilePresenter>().profile?.profileImageUrl ?? '';
              final coffeeLife = context.read<ProfilePresenter>().profile?.coffeeLife ?? [];
              final EditProfileData data = (
                nickname: nickname,
                introduction: introduction,
                link: profileLink,
                imageUrl: profileImageURI,
                coffeeLife: coffeeLife,
              );
              context.push('/profile/edit', extra: data).then(
                    (_) => context.read<ProfilePresenter>().refresh(),
                  );
            },
            text: '프로필 편집',
            style: RoundedButtonStyle.fill(
              size: RoundedButtonSize.medium,
              color: ColorStyles.gray30,
              textColor: ColorStyles.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  pushFollowList(int index) {
    final profile = context.read<ProfilePresenter>().profile;
    if (profile != null) {
      pushToFollowListPA(context: context, id: profile.id, nickName: profile.nickname, initialIndex: index);
    }
  }

  @override
  onTappedSettingDetailButton() {}
}
