part of 'feed.dart';

class FeedTastingRecord extends StatelessWidget {
  final String _imageUri;
  final String _gPA;
  final String _type;
  final String _name;
  final List<String> _tags;
  final String _bodyText;
  final void Function() _onTapMoreButton;

  const FeedTastingRecord({
    super.key,
    required String imageUri,
    required String gPA,
    required String type,
    required String name,
    required List<String> tags,
    required String bodyText,
    required void Function() onTapMoreButton,
  })  : _imageUri = imageUri,
        _gPA = gPA,
        _type = type,
        _name = name,
        _tags = tags,
        _bodyText = bodyText,
        _onTapMoreButton = onTapMoreButton;

  @override
  Widget build(BuildContext context) {
    final isOverFlow = _calcOverFlow(context);
    return Column(
      children: [
        TastingRecordCardView(
          image: Image.network(_imageUri, fit: BoxFit.cover),
          gPA: _gPA,
          type: _type,
          name: _name,
          tags: _tags,
        ),
        const SizedBox(height: 12, width: double.infinity),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _bodyText,
                style: TextStyles.labelMediumRegular,
                maxLines: 2,
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
        ),
      ],
    );
  }

  bool _calcOverFlow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: _bodyText, style: TextStyles.labelMediumRegular),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
