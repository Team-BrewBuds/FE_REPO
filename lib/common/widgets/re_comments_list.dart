import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:flutter/material.dart';

class ReCommentsList extends StatefulWidget {
  final int reCommentsLength;
  final Widget Function(int index)? reCommentsBuilder;

  const ReCommentsList({
    super.key,
    this.reCommentsLength = 0,
    this.reCommentsBuilder,
  });

  @override
  State<ReCommentsList> createState() => _ReCommentsListState();
}

class _ReCommentsListState extends State<ReCommentsList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isExpanded ? ColorStyles.gray10 : ColorStyles.white,
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        tilePadding: const EdgeInsets.only(left: 60),
        dense: true,
        visualDensity: const VisualDensity(vertical: -4),
        trailing: const SizedBox.shrink(),
        shape: const Border(),
        title: Row(
          children: [
            Container(
              width: 18,
              height: 1,
              color: ColorStyles.gray40,
            ),
            Text(
              !_isExpanded ? '답글 ${widget.reCommentsLength}개 더보기' : '답글 ${widget.reCommentsLength}개 접기',
              style: TextStyles.captionSmallSemiBold.copyWith(
                color: ColorStyles.gray40,
              ),
            ),
          ],
        ),
        children: List<Widget>.generate(
          widget.reCommentsLength,
          widget.reCommentsBuilder ?? (_) => Container(),
        ),
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
      ),
    );
  }
}
