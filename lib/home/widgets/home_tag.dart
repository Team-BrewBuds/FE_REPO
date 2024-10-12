import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TagKind { beans, question, normal, caffe, worry, information }

class HomeTag extends StatelessWidget {
  final TagKind kind;

  const HomeTag({
    super.key,
    required this.kind,
  });

  String get _iconPath => switch (kind) {
    TagKind.beans => 'assets/icons/coffee_bean.svg',
    TagKind.question => 'assets/icons/home_question.svg',
    TagKind.normal => 'assets/icons/home_normal.svg',
    TagKind.caffe => 'assets/icons/home_caffe.svg',
    TagKind.worry => 'assets/icons/home_worry.svg',
    TagKind.information => 'assets/icons/home_information.svg',
  };

  String get _text => switch (kind) {
    TagKind.beans => '원두',
    TagKind.question => '질문',
    TagKind.normal => '일반',
    TagKind.caffe => '카페',
    TagKind.worry => '고민',
    TagKind.information => '정보',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SvgPicture.asset(
            _iconPath,
            height: 12,
            width: 12,
            colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 2),
          Text(_text, style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }
}
