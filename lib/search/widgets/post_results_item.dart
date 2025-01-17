import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostResultsItem extends StatelessWidget {
  final String _title;
  final String _contents;
  final String _searchWord;
  final int _likeCount;
  final int _commentsCount;
  final String _subject;
  final String _createdAt;
  final int _hits;
  final String _writerNickName;
  final String _imageUri;

  const PostResultsItem({
    super.key,
    required String title,
    required String contents,
    required String searchWord,
    required int likeCount,
    required int commentsCount,
    required String subject,
    required String createdAt,
    required int hits,
    required String writerNickName,
    required String imageUri,
  })  : _title = title,
        _contents = contents,
        _searchWord = searchWord,
        _likeCount = likeCount,
        _commentsCount = commentsCount,
        _subject = subject,
        _createdAt = createdAt,
        _hits = hits,
        _writerNickName = writerNickName,
        _imageUri = imageUri;

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
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                      children: _getSpans(_title, _searchWord, TextStyles.title01Bold),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                      children: _getSpans(
                        _contents,
                        _searchWord,
                        TextStyles.bodyNarrowRegular.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      Text(
                        '${_likeCount > 9999 ? '9999+' : _likeCount}',
                        style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/icons/message.svg',
                        height: 16,
                        width: 16,
                        colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                      ),
                      Text(
                        '${_commentsCount > 9999 ? '9999+' : _likeCount}',
                        style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _subject,
                        style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray70),
                      ),
                      const SizedBox(width: 4),
                      Container(width: 1, height: 10, color: ColorStyles.gray30),
                      const SizedBox(width: 4),
                      Text(
                        _createdAt,
                        style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                      ),
                      const SizedBox(width: 4),
                      Container(width: 1, height: 10, color: ColorStyles.gray30),
                      const SizedBox(width: 4),
                      Text(
                        '$_hits',
                        style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                      ),
                      const SizedBox(width: 4),
                      Container(width: 1, height: 10, color: ColorStyles.gray30),
                      const SizedBox(width: 4),
                      Text(
                        _writerNickName,
                        style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray70),
                      ),
                      const Spacer(),
                    ],
                  ),
                ]),
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
