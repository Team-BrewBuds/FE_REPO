part of 'feed.dart';

class FeedPost extends StatelessWidget {
  final String _title;
  final String _bodyText;
  final int _bodyTextMaxLines;
  final void Function() _onTapMoreButton;

  const FeedPost({
    super.key,
    required String title,
    required String bodyText,
    required int bodyTextMaxLines,
    required void Function() onTapMoreButton,
  })  : _title = title,
        _bodyText = bodyText,
        _bodyTextMaxLines = bodyTextMaxLines,
        _onTapMoreButton = onTapMoreButton;

  @override
  Widget build(BuildContext context) {
    final isOverFlow = _calcOverFlow(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTag(kind: TagKind.beans),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            _title,
            style: TextStyles.titleMediumSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            _bodyText,
            style: TextStyles.labelMediumRegular,
            maxLines: _bodyTextMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isOverFlow ? 8 : 0),
          isOverFlow
              ? TextButtonFactory.build(
                  onTapped: _onTapMoreButton,
                  style: TextButtonStyle(size: TextButtonSize.small),
                  text: '더보기',
                )
              : Container(),
        ],
      ),
    );
  }

  bool _calcOverFlow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: _bodyText, style: TextStyles.labelMediumRegular),
      maxLines: _bodyTextMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
