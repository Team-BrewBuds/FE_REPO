import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/profile/view/profile_mixin.dart';
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
  AppBar buildTitle() {
    final nickName = context.read<ProfilePresenter>().nickname;
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(nickName, style: TextStyles.title02Bold),
            const Spacer(),
            InkWell(
              onTap: () {
                context.push('/profile_setting');
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
  Widget buildProfileBottomButtons(ProfilePresenter presenter) {
    return Row(
      children: [
        ButtonFactory.buildRoundedButton(
          onTapped: () {},
          text: '취향 리포트 보기',
          style: RoundedButtonStyle.fill(
            size: RoundedButtonSize.medium,
            color: ColorStyles.black,
            textColor: ColorStyles.white,
          ),
        ),
        const SizedBox(width: 8),
        ButtonFactory.buildRoundedButton(
          onTapped: () {},
          text: '프로필 편집',
          style: RoundedButtonStyle.fill(
            size: RoundedButtonSize.medium,
            color: ColorStyles.gray30,
            textColor: ColorStyles.black,
          ),
        ),
      ],
    );
  }

  @override
  pushFollowList(ProfilePresenter presenter, int index) {
    pushToFollowListPA(context: context, id: presenter.id, nickName: presenter.nickname, initialIndex: index);
  }

  @override
  onTappedSettingDetailButton(ProfilePresenter presenter) {
    // TODO: implement onTappedSettingDetailButton
    throw UnimplementedError();
  }
}
