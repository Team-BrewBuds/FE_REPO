import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatefulWidget {
  final CommentItem commentItem;
  final bool hasSubComments;
  final int subCommentsLength;
  final CommentItem Function(int index)? subCommentsBuilder;

  const CommentsWidget({
    super.key,
    required this.commentItem,
    this.subCommentsLength = 0,
    this.subCommentsBuilder,
  }) : hasSubComments = subCommentsLength != 0;

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.commentItem,
        widget.hasSubComments
            ? Container(
                padding: EdgeInsets.only(left: 60, right: 16),
                color: _isExpanded ? ColorStyles.gray10 : ColorStyles.white,
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.zero,
                  tilePadding: EdgeInsets.zero,
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  trailing: SizedBox.shrink(),
                  shape: Border(),
                  title: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 1,
                        color: ColorStyles.gray40,
                      ),
                      Text(
                        !_isExpanded ? '답글 ${widget.subCommentsLength}개 더보기' : '답글 ${widget.subCommentsLength}개 접기',
                        style: TextStyles.captionSmallSemiBold.copyWith(
                          color: ColorStyles.gray40,
                        ),
                      ),
                    ],
                  ),
                  children: List<Widget>.generate(
                    widget.subCommentsLength,
                    widget.subCommentsBuilder ?? (_) => Container(),
                  ),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      _isExpanded = isExpanded;
                    });
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
