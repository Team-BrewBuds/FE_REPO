import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../provider/coffee_note_presenter.dart';

mixin TasingRecordMixin <T extends StatefulWidget> on State<T> {
  void Function() get onSkip;

  void Function() get onNext;

  int get currentPageIndex;

  bool get isSkippablePage;

  bool get isSatisfyRequirements;

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeNotePresenter>(builder: (context, presenter, _) {
      return Scaffold(
        appBar: buildAppbar(context, presenter),
        body: AbsorbPointer(
          absorbing: presenter.isLoading,
          child: Stack(
            children: [
              Center(
                child: presenter.isLoading ? const CircularProgressIndicator(color: ColorStyles.gray60) : Container(),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = (constraints.maxWidth - 6) / 3;
                          return Row(
                            children: List<Widget>.generate(
                              3,
                                  (index) => Container(
                                height: 2,
                                width: width,
                                color: index <= currentPageIndex ? ColorStyles.red: ColorStyles.gray40,
                              ),
                            ).separator(separatorWidget: const SizedBox(width: 2)).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Expanded(child: buildBody(context, presenter)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: buildBottom(context, presenter),
      );
    });
  }

  Widget buildBody(BuildContext context, CoffeeNotePresenter presenter);

  AppBar buildAppbar(BuildContext context, CoffeeNotePresenter presenter) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      leading: Container(),
      leadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/x.svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                '시음기록',
                style: TextStyles.title02SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottom(BuildContext context, CoffeeNotePresenter presenter) {
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
                '다음',
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
