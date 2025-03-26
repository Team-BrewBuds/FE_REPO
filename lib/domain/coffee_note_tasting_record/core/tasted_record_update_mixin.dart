import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_presenter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin TastedRecordUpdateMixin<T extends StatefulWidget> on State<T> {
  int get currentStep;

  int get minStep => 1;

  int get maxStep => 2;

  String get title {
    if (currentStep == 1) {
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
                '시음 기록 수정',
                style: TextStyles.title02SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  showCancelDialog().then((value) {
                    if (value != null && value) {
                      context.pop(false);
                    }
                  });
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
        Selector<TastedRecordUpdatePresenter, List<String>>(
          selector: (context, presenter) => presenter.images,
          builder: (context, images, child) {
            return Container(
              width: 80,
              height: 80,
              color: ColorStyles.gray50,
              child: images.isNotEmpty
                  ? Stack(
                      children: [
                        Positioned.fill(
                            child: MyNetworkImage(
                          imageUrl: images.first,
                          height: 80,
                          width: 80,
                        )),
                        if (images.length > 1)
                          Positioned(
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

  Future<bool?> showCancelDialog() {
    return showBarrierDialog<bool>(
      context: context,
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
                        const Text(
                          '시음기록 수정을 그만두시겠습니까?',
                          style: TextStyles.title02SemiBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '지금까지 작성한 내용은 저장되지 않아요.',
                          style: TextStyles.bodyNarrowRegular,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
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
                              child: GestureDetector(
                                onTap: () {
                                  context.pop(true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.black,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '나가기',
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
