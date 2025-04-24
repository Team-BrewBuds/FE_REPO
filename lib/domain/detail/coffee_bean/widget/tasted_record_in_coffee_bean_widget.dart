import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastedRecordInCoffeeBeanWidget extends StatelessWidget {
  const TastedRecordInCoffeeBeanWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Builder(builder: (context) {
                      final nickname = context.select<TastedRecordInCoffeeBeanPresenter, String>(
                        (presenter) => presenter.authorNickname,
                      );
                      return Text(nickname, style: TextStyles.labelSmallSemiBold);
                    }),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final rating = context.select<TastedRecordInCoffeeBeanPresenter, double>(
                              (presenter) => presenter.rating,
                        );
                        return Row(
                          children: [
                            ...List.generate(
                              5,
                              (index) {
                                final i = index + 1;
                                if (i <= rating) {
                                  return SvgPicture.asset(
                                    'assets/icons/star_fill.svg',
                                    height: 16,
                                    width: 16,
                                    colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                  );
                                } else if (i - rating < 1) {
                                  return SvgPicture.asset(
                                    'assets/icons/star_half.svg',
                                    height: 16,
                                    width: 16,
                                  );
                                } else {
                                  return SvgPicture.asset(
                                    'assets/icons/star_fill.svg',
                                    height: 16,
                                    width: 16,
                                    colorFilter: const ColorFilter.mode(ColorStyles.gray40, BlendMode.srcIn),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$rating',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  height: 18 / 12,
                                  letterSpacing: -0.01,
                                  color: ColorStyles.gray70),
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 7),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Builder(
                        builder: (context) {
                          final flavors = context.select<TastedRecordInCoffeeBeanPresenter, List<String>>(
                                (presenter) => presenter.flavors,
                          );
                          return Row(
                            spacing: 2,
                            children: flavors
                                .map(
                                  (e) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.8, color: ColorStyles.gray70),
                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: Text(
                                      e,
                                      style: TextStyles.captionSmallRegular.copyWith(
                                        color: ColorStyles.gray70,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Builder(
                builder: (context) {
                  final imageUrl = context.select<TastedRecordInCoffeeBeanPresenter, String>(
                        (presenter) => presenter.imageUrl,
                  );
                  return MyNetworkImage(imageUrl: imageUrl, height: 64, width: 64);
                }
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            color: ColorStyles.gray20,
            child: Builder(
              builder: (context) {
                final contents = context.select<TastedRecordInCoffeeBeanPresenter, String>(
                      (presenter) => presenter.contents,
                );
                return Text(
                  contents,
                  style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
