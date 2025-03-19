import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/signup/provider/sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

mixin SignupMixin<T extends StatefulWidget> on State<T> {
  void Function() get onSkip;

  void Function() get onNext;

  int get currentPageIndex;

  bool get isSkippablePage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: buildAppbar(),
        body: SafeArea(
          child: Selector<SignUpPresenter, bool>(
              selector: (context, presenter) => presenter.isLoading,
              builder: (context, isLoading, child) {
                return AbsorbPointer(
                  absorbing: isLoading,
                  child: Stack(
                    children: [
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator(color: ColorStyles.gray60)
                            : const SizedBox.shrink(),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = (constraints.maxWidth - 6) / 4;
                                  return Row(
                                    children: List<Widget>.generate(
                                      4,
                                      (index) => Container(
                                        height: 2,
                                        width: width,
                                        color: index <= currentPageIndex ? ColorStyles.red : ColorStyles.gray40,
                                      ),
                                    ).separator(separatorWidget: const SizedBox(width: 2)).toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 28),
                              Expanded(child: buildBody()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
        bottomNavigationBar: buildBottom(),
      ),
    );
  }

  Widget buildBody();

  Widget buildBottom();

  AppBar buildAppbar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      toolbarOpacity: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
        height: 64,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset('assets/icons/back.svg', width: 24, height: 24, fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Text(
                '회원가입',
                style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: onSkip,
                child: isSkippablePage
                    ? Text(
                        '건너뛰기',
                        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.gray50),
                      )
                    : const SizedBox(width: 24, height: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomButton({required bool isSatisfyRequirements, String title = '다음'}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 46.0, left: 16, right: 16),
      child: AbsorbPointer(
        absorbing: !isSatisfyRequirements,
        child: InkWell(
          onTap: onNext,
          child: Container(
            height: 47,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSatisfyRequirements ? ColorStyles.black : ColorStyles.gray30,
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyles.labelMediumMedium.copyWith(
                  color: isSatisfyRequirements ? ColorStyles.white : ColorStyles.gray40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
