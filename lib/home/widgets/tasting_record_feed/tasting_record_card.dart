import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/tag_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
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
    return Container(
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
                  style: TextStyles.headlineLargeBold.copyWith(color: ColorStyles.white),
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
      children: tags
          .map((text) {
            return TagFactory.buildTag(
              icon: SvgPicture.asset(
                'assets/icons/coffee_bean.svg',
                colorFilter: const ColorFilter.mode(
                  ColorStyles.white,
                  BlendMode.srcIn,
                ),
              ),
              text: text,
              style: TagStyle(size: TagSize.small, iconAlign: TagIconAlign.left),
            );
          })
          .separator(separatorWidget: const SizedBox(width: 4))
          .toList(),
    );
  }
}
