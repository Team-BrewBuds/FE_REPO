import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum TasteKind {
  impression,
  body,
  acidity,
  acerbity,
  sweetness;

  @override
  String toString() {
    switch (this) {
      case TasteKind.impression:
        return '맛의 인상';
      case TasteKind.body:
        return '바디감';
      case TasteKind.acidity:
        return '산미';
      case TasteKind.acerbity:
        return '쓴맛';
      case TasteKind.sweetness:
        return '단맛';
    }
  }

  List<String> valuesToStringList() {
    switch (this) {
      case TasteKind.impression:
        return ['깔끔한', '부드러움', '여운 있는', '크리미한', '풍부한', '화사한'];
      case TasteKind.body:
        return ['가벼운', '무거운', '밸런스'];
      case TasteKind.acidity:
        return ['꽃', '베리', '산미 있는', '시트러스', '주스', '차', '트로피칼', '향신료', '허브'];
      case TasteKind.acerbity:
        return ['견과류', '고소한', '곡물', '스모키한', '시나몬', '쌉쌀한'];
      case TasteKind.sweetness:
        return ['달콤한', '바닐라', '초콜릿', '카라멜'];
    }
  }
}

class TasteBottomSheet extends StatelessWidget {
  final ValueNotifier<List<String>> tasteListNotifier;

  TasteBottomSheet({
    super.key,
    required List<String> tasteList,
  }) : tasteListNotifier = ValueNotifier(tasteList);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height - 75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder(
                          valueListenable: tasteListNotifier,
                          builder: (context, tasteList, child) => _buildTaste(context, tasteList),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: tasteListNotifier,
                      builder: (context, tasteList, child) {
                        return tasteList.isNotEmpty ? _buildSelectedTasteList(tasteList) : const SizedBox.shrink();
                      },
                    ),
                    _buildBottomButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 24, left: 16, right: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: Row(
        children: [
          const SizedBox(width: 24),
          const Spacer(),
          Text('원두에서 어떤 맛이 느껴지시나요?', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset(
              'assets/icons/x.svg',
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaste(BuildContext context, List<String> selectedTaste) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: TasteKind.values
            .map(
              (kind) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(kind.toString(), style: TextStyles.title02SemiBold),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kind.valuesToStringList().map(
                      (valueString) {
                        final isSelected = selectedTaste.contains(valueString);
                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              tasteListNotifier.value = List.from(tasteListNotifier.value)..remove(valueString);
                            } else {
                              if (selectedTaste.length < 4) {
                                tasteListNotifier.value = List.from(tasteListNotifier.value)..add(valueString);
                              } else {
                                showLimitErrorSnackBar(context);
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? ColorStyles.background : Colors.transparent,
                              border: Border.all(color: isSelected ? ColorStyles.red : ColorStyles.gray50),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              valueString,
                              style: TextStyles.captionMediumRegular.copyWith(
                                color: isSelected ? ColorStyles.red : ColorStyles.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSelectedTasteList(List<String> selectedTaste) {
    return Container(
      color: ColorStyles.gray20,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 4,
          children: selectedTaste
              .map(
                (taste) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: ColorStyles.black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        taste,
                        style: TextStyles.labelSmallSemiBold.copyWith(
                          color: ColorStyles.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          tasteListNotifier.value = List.from(tasteListNotifier.value)..remove(taste);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/x.svg',
                          width: 14,
                          height: 14,
                          colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom + 24, top: 24),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE7E7E7)))),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                tasteListNotifier.value = tasteListNotifier.value..clear();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorStyles.gray30,
                ),
                child: Text('초기화', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                context.pop(tasteListNotifier.value);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorStyles.black,
                ),
                child: Text(
                  '선택하기',
                  style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showLimitErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(color: ColorStyles.black, borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Center(
            child: Text(
              '맛은 최대 4개만 선택할 수 있습니다.',
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
