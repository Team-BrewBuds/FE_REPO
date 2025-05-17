import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/setting/presenter/account_info_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final String tooltipMessage =
      '수집된 개인 정보(성별, 태어난 연도)는 제 3자로부터 제공받은 정보가 아닌, 회원가입 과정에서 회원님의 개인정보 수집 동의를 받고 수집한 정보입니다. 자세한 내용은 개인정보 처리방침에서 확인해 주세요.';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AccountInfoPresenter>().initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Selector<AccountInfoPresenter, String>(
                selector: (context, presenter) => presenter.signUpInfo,
                builder: (context, signUpInfo, child) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
                  child: createdAtWidget(createdAt: signUpInfo),
                ),
              ),
              Selector<AccountInfoPresenter, String>(
                selector: (context, presenter) => presenter.loginKind,
                builder: (context, loginKind, child) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
                  child: loginKindWidget(kind: loginKind),
                ),
              ),
              Selector<AccountInfoPresenter, String>(
                selector: (context, presenter) => presenter.gender,
                builder: (context, gender, child) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
                  child: genderWidget(gender: gender),
                ),
              ),
              Selector<AccountInfoPresenter, String>(
                selector: (context, presenter) => presenter.yearOfBirth,
                builder: (context, yearOfBirth, child) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
                  child: yearOfBirthWidget(yearOfBirth: yearOfBirth),
                ),
              ),
              Selector<AccountInfoPresenter, String>(
                selector: (context, presenter) => presenter.email,
                builder: (context, email, child) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: emailWidget(email: email),
                ),
              ),
            ],
          ),
        ),
        if (context.select<AccountInfoPresenter, bool>(
          (presenter) => presenter.isLoading,
        ))
          const Positioned.fill(child: LoadingBarrier()),
      ],
    );
  }

  AppBar _buildAppBar() {
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
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Text('계정 정보', style: TextStyles.title02Bold),
            const Spacer(),
            const SizedBox(
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget createdAtWidget({required String createdAt}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('가입일', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60)),
        const SizedBox(width: 8),
        Text(createdAt, style: TextStyles.labelMediumMedium),
      ],
    );
  }

  Widget loginKindWidget({required String kind}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('로그인 유형', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60)),
        const SizedBox(width: 8),
        Text(kind, style: TextStyles.labelMediumMedium),
      ],
    );
  }

  Widget genderWidget({required String gender}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('성별', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60)),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltipMessage,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 16.8 / 14,
                letterSpacing: -0.01,
                color: ColorStyles.white,
              ),
              triggerMode: TooltipTriggerMode.tap,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              verticalOffset: 8,
              showDuration: const Duration(seconds: 3),
              child: SvgPicture.asset('assets/icons/information.svg', width: 16, height: 16),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(width: 8),
        Text(gender, style: TextStyles.labelMediumMedium),
      ],
    );
  }

  Widget yearOfBirthWidget({required String yearOfBirth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('태어난 연도', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60)),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltipMessage,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                height: 16.8 / 14,
                letterSpacing: -0.01,
                color: ColorStyles.white,
              ),
              triggerMode: TooltipTriggerMode.tap,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              verticalOffset: 8,
              showDuration: const Duration(seconds: 3),
              child: SvgPicture.asset('assets/icons/information.svg', width: 16, height: 16),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(width: 8),
        Text(yearOfBirth, style: TextStyles.labelMediumMedium),
      ],
    );
  }

  Widget emailWidget({required String email}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('이메일', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60)),
        const SizedBox(width: 8),
        Text(email.isNotEmpty ? email : 'Unknown', style: TextStyles.labelMediumMedium),
      ],
    );
  }
}
