import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentItem extends StatelessWidget {
  final EdgeInsets padding;
  final String profileImageUrl;
  final String nickName;
  final String createdAt;
  final bool isWriter;
  final String contents;
  final bool isLiked;
  final String likeCount;
  final bool canReply;
  final void Function() onTappedProfile;
  final void Function()? onTappedReply;
  final void Function() onTappedLikeButton;

  const CommentItem({
    super.key,
    required this.padding,
    required this.profileImageUrl,
    required this.nickName,
    required this.createdAt,
    required this.isWriter,
    required this.contents,
    required this.isLiked,
    required this.likeCount,
    this.canReply = false,
    required this.onTappedProfile,
    this.onTappedReply,
    required this.onTappedLikeButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThrottleButton(
                onTap: () {
                  onTappedProfile.call();
                },
                child: MyNetworkImage(
                  imageUrl: profileImageUrl,
                  height: 36,
                  width: 36,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nickName,
                          style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.black),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          createdAt,
                          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
                        ),
                        const SizedBox(width: 6),
                        if (isWriter) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorStyles.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '작성자',
                              style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contents,
                      style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                    ),
                    if (canReply) ...[
                      const SizedBox(height: 6),
                      ThrottleButton(
                        onTap: () {
                          onTappedReply?.call();
                        },
                        child: Text(
                          '답글 달기',
                          style: TextStyles.captionSmallSemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ThrottleButton(
                onTap: () {
                  onTappedLikeButton.call();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    children: [
                      if (isLiked)
                        SvgPicture.asset(
                          'assets/icons/like_fill.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                        )
                      else
                        SvgPicture.asset(
                          'assets/icons/like.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        likeCount,
                        style: TextStyles.captionSmallMedium.copyWith(
                          color: !isLiked ? ColorStyles.gray50 : ColorStyles.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
