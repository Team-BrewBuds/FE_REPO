import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/search/widgets/search_result/search_result_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CoffeeBeanResultsItem extends StatelessWidget {
  const CoffeeBeanResultsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => ScreenNavigator.showCoffeeBeanDetail(
        context: context,
        id: context.read<CoffeeBeanSearchResultPresenter>().id,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Builder(
                    builder: (context) {
                      final beanName = context.select<CoffeeBeanSearchResultPresenter, String>(
                        (presenter) => presenter.beanName,
                      );
                      return Text(
                        beanName,
                        style: TextStyles.labelMediumMedium,
                      );
                    },
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/star_fill.svg',
                        height: 14,
                        width: 14,
                        colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 2),
                      Builder(
                        builder: (context) {
                          final rating = context.select<CoffeeBeanSearchResultPresenter, double>(
                            (presenter) => presenter.rating,
                          );
                          final recordCount = context.select<CoffeeBeanSearchResultPresenter, int>(
                            (presenter) => presenter.recordCount,
                          );
                          return Text(
                            '$rating ($recordCount)',
                            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                          );
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                final imageUrl = context.select<CoffeeBeanSearchResultPresenter, String>(
                  (presenter) => presenter.imageUrl,
                );
                if (imageUrl.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: MyNetworkImage(imageUrl: imageUrl, height: 64, width: 64),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
