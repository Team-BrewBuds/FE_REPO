import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_tooltip.dart';
import 'package:flutter/material.dart';

class BeanDetail extends StatelessWidget {
  final String? beanType;
  final List<String>? country;
  final String? region;
  final String? variety;
  final List<String>? process;
  final String? roastPoint;
  final String? roastery;
  final String? extraction;

  const BeanDetail({
    super.key,
    this.beanType,
    this.country,
    this.region,
    this.variety,
    this.process,
    this.roastPoint,
    this.roastery,
    this.extraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '원두 상세정보',
          style: TextStyles.title02SemiBold,
        ),
        const SizedBox(height: 20),
        ...[
          _buildDetailItem(title: '원두 유형', content: beanType),
          _buildDetailListItem(title: '원산지', contents: country),
          _buildDetailItem(title: '추출방식', content: extraction),
          _buildDetailItem(title: '로스팅 포인트', content: roastPoint),
          _buildDetailListItem(title: '가공방식', contents: process),
          _buildDetailItem(title: '생산 지역', content: region),
          _buildDetailItem(title: '로스터리', content: roastery),
          _buildDetailItem(title: '품종', content: variety),
        ].whereType<Widget>().separator(separatorWidget: const SizedBox(height: 13))
      ],
    );
  }

  Widget? _buildDetailListItem({required String title, List<String>? contents}) {
    return contents != null && contents.isNotEmpty
        ? Row(
            children: [
              Text(title, style: TextStyles.labelMediumMedium),
              if (contents.length > 1)
                Expanded(
                  child: MyTooltip(
                    content: contents.join(', '),
                    child: Text(
                      '${contents.first} 외 ${contents.length - 1}',
                      style: TextStyles.labelMediumMedium.copyWith(decoration: TextDecoration.underline),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Text(
                    contents.first,
                    style: TextStyles.labelMediumMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          )
        : null;
  }

  Widget? _buildDetailItem({required String title, String? content}) {
    return content != null && content != 'null'
        ? Row(
            children: [
              Text(title, style: TextStyles.labelMediumMedium),
              if (content.length > 15)
                Expanded(
                  child: MyTooltip(
                    content: content,
                    child: Text(
                      '${content.substring(0, 15)}...',
                      style: TextStyles.labelMediumMedium.copyWith(decoration: TextDecoration.underline),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Text(
                    content,
                    style: TextStyles.labelMediumMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          )
        : null;
  }
}
