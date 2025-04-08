import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastedRecordInCoffeeBeanWidget extends StatelessWidget {
  final String authorNickname;
  final double rating;
  final List<String> flavors;
  final String imageUrl;
  final String contents;

  const TastedRecordInCoffeeBeanWidget({
    super.key,
    required this.authorNickname,
    required this.rating,
    required this.flavors,
    required this.imageUrl,
    required this.contents,
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
                    Text(authorNickname, style: TextStyles.labelSmallSemiBold),
                    const SizedBox(height: 4),
                    Row(
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
                    ),
                    const SizedBox(height: 7),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MyNetworkImage(imageUrl: imageUrl, height: 64, width: 64),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            color: ColorStyles.gray20,
            child: Text(
              contents,
              style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
