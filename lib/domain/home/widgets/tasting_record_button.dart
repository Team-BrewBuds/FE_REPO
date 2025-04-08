import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastingRecordButton extends StatelessWidget {
  final String name;
  final String bodyText;

  const TastingRecordButton({
    super.key,
    required this.name,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorStyles.gray10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('시음기록', style: TextStyles.title01SemiBold),
                    const SizedBox(width: 6),
                    Container(width: 1, height: 12, color: ColorStyles.black),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyles.title01SemiBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  bodyText,
                  style: TextStyles.bodyRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/arrow.svg',
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
