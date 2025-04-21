import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/core/tasted_record_write_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/taste_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastedRecordWriteSecondScreen extends StatefulWidget {
  const TastedRecordWriteSecondScreen({super.key});

  @override
  State<TastedRecordWriteSecondScreen> createState() => _TastedRecordWriteSecondScreenState();
}

class _TastedRecordWriteSecondScreenState extends State<TastedRecordWriteSecondScreen>
    with TastedRecordWriteMixin<TastedRecordWriteSecondScreen> {
  final List<String> _body = ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'];
  final List<String> _acidity = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _bitterness = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _sweet = ['약한', '약간 약한', '보통', '약간 강한', '강한'];

  @override
  int get currentStep => 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TastedRecordWritePresenter>().secondPageInitState();
    });
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          buildTitle(),
          const SizedBox(height: 8),
          Selector<TastedRecordWritePresenter, List<String>>(
            selector: (context, presenter) => presenter.taste,
            builder: (context, tasteList, child) => _buildTaste(tasteList: tasteList),
          ),
          const SizedBox(height: 16),
          Selector<TastedRecordWritePresenter, int>(
            selector: (context, presenter) => presenter.bodyValue,
            builder: (context, value, child) => _buildBodyFeeling(body: value),
          ),
          const SizedBox(height: 16),
          Selector<TastedRecordWritePresenter, int>(
            selector: (context, presenter) => presenter.acidityValue,
            builder: (context, value, child) => _buildAcidity(acidity: value),
          ),
          const SizedBox(height: 16),
          Selector<TastedRecordWritePresenter, int>(
            selector: (context, presenter) => presenter.bitternessValue,
            builder: (context, value, child) => _buildBitterness(bitterness: value),
          ),
          const SizedBox(height: 16),
          Selector<TastedRecordWritePresenter, int>(
            selector: (context, presenter) => presenter.sweetnessValue,
            builder: (context, value, child) => _buildSweet(sweetness: value),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ThrottleButton(
              onTap: () {
                context.read<TastedRecordWriteFlowPresenter>().back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorStyles.gray30,
                ),
                child: Text('뒤로', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Selector<TastedRecordWritePresenter, bool>(
              selector: (context, presenter) => presenter.isValidSecondPage,
              builder: (context, isValidSecondPage, child) {
                return AbsorbPointer(
                  absorbing: !isValidSecondPage,
                  child: ThrottleButton(
                    onTap: () {
                      context.read<TastedRecordWriteFlowPresenter>().goTo(TastedRecordWriteFlow.writeLastStep());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isValidSecondPage ? ColorStyles.black : ColorStyles.gray20,
                      ),
                      child: Text(
                        '다음',
                        style: TextStyles.labelMediumMedium.copyWith(
                          color: isValidSecondPage ? ColorStyles.white : ColorStyles.gray40,
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

  Widget _buildTaste({required List<String> tasteList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        ThrottleButton(
          onTap: () {
            _showTasteBottomSheet(taste: tasteList);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: ColorStyles.gray40)),
            child: Row(
              children: [
                if (tasteList.isNotEmpty) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        spacing: 4,
                        children: tasteList
                            .map(
                              (taste) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                  color: ColorStyles.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  taste,
                                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ThrottleButton(
                    onTap: () {
                      context.read<TastedRecordWritePresenter>().onChangeTaste([]);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/x_round.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '원두의 맛을 입력해보세요. (최대 4개)',
                      style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyFeeling({required int body}) {
    final height = max(52, 52.h).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('바디감', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<TastedRecordWritePresenter>().onChangeBodyValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: body == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: body == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: body == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _body[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: body == value
                                      ? ColorStyles.red
                                      : body == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcidity({required int acidity}) {
    final height = max(52, 52.h).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('산미', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<TastedRecordWritePresenter>().onChangeAcidityValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: acidity == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: acidity == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: acidity == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _acidity[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: acidity == value
                                      ? ColorStyles.red
                                      : acidity == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBitterness({required int bitterness}) {
    final height = max(52, 52.h).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('쓴맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<TastedRecordWritePresenter>().onChangeBitternessValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: bitterness == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: bitterness == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: bitterness == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _bitterness[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: bitterness == value
                                      ? ColorStyles.red
                                      : bitterness == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSweet({required int sweetness}) {
    final height = max(52, 52.h).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('단맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<TastedRecordWritePresenter>().onChangeSweetnessValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: sweetness == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: sweetness == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: sweetness == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _sweet[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: sweetness == value
                                      ? ColorStyles.red
                                      : sweetness == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showTasteBottomSheet({required List<String> taste}) async {
    final result = await showBarrierDialog<List<String>>(
        context: context,
        pageBuilder: (context, _, __) {
          return TasteBottomSheet(tasteList: List.from(taste));
        });

    if (result != null) {
      _onChangeTaste(result);
    }
  }

  _onChangeTaste(List<String> taste) {
    context.read<TastedRecordWritePresenter>().onChangeTaste(taste);
  }
}
