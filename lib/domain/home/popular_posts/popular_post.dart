import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post_presenter.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PopularPostWidget extends StatelessWidget {
  const PopularPostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ThrottleButton(
      onTap: () {
        ScreenNavigator.showPostDetail(context: context, id: context.read<PopularPostPresenter>().id);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
        color: ColorStyles.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    final title = context.select<PopularPostPresenter, String>((presenter) => presenter.title);
                    return Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.title01SemiBold,
                    );
                  }),
                  const SizedBox(height: 4),
                  Builder(builder: (context) {
                    final contents = context.select<PopularPostPresenter, String>((presenter) => presenter.contents);
                    return Text(
                      contents,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                    );
                  }),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/like.svg',
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                        ),
                        Builder(builder: (context) {
                          final likeCount = context.select<PopularPostPresenter, int>((presenter) => presenter.likeCount);
                          return Text(
                            likeCount > 9999 ? '9999+' : '$likeCount',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.gray70,
                            ),
                          );
                        }),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/message.svg',
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                        ),
                        Builder(builder: (context) {
                          final commentsCount = context.select<PopularPostPresenter, int>(
                            (presenter) => presenter.commentsCount,
                          );
                          return Text(
                            commentsCount > 9999 ? '9999+' : '$commentsCount',
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: ColorStyles.gray70,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Builder(builder: (context) {
                        final subject = context.select<PopularPostPresenter, PostSubject>((presenter) => presenter.subject);
                        return Text(
                          subject.toString(),
                          style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                        );
                      }),
                      Builder(builder: (context) {
                        final createdAt = context.select<PopularPostPresenter, String>((presenter) => presenter.createdAt);
                        return Text(
                          createdAt,
                          style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                        );
                      }),
                      Builder(builder: (context) {
                        final viewCount = context.select<PopularPostPresenter, int>((presenter) => presenter.viewCount);
                        return Text(
                          viewCount > 9999 ? '조회 9999+' : '조회 $viewCount',
                          style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                        );
                      }),
                      Builder(builder: (context) {
                        final nickName = context.select<PopularPostPresenter, String>((presenter) => presenter.nickName);
                        return Text(
                          nickName,
                          style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                        );
                      }),
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
            Builder(builder: (context) {
              final imageUrl = context.select<PopularPostPresenter, String?>((presenter) => presenter.imageUrl);
              if (imageUrl != null) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: MyNetworkImage(
                    imageUrl: imageUrl,
                    height: 80,
                    width: 80,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
