import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavedTastingRecordWidget extends StatelessWidget {
  final String beanName;
  final String rating;
  final String likeCount;
  final List<String> flavor;
  final String? imageUri;

  @override
  Widget build(BuildContext context) {
    final imageUri = this.imageUri;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '시음기록',
                  style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
                ),
                const SizedBox(height: 4),
                Text(
                  beanName,
                  style: TextStyles.title01SemiBold,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                    ),
                    Text(
                      '$rating ($likeCount)',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 4),
                //Api 누락
                Row(
                  children: flavor
                      .map(
                        (taste) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            decoration: BoxDecoration(
                                border: Border.all(color: ColorStyles.gray70, width: 0.8),
                                borderRadius: BorderRadius.circular(6)),
                            child: Center(
                              child: Text(
                                taste,
                                style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70),
                              ),
                            ),
                          );
                        },
                      )
                      .separator(separatorWidget: const SizedBox(width: 2))
                      .toList(),
                ),
              ],
            ),
          ),
          if (imageUri != null) ...[
            const SizedBox(width: 24),
            MyNetworkImage(
              imageUrl: imageUri,
              height: 64,
              width: 64,
              color: const Color(0xffD9D9D9),
            ),
          ],
        ],
      ),
    );
  }

  const SavedTastingRecordWidget({
    super.key,
    required this.beanName,
    required this.rating,
    required this.likeCount,
    required this.flavor,
    this.imageUri,
  });
}
