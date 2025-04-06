import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/domain/setting/presenter/account_detail_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AccountDetailView extends StatefulWidget {
  const AccountDetailView({super.key});

  @override
  State<AccountDetailView> createState() => _AccountDetailViewState();
}

class _AccountDetailViewState extends State<AccountDetailView> with SnackBarMixin<AccountDetailView> {
  final List<String> _body = ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'];
  final List<String> _acidity = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _bitterness = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _sweet = ['약한', '약간 약한', '보통', '약간 강한', '강한'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AccountDetailPresenter>().initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Selector<AccountDetailPresenter, List<CoffeeLife>?>(
                selector: (context, presenter) => presenter.selectedCoffeeLifeList,
                builder: (context, selectedCoffeeLife, child) =>
                    _buildCoffeeLifes(selectedCoffeeLifes: selectedCoffeeLife ?? []),
              ),
              const SizedBox(height: 56),
              Selector<AccountDetailPresenter, bool?>(
                selector: (context, presenter) => presenter.isCertificated,
                builder: (context, isCertificated, child) => _buildCertificated(isCertificated: isCertificated),
              ),
              const SizedBox(height: 56),
              _buildTaste(),
              const SizedBox(height: 104),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Center(
                child: GestureDetector(
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
              ),
            ),
            const Center(child: Text('맞춤 정보', style: TextStyles.title02Bold)),
            Positioned(
              right: 0,
              child: Center(
                child: Selector<AccountDetailPresenter, bool>(
                  selector: (context, presenter) => presenter.canEdit,
                  builder: (context, canEdit, child) {
                    return AbsorbPointer(
                      absorbing: !canEdit,
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<AccountDetailPresenter>()
                              .onSave()
                              .then((_) => context.pop('맞춤정보 저장을 완료했어요.'))
                              .onError((error, stackTrace) => showSnackBar(message: '맞춤정보 저장에 실패했어요.'));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            '저장',
                            style: TextStyles.title02SemiBold.copyWith(
                              color: canEdit ? ColorStyles.red : ColorStyles.gray30,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeLifes({required List<CoffeeLife> selectedCoffeeLifes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('커피 생활을 어떻게 즐기세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text('최대 6개까지 선택할 수 있어요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
        const SizedBox(height: 14),
        MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: CoffeeLife.values.length,
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context.read<AccountDetailPresenter>().onSelectCoffeeLife(CoffeeLife.values[index]);
              },
              child: Container(
                padding: const EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: selectedCoffeeLifes.contains(CoffeeLife.values[index])
                      ? ColorStyles.background
                      : ColorStyles.white,
                  border: Border.all(
                      color: selectedCoffeeLifes.contains(CoffeeLife.values[index])
                          ? ColorStyles.red
                          : ColorStyles.gray50),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(CoffeeLife.values[index].imagePath, width: 90, height: 90, fit: BoxFit.cover),
                    const SizedBox(height: 4),
                    Text(
                      CoffeeLife.values[index].title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 15.6 / 13,
                        letterSpacing: -0.01,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CoffeeLife.values[index].description,
                      style: TextStyles.captionSmallMedium.copyWith(
                        color: ColorStyles.gray60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCertificated({bool? isCertificated}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('커피 관련 자격증이 있으세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        const Text(
          '현재, 취득한 자격증이 있는지 알려주세요.',
          style: TextStyle(
            color: ColorStyles.gray50,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 21 / 14,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<AccountDetailPresenter>().onSelectCertificated(true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isCertificated ?? false ? ColorStyles.background : ColorStyles.white,
                    border: Border.all(color: isCertificated ?? false ? ColorStyles.red : ColorStyles.gray50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '있어요',
                      style: TextStyles.labelMediumMedium.copyWith(
                        color: isCertificated ?? false ? ColorStyles.red : ColorStyles.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<AccountDetailPresenter>().onSelectCertificated(false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isCertificated ?? true ? ColorStyles.white : ColorStyles.background,
                    border: Border.all(color: isCertificated ?? true ? ColorStyles.gray50 : ColorStyles.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '없어요',
                      style: TextStyles.labelMediumMedium.copyWith(
                        color: isCertificated ?? true ? ColorStyles.black : ColorStyles.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaste() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('평소에 어떤 커피를 즐기세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text('버디님의 커피 취향에 꼭 맞는 원두를 만나보세요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
        const SizedBox(height: 27),
        Selector<AccountDetailPresenter, int?>(
          selector: (context, presenter) => presenter.bodyValue,
          builder: (context, value, child) => _buildBodyFeeling(bodyValue: value),
        ),
        const SizedBox(height: 32),
        Selector<AccountDetailPresenter, int?>(
          selector: (context, presenter) => presenter.acidityValue,
          builder: (context, value, child) => _buildAcidity(acidityValue: value),
        ),
        const SizedBox(height: 32),
        Selector<AccountDetailPresenter, int?>(
          selector: (context, presenter) => presenter.bitternessValue,
          builder: (context, value, child) => _buildBitterness(bitternessValue: value),
        ),
        const SizedBox(height: 32),
        Selector<AccountDetailPresenter, int?>(
          selector: (context, presenter) => presenter.sweetnessValue,
          builder: (context, value, child) => _buildSweet(sweetValue: value),
        ),
      ],
    );
  }

  Widget _buildBodyFeeling({int? bodyValue}) {
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
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AccountDetailPresenter>().onSelectBodyValue(index + 1);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: bodyValue == index + 1 ? ColorStyles.white : Colors.transparent,
                              shape: BoxShape.circle,
                              border: bodyValue == index + 1 ? Border.all(color: ColorStyles.red) : null,
                            ),
                            child: Center(
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: bodyValue == index + 1 ? ColorStyles.red : ColorStyles.gray50,
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
                            color: bodyValue != null && bodyValue == index + 1
                                ? ColorStyles.red
                                : (bodyValue == null || bodyValue == 0)
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
      ],
    );
  }

  Widget _buildAcidity({int? acidityValue}) {
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
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AccountDetailPresenter>().onSelectAcidityValue(index + 1);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: acidityValue == index + 1 ? ColorStyles.white : Colors.transparent,
                              shape: BoxShape.circle,
                              border: acidityValue == index + 1 ? Border.all(color: ColorStyles.red) : null,
                            ),
                            child: Center(
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: acidityValue == index + 1 ? ColorStyles.red : ColorStyles.gray50,
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
                            color: acidityValue != null && acidityValue == index + 1
                                ? ColorStyles.red
                                : (acidityValue == null || acidityValue == 0)
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
      ],
    );
  }

  Widget _buildBitterness({int? bitternessValue}) {
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
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AccountDetailPresenter>().onSelectBitternessValue(index + 1);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: bitternessValue == index + 1 ? ColorStyles.white : Colors.transparent,
                              shape: BoxShape.circle,
                              border: bitternessValue == index + 1 ? Border.all(color: ColorStyles.red) : null,
                            ),
                            child: Center(
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: bitternessValue == index + 1 ? ColorStyles.red : ColorStyles.gray50,
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
                            color: bitternessValue != null && bitternessValue == index + 1
                                ? ColorStyles.red
                                : (bitternessValue == null || bitternessValue == 0)
                                    ? ColorStyles.gray50
                                    : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ).separator(separatorWidget: const Spacer()).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSweet({int? sweetValue}) {
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
                    (index) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AccountDetailPresenter>().onSelectSweetValue(index + 1);
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: sweetValue == index + 1 ? ColorStyles.white : Colors.transparent,
                              shape: BoxShape.circle,
                              border: sweetValue == index + 1 ? Border.all(color: ColorStyles.red) : null,
                            ),
                            child: Center(
                              child: Container(
                                height: 14,
                                width: 14,
                                decoration: BoxDecoration(
                                  color: sweetValue == index + 1 ? ColorStyles.red : ColorStyles.gray50,
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
                            color: sweetValue != null && sweetValue == index + 1
                                ? ColorStyles.red
                                : (sweetValue == null || sweetValue == 0)
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
      ],
    );
  }
}
