import 'dart:typed_data';

import 'package:brew_buds/coffee_note_tasting_record/tasting_write_presenter.dart';
import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin TastingWriteMixin<T extends StatefulWidget> on State<T> {
  int get currentStep;

  int get minStep => 1;

  int get maxStep => 3;

  String get title {
    if (currentStep == 1) {
      return '원두 정보를 알려주세요.';
    } else if (currentStep == 2) {
      return '원두의 맛은 어떤가요?';
    } else {
      return '원두가 취향에 맞나요?';
    }
  }

  Widget buildBody();

  Widget buildBottomButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              buildStepBar(),
              Expanded(child: buildBody()),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: buildBottomButton(),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                '시음 기록',
                style: TextStyles.title02SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/x.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepBar() {
    if (currentStep < minStep && currentStep > maxStep) return const SizedBox.shrink();

    return Row(
      children: List<Widget>.generate(
        maxStep,
        (index) => Expanded(
          child: Container(height: 2, color: index < currentStep ? ColorStyles.red : ColorStyles.gray40),
        ),
      ).separator(separatorWidget: const SizedBox(width: 2)).toList(),
    );
  }

  Widget buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(title, style: TextStyles.title04SemiBold)),
        const SizedBox(width: 40),
        Selector<TastingWritePresenter, List<Uint8List>>(
          selector: (context, presenter) => presenter.imageData,
          builder: (context, imageData, child) {
            final thumbnail = imageData.firstOrNull;
            return Container(
              width: 80,
              height: 80,
              color: ColorStyles.gray50,
              child: thumbnail != null
                  ? Stack(
                      children: [
                        Positioned.fill(child: ExtendedImage.memory(thumbnail, fit: BoxFit.cover)),
                        if(imageData.length > 1) Positioned(
                          right: 6,
                          bottom: 6,
                          child: SvgPicture.asset('assets/icons/files.svg', width: 14, height: 14),
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
