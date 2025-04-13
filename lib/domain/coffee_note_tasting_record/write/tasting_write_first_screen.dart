import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/core/tasting_write_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/bean_write_option.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/coffee_bean_extraction.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/model/coffee_bean_processing.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/coffee_bean_search.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/country_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasting_write_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasting_write_secod_screen.dart';
import 'package:brew_buds/model/coffee_bean/beverage_type.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastingWriteFirstScreen extends StatefulWidget {
  const TastingWriteFirstScreen({super.key});

  @override
  State<TastingWriteFirstScreen> createState() => _TastingWriteFirstScreenState();
}

class _TastingWriteFirstScreenState extends State<TastingWriteFirstScreen>
    with TastingWriteMixin<TastingWriteFirstScreen> {
  final TextEditingController _areaController = TextEditingController();
  final FocusNode _areaFocusNode = FocusNode();
  final TextEditingController _varietyController = TextEditingController();
  final FocusNode _varietyFocusNode = FocusNode();
  final TextEditingController _roasteryController = TextEditingController();
  final FocusNode _roasteryFocusNode = FocusNode();
  final TextEditingController _processingController = TextEditingController();
  final FocusNode _processingFocusNode = FocusNode();
  final TextEditingController _extractionController = TextEditingController();
  final FocusNode _extractionFocusNode = FocusNode();
  final List<String> roastingPointText = ['라이트', '라이트 미디엄', '미디엄', '미디엄 다크', '다크'];

  @override
  int get currentStep => 1;

  List<BeanWriteOption> getOptions(CoffeeBeanType? type) => switch (type) {
        null => BeanWriteOption.values,
        CoffeeBeanType.singleOrigin => BeanWriteOption.values,
        CoffeeBeanType.blend => [BeanWriteOption.roastery, BeanWriteOption.extraction, BeanWriteOption.beverageType],
      };

  bool isExpanded(BeanWriteOption option) => expandedSections.contains(option);

  Set<BeanWriteOption> expandedSections = {};

  void toggleSection(BeanWriteOption option) {
    setState(() {
      if (expandedSections.contains(option)) {
        expandedSections.remove(option);
      } else {
        expandedSections.add(option);
      }
    });
  }

  bool isFormComplete = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _varietyController.dispose();
    _processingController.dispose();
    _roasteryController.dispose();
    _areaFocusNode.dispose();
    _varietyFocusNode.dispose();
    _roasteryFocusNode.dispose();
    _processingFocusNode.dispose();
    _extractionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          buildTitle(),
          const SizedBox(height: 20),
          Selector<TastingWritePresenter, String>(
            selector: (context, presenter) => presenter.name,
            builder: (context, name, child) => _buildBeanName(name),
          ),
          const SizedBox(height: 36),
          Selector<TastingWritePresenter, bool>(
            selector: (context, presenter) => presenter.isOfficial,
            builder: (context, isOfficial, child) => AbsorbPointer(
              absorbing: isOfficial,
              child: Column(
                children: [
                  Selector<TastingWritePresenter, CoffeeBeanType?>(
                    selector: (context, presenter) => presenter.coffeeBeanType,
                    builder: (context, type, child) => _buildCoffeeTypeSelector(
                      currentType: type,
                      isOfficial: isOfficial,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Selector<TastingWritePresenter, bool>(
                    selector: (context, presenter) => presenter.isDecaf ?? false,
                    builder: (context, isDecaf, child) => _buildDecafCheckbox(
                      isDecaf: isDecaf,
                      isOfficial: isOfficial,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Selector<TastingWritePresenter, List<String>>(
                    selector: (context, presenter) => presenter.originCountry,
                    builder: (context, originCountry, child) {
                      final isSingleOrigin = context.select<TastingWritePresenter, bool>(
                        (presenter) => presenter.coffeeBeanType == CoffeeBeanType.singleOrigin,
                      );
                      return _buildCountry(
                        originCountry,
                        isOfficial: isOfficial,
                        isSingleOrigin: isSingleOrigin,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Selector<TastingWritePresenter, CoffeeBeanType?>(
            selector: (context, presenter) => presenter.coffeeBeanType,
            builder: (context, type, child) {
              final options = getOptions(type);
              final isOfficial = context.select<TastingWritePresenter, bool>((presenter) => presenter.isOfficial);
              return Column(
                children: List<Widget>.generate(
                  options.length,
                  (index) => _buildExpandableItem(options[index], isOfficial),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
      child: Selector<TastingWritePresenter, bool>(
        selector: (context, presenter) => presenter.isValidFirstPage,
        builder: (context, isValidFirstPage, child) {
          return AbsorbPointer(
            absorbing: !isValidFirstPage,
            child: ThrottleButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TastingWriteSecondScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: isValidFirstPage ? ColorStyles.black : ColorStyles.gray20,
                ),
                child: Text(
                  '다음',
                  style: TextStyles.labelMediumMedium.copyWith(
                    color: isValidFirstPage ? ColorStyles.white : ColorStyles.gray40,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoffeeTypeSelector({CoffeeBeanType? currentType, bool isOfficial = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("원두 유형", style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        Opacity(
          opacity: isOfficial ? 0.4 : 1,
          child: Row(
            spacing: 8,
            children: CoffeeBeanType.values
                .map(
                  (type) => Expanded(
                    child: ThrottleButton(
                      onTap: () {
                        if (type == CoffeeBeanType.blend) {
                          _processingController.value = TextEditingValue.empty;
                        }
                        context.read<TastingWritePresenter>().onChangeType(currentType == type ? null : type);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: currentType == type ? ColorStyles.background : ColorStyles.white,
                          border: Border.all(color: currentType == type ? ColorStyles.red : ColorStyles.gray50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            type.toString(),
                            style: TextStyles.labelMediumMedium.copyWith(
                              color: currentType == type ? ColorStyles.red : ColorStyles.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDecafCheckbox({required bool isDecaf, bool isOfficial = false}) {
    return Opacity(
      opacity: isOfficial ? 0.4 : 1,
      child: Row(
        children: [
          ThrottleButton(
            onTap: () {
              context.read<TastingWritePresenter>().onChangeIsDecaf(!isDecaf);
            },
            child: SvgPicture.asset('assets/icons/${isDecaf ? 'checked' : 'unChecked'}.svg', width: 18, height: 18),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text('디카페인', style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50)),
          ),
        ],
      ),
    );
  }

  Widget _buildBeanName(String beanName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('원두 이름', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        ThrottleButton(
          onTap: () {
            _showCoffeeBeanSearchBottomSheet(beanName);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: ColorStyles.gray40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (beanName.isEmpty) ...[
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      '원두 이름을 검색해보세요',
                      style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                    ),
                  ),
                ] else ...[
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      decoration: const BoxDecoration(
                          color: ColorStyles.black, borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        beanName,
                        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ThrottleButton(
                    onTap: () {
                      _processingController.value = TextEditingValue.empty;
                      _extractionController.value = TextEditingValue.empty;
                      _varietyController.value = TextEditingValue.empty;
                      _areaController.value = TextEditingValue.empty;
                      _roasteryController.value = TextEditingValue.empty;
                      context.read<TastingWritePresenter>().onDeleteBeanName();
                    },
                    child: SvgPicture.asset(
                      'assets/icons/x_round.svg',
                      width: 24,
                      height: 24,
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

  Widget _buildCountry(List<String> countryList, {bool isOfficial = false, bool isSingleOrigin = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('원산지', style: TextStyles.title01SemiBold),
        const SizedBox(height: 8),
        Opacity(
          opacity: isOfficial ? 0.4 : 1,
          child: ThrottleButton(
            onTap: () {
              _showCountryBottomSheet(country: countryList, isSingleOrigin: isSingleOrigin);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: ColorStyles.gray40)),
              child: Row(
                children: [
                  if (countryList.isEmpty) ...[
                    SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '원산지를 선택해주세요',
                        style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 4,
                          children: List<Widget>.generate(
                            countryList.length,
                            (index) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: const BoxDecoration(
                                color: ColorStyles.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                countryList[index],
                                style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ThrottleButton(
                      onTap: () {
                        context.read<TastingWritePresenter>().onChangeCountry(null);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/x_round.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableItem(BeanWriteOption option, bool isOfficial) {
    final expanded = isExpanded(option);
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      color: ColorStyles.gray10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThrottleButton(
            onTap: () => toggleSection(option),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${option.toString()} (선택)',
                    style: TextStyles.labelSmallMedium,
                  ),
                ),
                SvgPicture.asset(
                  expanded ? 'assets/icons/minus_round.svg' : 'assets/icons/plus_round.svg',
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildExpandedOptions(option, isOfficial),
            ),
          SizedBox(height: expanded ? 24 : 12),
          Container(height: 1, color: ColorStyles.gray30),
        ],
      ),
    );
  }

  Widget _buildExpandedOptions(BeanWriteOption option, bool isOfficial) {
    switch (option) {
      case BeanWriteOption.area:
        return AbsorbPointer(
          absorbing: isOfficial,
          child: Opacity(
            opacity: isOfficial ? 0.4 : 1.0,
            child: _buildArea(),
          ),
        );
      case BeanWriteOption.variety:
        return AbsorbPointer(
          absorbing: isOfficial,
          child: Opacity(
            opacity: isOfficial ? 0.4 : 1.0,
            child: _buildVariety(),
          ),
        );
      case BeanWriteOption.processing:
        return Selector<TastingWritePresenter, List<CoffeeBeanProcessing>>(
          selector: (context, presenter) => presenter.currentProcess,
          builder: (context, processing, child) {
            return AbsorbPointer(
              absorbing: isOfficial,
              child: Opacity(
                opacity: isOfficial ? 0.4 : 1.0,
                child: _buildProcessing(currentProcessing: processing),
              ),
            );
          },
        );
      case BeanWriteOption.roastingPoint:
        return Selector<TastingWritePresenter, int?>(
          selector: (context, presenter) => presenter.roastingPoint,
          builder: (context, roastingPoint, child) {
            return AbsorbPointer(
              absorbing: isOfficial,
              child: Opacity(
                opacity: isOfficial ? 0.4 : 1.0,
                child: _buildRoastingPoint(currentRoastingPoint: roastingPoint),
              ),
            );
          },
        );
      case BeanWriteOption.roastery:
        return AbsorbPointer(
          absorbing: isOfficial,
          child: Opacity(
            opacity: isOfficial ? 0.4 : 1.0,
            child: _buildRoastery(),
          ),
        );
      case BeanWriteOption.extraction:
        return Selector<TastingWritePresenter, CoffeeBeanExtraction?>(
          selector: (context, presenter) => presenter.extraction,
          builder: (context, extraction, child) {
            return _buildExtraction(currentExtraction: extraction);
          },
        );
      case BeanWriteOption.beverageType:
        return Selector<TastingWritePresenter, bool?>(
          selector: (context, presenter) => presenter.isIce,
          builder: (context, isIce, child) {
            return _buildBeverageType(isIce: isIce);
          },
        );
    }
  }

  Widget _buildArea() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        focusNode: _areaFocusNode,
        controller: _areaController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣0-9, ]'), allow: true),
        ],
        decoration: InputDecoration(
          isDense: true,
          hintText: '원두 생산 지역을 입력하세요',
          hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          filled: true,
          fillColor: ColorStyles.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
        ),
        style: TextStyles.labelSmallMedium,
        maxLines: null,
        cursorColor: ColorStyles.black,
        cursorErrorColor: ColorStyles.black,
        cursorHeight: 16,
        cursorWidth: 1,
        onChanged: (area) {
          context.read<TastingWritePresenter>().onChangeRegion(area);
        },
      ),
    );
  }

  Widget _buildVariety() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        focusNode: _varietyFocusNode,
        controller: _varietyController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣0-9, ]'), allow: true),
        ],
        decoration: InputDecoration(
          isDense: true,
          hintText: '원두 품종을 입력해 주세요.',
          hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          filled: true,
          fillColor: ColorStyles.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
        ),
        style: TextStyles.labelSmallMedium,
        maxLines: null,
        cursorColor: ColorStyles.black,
        cursorErrorColor: ColorStyles.black,
        cursorHeight: 16,
        cursorWidth: 1,
        onChanged: (variety) {
          context.read<TastingWritePresenter>().onChangeVariety(variety);
        },
      ),
    );
  }

  Widget _buildProcessing({required List<CoffeeBeanProcessing> currentProcessing}) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: 15.6 / 13,
      color: ColorStyles.black,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: CoffeeBeanProcessing.values.map(
              (processing) {
                final isSelected = currentProcessing.contains(processing);
                return ThrottleButton(
                  onTap: () {
                    if (currentProcessing.contains(CoffeeBeanProcessing.writtenByUser)) {
                      _processingController.value = TextEditingValue.empty;
                    }
                    context.read<TastingWritePresenter>().onSelectProcess(processing);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorStyles.background : Colors.transparent,
                      border: Border.all(color: isSelected ? ColorStyles.red : ColorStyles.gray50),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      processing.toString(),
                      style: textStyle.copyWith(
                        color: isSelected ? ColorStyles.red : ColorStyles.black,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          if (currentProcessing.contains(CoffeeBeanProcessing.writtenByUser)) ...[
            const SizedBox(height: 24),
            TextFormField(
              focusNode: _processingFocusNode,
              controller: _processingController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣 ]'), allow: true),
              ],
              decoration: InputDecoration(
                isDense: true,
                hintText: '원두 가공방식을 입력해주세요.',
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                filled: true,
                fillColor: ColorStyles.white,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.gray40),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.gray40),
                ),
              ),
              style: TextStyles.labelSmallMedium,
              maxLines: null,
              cursorColor: ColorStyles.black,
              cursorErrorColor: ColorStyles.black,
              cursorHeight: 16,
              cursorWidth: 1,
              onChanged: (processing) {
                context.read<TastingWritePresenter>().onChangeProcessText(processing);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoastingPoint({int? currentRoastingPoint}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
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
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ThrottleButton(
                        onTap: () {
                          context
                              .read<TastingWritePresenter>()
                              .onChangeRoastingPoint(currentRoastingPoint == index ? null : index);
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: currentRoastingPoint == index ? ColorStyles.white : Colors.transparent,
                            shape: BoxShape.circle,
                            border: currentRoastingPoint == index ? Border.all(color: ColorStyles.red) : null,
                          ),
                          child: Center(
                            child: Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                color: currentRoastingPoint == index ? ColorStyles.red : ColorStyles.gray50,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        roastingPointText[index],
                        style: TextStyles.captionMediumMedium.copyWith(
                          color: currentRoastingPoint != null && currentRoastingPoint == index
                              ? ColorStyles.red
                              : currentRoastingPoint == null
                                  ? ColorStyles.gray50
                                  : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoastery() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        focusNode: _roasteryFocusNode,
        controller: _roasteryController,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣0-9, ]'), allow: true),
        ],
        decoration: InputDecoration(
          isDense: true,
          hintText: '로스터리 이름을 입력해 주세요.',
          hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          filled: true,
          fillColor: ColorStyles.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
          ),
        ),
        style: TextStyles.labelSmallMedium,
        maxLines: null,
        cursorColor: ColorStyles.black,
        cursorErrorColor: ColorStyles.black,
        cursorHeight: 16,
        cursorWidth: 1,
        onChanged: (roastery) {
          context.read<TastingWritePresenter>().onChangeRoastery(roastery);
        },
      ),
    );
  }

  Widget _buildExtraction({CoffeeBeanExtraction? currentExtraction}) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: 15.6 / 13,
      color: ColorStyles.black,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: CoffeeBeanExtraction.values.map(
              (extraction) {
                final isSelected = currentExtraction == extraction;
                return ThrottleButton(
                  onTap: () {
                    if (currentExtraction == CoffeeBeanExtraction.writtenByUser) {
                      _extractionController.value = TextEditingValue.empty;
                    }
                    context.read<TastingWritePresenter>().onChangeExtraction(extraction);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorStyles.background : Colors.transparent,
                      border: Border.all(color: isSelected ? ColorStyles.red : ColorStyles.gray50),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text(
                      extraction.toString(),
                      style: textStyle.copyWith(color: isSelected ? ColorStyles.red : ColorStyles.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          if (currentExtraction == CoffeeBeanExtraction.writtenByUser) ...[
            const SizedBox(height: 24),
            TextFormField(
              focusNode: _extractionFocusNode,
              controller: _extractionController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣 ]'), allow: true),
              ],
              decoration: InputDecoration(
                isDense: true,
                hintText: '원두 추출방식을 입력해주세요.',
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                filled: true,
                fillColor: ColorStyles.white,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.gray40),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorStyles.gray40),
                ),
              ),
              style: TextStyles.labelSmallMedium,
              maxLines: null,
              cursorColor: ColorStyles.black,
              cursorErrorColor: ColorStyles.black,
              cursorHeight: 16,
              cursorWidth: 1,
              onChanged: (extraction) {
                context.read<TastingWritePresenter>().onChangeExtractionText(extraction);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBeverageType({bool? isIce}) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13.sp,
      height: 15.6 / 13,
      color: ColorStyles.black,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        spacing: 8,
        children: BeverageType.values.map(
          (type) {
            final BeverageType? currentType = isIce == null
                ? null
                : isIce
                    ? BeverageType.ice
                    : BeverageType.hot;
            return Expanded(
              child: ThrottleButton(
                onTap: () {
                  context.read<TastingWritePresenter>().onChangeBeverageType(
                        currentType == type
                            ? null
                            : type == BeverageType.ice
                                ? true
                                : false,
                      );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                    color: currentType == type ? ColorStyles.background : Colors.transparent,
                    border: Border.all(color: currentType == type ? ColorStyles.red : ColorStyles.gray50),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    type.toString(),
                    style: textStyle.copyWith(color: currentType == type ? ColorStyles.red : ColorStyles.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  _showCoffeeBeanSearchBottomSheet(String name) async {
    final result = await showBarrierDialog<CoffeeBeanSearchBottomSheetResult>(
      context: context,
      pageBuilder: (context, _, __) {
        return CoffeeBeanSearchBottomSheet.build(
          initialText: name,
          maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
        );
      },
    );

    if (result != null && context.mounted) {
      switch (result) {
        case ResultsOfSearched():
          final coffeeBean = result.coffeeBean;
          _onSelectCoffeeBean(coffeeBean);
          _setCoffeeBeanValue(coffeeBean);
          break;
        case ResultsOfWritten():
          _onCreateCoffeeBean(result.name);
          break;
      }
    }
  }

  _onSelectCoffeeBean(CoffeeBean coffeeBean) {
    context.read<TastingWritePresenter>().onSelectedCoffeeBean(coffeeBean);
  }

  _onCreateCoffeeBean(String beanName) {
    context.read<TastingWritePresenter>().onSelectedCoffeeBeanName(beanName);
  }

  _showCountryBottomSheet({required List<String> country, required bool isSingleOrigin}) async {
    final result = await showBarrierDialog<List<String>>(
        context: context,
        pageBuilder: (context, _, __) {
          return CountryBottomSheet(
            initialCountry: List.from(country),
            isSingleOrigin: isSingleOrigin,
          );
        });

    if (result != null) {
      _onChangeCountry(result);
    }
  }

  _onChangeCountry(List<String> country) {
    context.read<TastingWritePresenter>().onChangeCountry(country);
  }

  _setCoffeeBeanValue(CoffeeBean coffeeBean) {
    if (coffeeBean.type == CoffeeBeanType.blend) {
      final roastery = coffeeBean.roastery;
      if (roastery != null && roastery.isNotEmpty) {
        _roasteryController.text = roastery;
        setState(() {
          expandedSections.add(BeanWriteOption.roastery);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.roastery);
        });
      }
    } else {
      final region = coffeeBean.region;
      final variety = coffeeBean.variety;
      final process = coffeeBean.process;
      final roastPoint = coffeeBean.roastPoint;
      final roastery = coffeeBean.roastery;

      if (region != null && region.isNotEmpty) {
        _areaController.text = region;
        setState(() {
          expandedSections.add(BeanWriteOption.area);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.area);
        });
      }
      if (variety != null && variety.isNotEmpty) {
        _varietyController.text = variety;
        setState(() {
          expandedSections.add(BeanWriteOption.variety);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.variety);
        });
      }
      if (process != null && process.isNotEmpty) {
        setState(() {
          expandedSections.add(BeanWriteOption.processing);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.processing);
        });
      }
      if (roastPoint != null) {
        setState(() {
          expandedSections.add(BeanWriteOption.roastingPoint);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.roastingPoint);
        });
      }
      if (roastery != null && roastery.isNotEmpty) {
        _roasteryController.text = roastery;
        setState(() {
          expandedSections.add(BeanWriteOption.roastery);
        });
      } else {
        setState(() {
          expandedSections.remove(BeanWriteOption.roastery);
        });
      }
    }
  }
}
