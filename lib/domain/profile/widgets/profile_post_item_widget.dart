import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePostItemWidget extends StatelessWidget {
  final String title;
  final String author;
  final String createdAt;
  final PostSubject subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black70),
                child: Row(
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: SvgPicture.asset(
                        subject.iconPath,
                        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(subject.toString(), style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white)),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyles.title01SemiBold,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                author,
                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
              ),
              const SizedBox(width: 4),
              Container(width: 1, height: 10, color: ColorStyles.gray30),
              const SizedBox(width: 4),
              Text(
                createdAt,
                style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  const ProfilePostItemWidget({
    super.key,
    required this.title,
    required this.author,
    required this.createdAt,
    required this.subject,
  });
}
