import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/profile/presenter/coffee_life_bottom_sheet_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoffeeLifeBottomSheet extends StatelessWidget {
  const CoffeeLifeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Consumer<CoffeeLifeBottomSheetPresenter>(builder: (context, presenter, child) {
                return Column(
                  children: [
                    _buildTitle(context),
                    _buildCoffeeLife(context, coffeeLifeList: presenter.selectedCoffeeLifeList),
                    _buildBottomButtons(context, canSave: presenter.selectedCoffeeLifeList.isNotEmpty),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: ColorStyles.gray20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24, width: 24),
          const Spacer(),
          const Text('커피생활', style: TextStyles.title02Bold),
          const Spacer(),
          InkWell(
            onTap: () => context.pop(),
            child: SvgPicture.asset('assets/icons/x.svg', fit: BoxFit.cover, height: 24, width: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeLife(BuildContext context, {required List<CoffeeLife> coffeeLifeList}) {
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      itemCount: CoffeeLife.values.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context.read<CoffeeLifeBottomSheetPresenter>().onSelectCoffeeLife(CoffeeLife.values[index]);
          },
          child: Container(
            padding: const EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
              color: coffeeLifeList.contains(CoffeeLife.values[index]) ? ColorStyles.background : ColorStyles.white,
              border: Border.all(
                color: coffeeLifeList.contains(CoffeeLife.values[index]) ? ColorStyles.red : ColorStyles.gray50,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  CoffeeLife.values[index].imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
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
                  style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray60),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context, {bool canSave = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.read<CoffeeLifeBottomSheetPresenter>().reset();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorStyles.gray30,
              ),
              child: const Text('초기화', style: TextStyles.labelMediumMedium),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                context.pop(context.read<CoffeeLifeBottomSheetPresenter>().selectedCoffeeLifeList);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: canSave ? ColorStyles.gray30 : ColorStyles.gray20,
                ),
                child: Text(
                  '적용하기',
                  style: TextStyles.labelMediumMedium.copyWith(color: canSave ? ColorStyles.black : ColorStyles.gray40),
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
