import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SuggestWord extends StatelessWidget {
  final String word;
  final String searchWord;

  const SuggestWord({
    super.key,
    required this.word,
    required this.searchWord,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.5),
      child: RichText(
        text: TextSpan(
          style: TextStyles.title01SemiBold.copyWith(
            color: ColorStyles.black,
            fontWeight: FontWeight.w400,
          ),
          children: _getSpans(
            word,
            searchWord,
            TextStyles.title01SemiBold.copyWith(
              color: ColorStyles.red,
            ),
          ),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord.isEmpty) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

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
