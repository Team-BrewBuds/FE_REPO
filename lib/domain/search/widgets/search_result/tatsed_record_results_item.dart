import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/search/widgets/search_result/search_result_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TastedRecordResultsItem extends StatelessWidget {
  final String searchWord;

  const TastedRecordResultsItem({
    super.key,
    required this.searchWord,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => ScreenNavigator.showTastedRecordDetail(
          context: context,
          id: context.read<TastedRecordSearchResultPresenter>().id,
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
                          final beanName = context.select<TastedRecordSearchResultPresenter, String>(
                            (presenter) => presenter.beanName,
                          );
                          return RichText(
                            text: TextSpan(
                              style: TextStyles.title01SemiBold.copyWith(
                                color: ColorStyles.black,
                                fontWeight: FontWeight.w400,
                              ),
                              children: _getSpans(beanName, searchWord, TextStyles.title01SemiBold),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/star_fill.svg',
                            height: 14,
                            width: 14,
                            colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                          ),
                          Builder(
                            builder: (context) {
                              final rating = context.select<TastedRecordSearchResultPresenter, double>(
                                (presenter) => presenter.rating,
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  '$rating',
                                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 2),
                          Container(width: 1, height: 10, color: ColorStyles.gray30),
                          const SizedBox(width: 2),
                          Builder(
                            builder: (context) {
                              final beanType = context.select<TastedRecordSearchResultPresenter, String>(
                                (presenter) => presenter.beanType,
                              );
                              return Text(
                                beanType,
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              );
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Builder(
                        builder: (context) {
                          final tasteList = context.select<TastedRecordSearchResultPresenter, List<String>>(
                            (presenter) => presenter.tasteList,
                          );
                          return Row(
                            spacing: 2,
                            children: tasteList.map(
                              (taste) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: ColorStyles.gray70, width: 0.8),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: Text(
                                      taste,
                                      style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final imageUrl = context.select<TastedRecordSearchResultPresenter, String>(
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
            Builder(
              builder: (context) {
                final contents = context.select<TastedRecordSearchResultPresenter, String>(
                  (presenter) => presenter.contents,
                );
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: ColorStyles.gray20,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        height: 18.2 / 14,
                        letterSpacing: -0.02,
                        color: ColorStyles.black,
                      ),
                      children: _getSpans(contents, searchWord, TextStyles.labelSmallSemiBold),
                    ),
                  ),
                );
              },
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
