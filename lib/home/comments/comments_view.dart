import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/tag_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/comments/comments_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommentBottomSheet extends StatefulWidget {
  final double minimumHeight;

  const CommentBottomSheet({
    super.key,
    required this.minimumHeight,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late double _height;

  bool _longAnimation = false;

  @override
  void initState() {
    super.initState();
    _height = widget.minimumHeight;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CommentsPresenter>().initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                final maxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
                if (_height > maxHeight * 0.85) {
                  setState(() {
                    _height = maxHeight;
                  });
                } else if (_height > maxHeight * 0.3) {
                  setState(() {
                    _height = widget.minimumHeight;
                  });
                } else {
                  context.pop();
                }
              },
              onVerticalDragUpdate: (details) {
                final double? delta = details.primaryDelta;
                setState(() {
                  if (delta != null) {
                    _height = _height - delta;
                  }
                });
              },
              child: AnimatedContainer(
                curve: Curves.bounceOut,
                onEnd: () {
                  if (_longAnimation) {
                    setState(() {
                      _longAnimation = false;
                    });
                  }
                },
                duration: const Duration(milliseconds: 100),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: ColorStyles.gray40)),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: _height,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: ColorStyles.gray70,
                              borderRadius: BorderRadius.all(Radius.circular(21)),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('댓글', style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.black)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffD9D9D9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                      '',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, _, trace) => Container(),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildCommentItem(),
                                        ListTileTheme(
                                          contentPadding: EdgeInsets.all(0),
                                          minVerticalPadding: 0,
                                          child: ExpansionTile(
                                            trailing: SizedBox(),
                                            title: Row(
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 1,
                                                  color: ColorStyles.gray40,
                                                ),
                                                Text(
                                                  '답글 12개 더보기',
                                                  style: TextStyles.captionSmallSemiBold.copyWith(
                                                    color: ColorStyles.gray40,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                              buildCommentItem(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 46),
                      decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: ColorStyles.gray40))),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '커피의 신 님에게 댓글 추가..',
                          hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorStyles.gray40),
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            gapPadding: 8,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorStyles.gray40),
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            gapPadding: 8,
                          ),
                          contentPadding: EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                            child: ButtonFactory.buildOvalButton(
                              onTapped: () {},
                              text: '전송',
                              style: OvalButtonStyle.fill(
                                color: ColorStyles.black,
                                textColor: ColorStyles.white,
                                size: OvalButtonSize.large,
                              ),
                            ),
                          ),
                          suffixIconConstraints: BoxConstraints(maxHeight: 48, maxWidth: 63),
                          constraints: BoxConstraints(minHeight: 48, maxHeight: 112),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCommentItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ashedpotatom',
              style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.black),
            ),
            SizedBox(width: 4),
            Text(
              '1시간 전',
              style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray50),
            ),
            SizedBox(width: 6),
            TagFactory.buildTag(
              icon: SvgPicture.asset('assets/icons/union.svg'),
              text: '작성자',
              style: TagStyle(
                size: TagSize.xSmall,
                iconAlign: TagIconAlign.left,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          '야근 너무 싫어야근 너무 싫어야근 너무 싫어야근 너무 싫어야근 너무 싫어야근 너무 싫어',
          style: TextStyles.bodyRegular,
        ),
        SizedBox(height: 6),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '답글 달기',
            style: TextStyles.captionSmallSemiBold.copyWith(color: ColorStyles.gray60),
          ),
        ),
      ],
    );
  }
}
