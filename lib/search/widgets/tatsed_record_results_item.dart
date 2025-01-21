import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastedRecordResultsItem extends StatelessWidget {
  final String _imageUri;
  final String _beanName;
  final String _beanType;
  final double _rating;
  final List<String> _tasteList;
  final String _contents;
  final String _searchWord;

  const TastedRecordResultsItem({
    super.key,
    required String imageUri,
    required String beanName,
    required String beanType,
    required double rating,
    required List<String> tasteList,
    required String contents,
    required String searchWord,
  })  : _imageUri = imageUri,
        _beanName = beanName,
        _beanType = beanType,
        _rating = rating,
        _tasteList = tasteList,
        _contents = contents,
        _searchWord = searchWord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _beanName,
                      style: TextStyles.title01Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/star_fill.svg',
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                        ),
                        Text(
                          '$_rating',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                        ),
                        const SizedBox(width: 2),
                        Container(width: 1, height: 10, color: ColorStyles.gray30),
                        const SizedBox(width: 2),
                        Text(
                          _beanType,
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: _tasteList
                          .map(
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
                          )
                          .separator(separatorWidget: const SizedBox(width: 2))
                          .toList(),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 64,
                width: 64,
                color: const Color(0xffd9d9d9),
                child: Image.network(
                  _imageUri,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          if (_contents.isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: ColorStyles.gray20,
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 18.2 / 14,
                    letterSpacing: -0.02,
                    color: ColorStyles.black,
                  ),
                  children: _getSpans(_contents, _searchWord, TextStyles.labelSmallSemiBold),
                ),
              ),
            ),
          ]
        ],
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
