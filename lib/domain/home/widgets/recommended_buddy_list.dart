import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/home/widgets/recomanded_buddy.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:flutter/material.dart';

class RecommendedBuddyList extends StatelessWidget {
  final RecommendedPage page;
  final Function(int index) onTappedFollowButton;

  const RecommendedBuddyList({
    super.key,
    required this.page,
    required this.onTappedFollowButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 318,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
      decoration: const BoxDecoration(
        color: ColorStyles.white,
        border: Border(
          top: BorderSide(width: 12, color: ColorStyles.gray20),
          bottom: BorderSide(width: 12, color: ColorStyles.gray20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(page.category.title(), style: TextStyles.title01SemiBold),
          Text(
            page.category.contents(),
            style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray70),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: List.generate(
                page.users.length,
                (index) {
                  final remandedBuddy = page.users[index];
                  return ThrottleButton(
                    onTap: () {
                      pushToProfile(context: context, id: remandedBuddy.id);
                    },
                    child: RecommendedBuddyWidget(
                      imageUrl: remandedBuddy.profileImageUrl,
                      nickName: remandedBuddy.nickname,
                      followCount: remandedBuddy.followerCount,
                      isFollowed: remandedBuddy.isFollow,
                      onTappedFollowButton: () {
                        onTappedFollowButton.call(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
