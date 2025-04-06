import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/core/tasting_write_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasting_write_last_screen.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasting_write_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/taste_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastingWriteSecondScreen extends StatefulWidget {
  const TastingWriteSecondScreen({super.key});

  @override
  State<TastingWriteSecondScreen> createState() => _TastingWriteSecondScreenState();
}

class _TastingWriteSecondScreenState extends State<TastingWriteSecondScreen>
    with TastingWriteMixin<TastingWriteSecondScreen> {
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
      context.read<TastingWritePresenter>().secondPageInitState();
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
          Selector<TastingWritePresenter, List<String>>(
            selector: (context, presenter) => presenter.taste,
            builder: (context, tasteList, child) => _buildTaste(tasteList: tasteList),
          ),
          const SizedBox(height: 16),
          Selector<TastingWritePresenter, int>(
            selector: (context, presenter) => presenter.bodyValue,
            builder: (context, value, child) => _buildBodyFeeling(body: value),
          ),
          const SizedBox(height: 16),
          Selector<TastingWritePresenter, int>(
            selector: (context, presenter) => presenter.acidityValue,
            builder: (context, value, child) => _buildAcidity(acidity: value),
          ),
          const SizedBox(height: 16),
          Selector<TastingWritePresenter, int>(
            selector: (context, presenter) => presenter.bitternessValue,
            builder: (context, value, child) => _buildBitterness(bitterness: value),
          ),
          const SizedBox(height: 16),
          Selector<TastingWritePresenter, int>(
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
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 46),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorStyles.gray30,
                ),
                child: const Text('뒤로', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Selector<TastingWritePresenter, bool>(
              selector: (context, presenter) => presenter.isValidSecondPage,
              builder: (context, isValidSecondPage, child) {
                return AbsorbPointer(
                  absorbing: !isValidSecondPage,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TastingWriteLastScreen(),
                        ),
                      );
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
        const Text('맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        GestureDetector(
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
                        children: tasteList
                            .map(
                              (taste) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                    color: ColorStyles.black, borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  taste,
                                  style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .separator(separatorWidget: const SizedBox(width: 4))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      context.read<TastingWritePresenter>().onChangeTaste([]);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('바디감', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<TastingWritePresenter>().onChangeBodyValue(value);
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
                          const SizedBox(height: 6),
                          Text(
                            _body[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: body == value
                                  ? ColorStyles.red
                                  : body == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('산미', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<TastingWritePresenter>().onChangeAcidityValue(value);
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
                          const SizedBox(height: 6),
                          Text(
                            _acidity[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: acidity == value
                                  ? ColorStyles.red
                                  : acidity == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('쓴맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<TastingWritePresenter>().onChangeBitternessValue(value);
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
                          const SizedBox(height: 6),
                          Text(
                            _bitterness[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: bitterness == value
                                  ? ColorStyles.red
                                  : bitterness == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
                      );
                    },
                  ).separator(separatorWidget: const Spacer()).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSweet({required int sweetness}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('단맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<TastingWritePresenter>().onChangeSweetnessValue(value);
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
                          const SizedBox(height: 6),
                          Text(
                            _sweet[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: sweetness == value
                                  ? ColorStyles.red
                                  : sweetness == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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
    context.read<TastingWritePresenter>().onChangeTaste(taste);
  }
}
