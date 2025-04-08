import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastingRecordCard extends StatelessWidget {
  final Widget image;
  final String rating;
  final String type;
  final String name;
  final List<String> tags;

  const TastingRecordCard({
    super.key,
    required this.image,
    required this.rating,
    required this.type,
    required this.name,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned.fill(child: image),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildGPA(),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 14, color: ColorStyles.white70),
                    const SizedBox(width: 8),
                    Text(
                      type,
                      style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyles.title05Bold.copyWith(color: ColorStyles.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                _buildTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGPA() {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/star_fill.svg',
          height: 16,
          width: 16,
          colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(
          rating,
          style: TextStyles.title02Bold.copyWith(color: ColorStyles.white),
        )
      ],
    );
  }

  Widget _buildTags() {
    return Row(
      spacing: 4,
      children: tags
          .map((text) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorStyles.black,
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
                ),
              ),
            );
          })
          .toList(),
    );
  }
}
