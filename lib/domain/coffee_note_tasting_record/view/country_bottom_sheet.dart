import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/model/coffee_bean/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CountryBottomSheet extends StatelessWidget {
  final ValueNotifier<List<String>> selectedCountry;
  final bool isSingleOrigin;

  CountryBottomSheet({
    super.key,
    required List<String> initialCountry,
    required this.isSingleOrigin,
  })  : selectedCountry = ValueNotifier(initialCountry);

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
              height: MediaQuery.of(context).size.height - 200,
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
                          valueListenable: selectedCountry,
                          builder: (context, selectedCountry, child) => _buildCountry(selectedCountry),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: selectedCountry,
                      builder: (context, selectedCountry, child) {
                        return selectedCountry.isNotEmpty
                            ? _buildSelectedCountryList(selectedCountry)
                            : const SizedBox.shrink();
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
          Text('생산국가', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
          const Spacer(),
          ThrottleButton(
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

  Widget _buildCountry(List<String> selectedCountry) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: Continent.values
            .map(
              (continent) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(continent.toString(), style: TextStyles.title02SemiBold),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: continent.countries().map(
                      (country) {
                        final isSelectedCountry = selectedCountry.contains(country.toString());
                        return ThrottleButton(
                          onTap: () {
                            if (isSingleOrigin) {
                              if (isSelectedCountry) {
                                this.selectedCountry.value = [];
                              } else {
                                this.selectedCountry.value = List.from([country.toString()]);
                              }
                            } else {
                              if (isSelectedCountry) {
                                this.selectedCountry.value = List.from(this.selectedCountry.value)
                                  ..remove(country.toString());
                              } else {
                                this.selectedCountry.value = List.from(this.selectedCountry.value)
                                  ..add(country.toString());
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelectedCountry ? ColorStyles.background : Colors.transparent,
                              border: Border.all(color: isSelectedCountry ? ColorStyles.red : ColorStyles.gray50),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              country.toString(),
                              style: TextStyles.captionMediumRegular.copyWith(
                                color: isSelectedCountry ? ColorStyles.red : ColorStyles.black,
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

  Widget _buildSelectedCountryList(List<String> selectedCountry) {
    return Container(
      color: ColorStyles.gray20,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 4,
          children: selectedCountry
              .map(
                (country) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: ColorStyles.black,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        country,
                        style: TextStyles.labelSmallSemiBold.copyWith(
                          color: ColorStyles.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 4),
                      ThrottleButton(
                        onTap: () {
                          this.selectedCountry.value = List.from(this.selectedCountry.value)
                            ..remove(country.toString());
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
            child: ThrottleButton(
              onTap: () {
                selectedCountry.value = List.from([]);
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
            child: ThrottleButton(
              onTap: () {
                context.pop(selectedCountry.value);
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
}
