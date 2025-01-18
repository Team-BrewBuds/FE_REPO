import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PopularPost extends StatelessWidget {
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
  final String? imageUri;
  final void Function() onTap;
  final void Function() onTapLikeButton;
  final void Function() onTapCommentButton;

  const PopularPost({
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
    this.imageUri,
    required this.onTap,
    required this.onTapLikeButton,
    required this.onTapCommentButton,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
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
                  style: TextStyles.bodyNarrowRegular,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButtonFactory.buildHorizontalButtonWithIconWidget(
                      iconWidget: SvgPicture.asset(
                        isLiked ? 'assets/icons/like_fill.svg' : 'assets/icons/like.svg',
                        height: 16,
                        width: 16,
                        colorFilter: ColorFilter.mode(
                          isLiked ? ColorStyles.red : ColorStyles.gray70,
                          BlendMode.srcIn,
                        ),
                      ),
                      text: likeCount,
                      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                      iconAlign: ButtonIconAlign.left,
                      onTapped: () => onTapLikeButton,
                    ),
                    const SizedBox(width: 4),
                    IconButtonFactory.buildHorizontalButtonWithIconWidget(
                      iconWidget: SvgPicture.asset(
                        hasComment ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
                        height: 16,
                        width: 16,
                        colorFilter: ColorFilter.mode(
                          hasComment ? ColorStyles.red : ColorStyles.gray70,
                          BlendMode.srcIn,
                        ),
                      ),
                      text: commentsCount,
                      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                      iconAlign: ButtonIconAlign.left,
                      onTapped: () => onTapCommentButton,
                    ),
                  ],
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
          if (imageUri != null) ...[
            const SizedBox(width: 8),
            Image.network(
              imageUri!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 80,
                width: 80,
                color: const Color(0xFFd9d9d9),
              ),
            )
          ]
        ],
      ),
    );
  }
}
