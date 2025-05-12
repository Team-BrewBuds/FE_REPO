import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/profile_image.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/search/widgets/search_result/search_result_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuddyResultsItem extends StatelessWidget {
  const BuddyResultsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => ScreenNavigator.showProfile(context: context, id: context.read<BuddySearchResultPresenter>().id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        color: Colors.transparent,
        child: Row(
          children: [
            Builder(
              builder: (context) {
                final imageUrl = context.select<BuddySearchResultPresenter, String>(
                  (presenter) => presenter.profileImageUrl,
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ProfileImage(
                    imageUrl: imageUrl,
                    height: 40,
                    width: 40,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Builder(
                    builder: (context) {
                      final nickname = context.select<BuddySearchResultPresenter, String>(
                        (presenter) => presenter.nickname,
                      );
                      return Text(
                        nickname,
                        style: TextStyles.labelMediumMedium,
                      );
                    },
                  ),
                  Row(
                    children: [
                      Builder(builder: (context) {
                        final followerCount = context.select<BuddySearchResultPresenter, int>(
                          (presenter) => presenter.followerCount,
                        );
                        return Text(
                          '팔로워 $followerCount',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                        );
                      }),
                      const SizedBox(width: 4),
                      Container(width: 1, height: 10, color: ColorStyles.gray30),
                      const SizedBox(width: 4),
                      Builder(builder: (context) {
                        final tastedRecordsCount = context.select<BuddySearchResultPresenter, int>(
                          (presenter) => presenter.tastedRecordsCount,
                        );
                        return Text(
                          '시음기록 $tastedRecordsCount',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                        );
                      }),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
