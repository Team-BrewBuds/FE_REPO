import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/factory/tag_factory.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
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
                          style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray50),
                        ),
                        const SizedBox(width: 6),
                        isWriter
                            ? TagFactory.buildTag(
                                icon: SvgPicture.asset('assets/icons/union.svg'),
                                text: '작성자',
                                style: TagStyle(
                                  size: TagSize.xSmall,
                                  iconAlign: TagIconAlign.left,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contents,
                      style: TextStyles.bodyRegular,
                    ),
                  ],
                ),
              ),
              IconButtonFactory.buildVerticalButtonWithIconWidget(
                iconWidget: SvgPicture.asset(
                  'assets/icons/like.svg',
                  colorFilter: ColorFilter.mode(
                    !isLiked ? ColorStyles.gray50 : ColorStyles.red,
                    BlendMode.srcIn,
                  ),
                ),
                text: likeCount,
                textStyle: TextStyles.captionSmallMedium.copyWith(
                  color: !isLiked ? ColorStyles.gray50 : ColorStyles.red,
                ),
                onTapped: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
