import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/factory/tag_factory.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentItem extends StatelessWidget {
  final EdgeInsets padding;
  final String profileImageUri;
  final String nickName;
  final String createdAt;
  final bool isWriter;
  final String contents;
  final bool isLiked;
  final String likeCount;
  final bool canReply;
  final void Function()? onTappedReply;
  final void Function() onTappedLikeButton;

  const CommentItem({
    super.key,
    required this.padding,
    required this.profileImageUri,
    required this.nickName,
    required this.createdAt,
    required this.isWriter,
    required this.contents,
    required this.isLiked,
    required this.likeCount,
    this.canReply = false,
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
              Container(
                height: 36,
                width: 36,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Color(0xffD9D9D9),
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  profileImageUri,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, trace) => Container(),
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
                        if (true) ...[
                          InkWell(
                            onTap: () {

                            },
                            child: Container(
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
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contents,
                      style: TextStyles.bodyNarrowRegular,
                    ),
                    if (canReply) ...[
                      const SizedBox(height: 6),
                      InkWell(
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
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/like.svg',
                      colorFilter: ColorFilter.mode(
                        !isLiked ? ColorStyles.gray50 : ColorStyles.red,
                        BlendMode.srcIn,
                      ),
                      height: 18,
                      width: 18,
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
            ],
          ),
        ),
      ],
    );
  }
}
