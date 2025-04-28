import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddies_presenter.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddy.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddy_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendedBuddiesWidget extends StatelessWidget {
  const RecommendedBuddiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 24),
      decoration: const BoxDecoration(
        color: ColorStyles.white,
        border: Border(
          top: BorderSide(width: 12, color: ColorStyles.gray20),
          bottom: BorderSide(width: 12, color: ColorStyles.gray20),
        ),
      ),
      child: Builder(builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) {
              final title = context.select<RecommendedBuddiesPresenter, String>(
                (presenter) => presenter.title,
              );
              return Text(title, style: TextStyles.title01SemiBold);
            }),
            Builder(builder: (context) {
              final contents = context.select<RecommendedBuddiesPresenter, String>(
                (presenter) => presenter.contents,
              );
              return Text(
                contents,
                style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray70),
              );
            }),
            const SizedBox(height: 16),
            Builder(builder: (context) {
              final presenters = context.select<RecommendedBuddiesPresenter, List<RecommendedBuddyPresenter>>(
                (presenter) => presenter.presenters,
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: List.generate(
                    presenters.length,
                    (index) {
                      final presenter = presenters[index];
                      return ChangeNotifierProvider.value(
                        value: presenter,
                        child: ThrottleButton(
                          onTap: () {
                            ScreenNavigator.pushToProfile(context: context, id: presenter.user.id);
                          },
                          child: const RecommendedBuddyWidget(),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
