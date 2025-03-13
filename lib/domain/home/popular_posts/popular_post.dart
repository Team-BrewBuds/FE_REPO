import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopularPostWidget extends StatelessWidget {
  final String title;
  final String bodyText;
  final String likeCount;
  final bool isLiked;
  final String commentsCount;
  final bool hasComment;
  final String tag;
  final String writingTime;
  final String hitsCount;
  final String nickName;
  final String? imageUrl;

  const PopularPostWidget({
    super.key,
    required this.title,
    required this.bodyText,
    required this.likeCount,
    required this.isLiked,
    required this.commentsCount,
    required this.hasComment,
    required this.tag,
    required this.writingTime,
    required this.hitsCount,
    required this.nickName,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 4),
              Text(
                bodyText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      isLiked ? 'assets/icons/like_fill.svg' : 'assets/icons/like.svg',
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(
                        isLiked ? ColorStyles.red : ColorStyles.gray70,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(likeCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      hasComment ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
                      height: 16,
                      width: 16,
                      colorFilter: ColorFilter.mode(
                        hasComment ? ColorStyles.red : ColorStyles.gray70,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(commentsCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    tag,
                    style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                  ),
                  Text(
                    writingTime,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                  Text(
                    hitsCount,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                  Text(
                    nickName,
                    style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                  ),
                ]
                    .separator(
                      separatorWidget: Container(
                        width: 1,
                        height: 10,
                        color: ColorStyles.gray30,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        if (imageUrl != null) ...[
          const SizedBox(width: 8),
          MyNetworkImage(
            imageUrl: imageUrl!,
            height: 80,
            width: 80,
            color: const Color(0xffD9D9D9),
          ),
        ]
      ],
    );
  }
}
