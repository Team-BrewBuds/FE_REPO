import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/follow_list/follow_user_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowUserWidget extends StatelessWidget {
  final bool isMyFollow;

  const FollowUserWidget({
    super.key,
    this.isMyFollow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Builder(builder: (context) {
            final imageUrl = context.select<FollowUserPresenter, String>((presenter) => presenter.imageUrl);
            return MyNetworkImage(
              imageUrl: imageUrl,
              height: 48,
              width: 48,
              shape: BoxShape.circle,
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            child: Builder(builder: (context) {
              final nickname = context.select<FollowUserPresenter, String>((presenter) => presenter.nickname);
              return Text(nickname, style: TextStyles.labelMediumMedium);
            }),
          ),
          const SizedBox(width: 8),
          FutureButton(
            onTap: () => context.read<FollowUserPresenter>().follow(),
            child: Builder(builder: (context) {
              final isFollow = context.select<FollowUserPresenter, bool>((presenter) => presenter.isFollow);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: isFollow ? ColorStyles.gray30 : ColorStyles.red,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Text(
                  isFollow ? isMyFollow ? '팔로우 취소' : '팔로워' : '팔로우',
                  style: TextStyles.labelSmallMedium.copyWith(
                    color: isFollow ? ColorStyles.black : ColorStyles.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
