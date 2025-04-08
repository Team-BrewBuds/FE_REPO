import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/home/widgets/feed_widget.dart';
import 'package:flutter/material.dart';

final class PostFeedWidget extends FeedWidget {
  final String title;
  final String body;
  final String subjectText;
  final Widget subjectIcon;
  final String tag;
  final Widget? child;

  const PostFeedWidget({
    super.key,
    required super.id,
    required super.writerId,
    required super.writerThumbnailUrl,
    required super.writerNickName,
    required super.writingTime,
    required super.hits,
    required super.isFollowed,
    required super.onTapProfile,
    required super.onTapFollowButton,
    required super.isLiked,
    required super.likeCount,
    required super.commentsCount,
    required super.isSaved,
    required super.onTapLikeButton,
    required super.onTapCommentsButton,
    required super.onTapSaveButton,
    required this.title,
    required this.body,
    required this.subjectText,
    required this.subjectIcon,
    required this.tag,
    this.child,
  });

  @override
  Widget buildBody(BuildContext context) {
    final child = this.child;
    if (child != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          _buildTextBody(context, bodyMaxLines: 2),
        ],
      );
    } else {
      return _buildTextBody(context);
    }
  }

  Widget _buildTextBody(BuildContext context, {int bodyMaxLines = 5}) {
    final isOverFlow = _calcOverFlow(context, bodyMaxLines);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_buildSubject(), const Spacer()],
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            title,
            style: TextStyles.title01SemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            body,
            style: TextStyles.bodyRegular,
            maxLines: bodyMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isOverFlow ? 8 : 0),
          if (isOverFlow)
            GestureDetector(
              onTap: () {
                showPostDetail(context: context, id: id).then((result) {
                  if (result != null) {
                    showSnackBar(context, message: result);
                  }
                });
              },
              child: Text(
                '더보기',
                style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.gray50),
              ),
            ),
          if (tag.isNotEmpty) ...[
            const SizedBox(height: 12, width: double.infinity),
            Text(
              tag.replaceAll(',', '#').startsWith('#')
                  ? tag.replaceAll(',', '#')
                  : '#${tag.replaceAll(',', '#')}',
              style: TextStyles.labelSmallMedium.copyWith(
                color: ColorStyles.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubject() {
    return Container(
      padding: const EdgeInsets.all(5.5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SizedBox(height: 12, width: 12, child: subjectIcon),
          const SizedBox(width: 2),
          Text(subjectText, style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }

  bool _calcOverFlow(BuildContext context, int maxLines) {
    final width = MediaQuery.of(context).size.width - 32;
    final TextPainter bodyTextPainter = TextPainter(
      text: TextSpan(text: body, style: TextStyles.bodyRegular),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);

    return bodyTextPainter.didExceedMaxLines;
  }
}
