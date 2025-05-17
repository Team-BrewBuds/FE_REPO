import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/search/widgets/search_result/search_result_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PostResultsItem extends StatelessWidget {
  final String searchWord;

  const PostResultsItem({
    super.key,
    required this.searchWord,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => ScreenNavigator.showPostDetail(
        context: context,
        id: context.read<PostSearchResultPresenter>().id,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Builder(
                        builder: (context) {
                          final title = context.select<PostSearchResultPresenter, String>(
                            (presenter) => presenter.title,
                          );
                          return RichText(
                            text: TextSpan(
                              style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                              children: _getSpans(title, searchWord, TextStyles.title01Bold),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final contents = context.select<PostSearchResultPresenter, String>(
                            (presenter) => presenter.contents,
                          );
                          return RichText(
                            text: TextSpan(
                              style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                              children: _getSpans(
                                contents,
                                searchWord,
                                TextStyles.bodyNarrowRegular.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/like.svg',
                            height: 16,
                            width: 16,
                            colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                          ),
                          Builder(
                            builder: (context) {
                              final likeCount = context.select<PostSearchResultPresenter, int>(
                                (presenter) => presenter.likeCount,
                              );
                              return Text(
                                '${likeCount > 9999 ? '9999+' : likeCount}',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/icons/message.svg',
                            height: 16,
                            width: 16,
                            colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                          ),
                          Builder(
                            builder: (context) {
                              final commentsCount = context.select<PostSearchResultPresenter, int>(
                                (presenter) => presenter.commentsCount,
                              );
                              return Text(
                                '${commentsCount > 9999 ? '9999+' : commentsCount}',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              final subject = context.select<PostSearchResultPresenter, String>(
                                (presenter) => presenter.subject,
                              );
                              return Text(
                                subject,
                                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Container(width: 1, height: 10, color: ColorStyles.gray30),
                          const SizedBox(width: 4),
                          Builder(
                            builder: (context) {
                              final createdAt = context.select<PostSearchResultPresenter, String>(
                                (presenter) => presenter.createdAt,
                              );
                              return Text(
                                createdAt,
                                style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Container(width: 1, height: 10, color: ColorStyles.gray30),
                          const SizedBox(width: 4),
                          Builder(
                            builder: (context) {
                              final hits = context.select<PostSearchResultPresenter, int>(
                                (presenter) => presenter.hits,
                              );
                              return Text(
                                '조회 ${hits > 9999 ? '9999+' : hits}',
                                style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          Container(width: 1, height: 10, color: ColorStyles.gray30),
                          const SizedBox(width: 4),
                          Builder(
                            builder: (context) {
                              final writerNickName = context.select<PostSearchResultPresenter, String>(
                                (presenter) => presenter.writerNickName,
                              );
                              return Text(
                                writerNickName,
                                style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final imageUrl = context.select<PostSearchResultPresenter, String>(
                      (presenter) => presenter.imageUrl,
                    );
                    if (imageUrl.isNotEmpty) {
                      return MyNetworkImage(imageUrl: imageUrl, height: 64, width: 64);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);

      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: textStyle));

      spanBoundary = endIndex;
    } while (spanBoundary < text.length);

    return spans;
  }
}
