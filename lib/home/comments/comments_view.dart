import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/comments/comment_item.dart';
import 'package:brew_buds/home/comments/comments_presenter.dart';
import 'package:brew_buds/home/comments/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  late final TextEditingController _textEditingController;
  late double _height;

  bool _longAnimation = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _height = widget.minimumHeight;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CommentsPresenter>().initState();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
                child: Consumer<CommentsPresenter>(builder: (context, presenter, _) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        width: double.infinity,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
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
                            const SizedBox(height: 8),
                            Text('댓글', style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.black)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: buildComments(presenter),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 46),
                        decoration:
                            const BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: ColorStyles.gray40))),
                        child: TextField(
                          controller: _textEditingController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: '${presenter.author.nickname} 님에게 댓글 추가..',
                            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: ColorStyles.gray40),
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              gapPadding: 8,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: ColorStyles.gray40),
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              gapPadding: 8,
                            ),
                            contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                              child: ButtonFactory.buildOvalButton(
                                onTapped: () {
                                  if (_textEditingController.text.isNotEmpty) {
                                    presenter
                                        .createNewComment(content: _textEditingController.text);
                                  }
                                },
                                text: '전송',
                                style: OvalButtonStyle.fill(
                                  color: ColorStyles.black,
                                  textColor: ColorStyles.white,
                                  size: OvalButtonSize.large,
                                ),
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 63),
                            constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildComments(CommentsPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(
        presenter.comments.length,
        (index) {
          final comment = presenter.comments[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: CommentsWidget(
              commentItem: CommentItem(
                padding: comment.reComments.isEmpty
                    ? EdgeInsets.all(16)
                    : EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                profileImageUri: comment.author.profileImageUri,
                nickName: comment.author.nickname,
                createdAt: comment.createdAt,
                isWriter: presenter.author.id == comment.author.id,
                contents: comment.content,
                isLiked: comment.isLiked,
                likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                onTappedLikeButton: () {},
              ),
              subCommentsLength: comment.reComments.length,
              subCommentsBuilder: (int index) {
                final reComment = comment.reComments[index];
                return CommentItem(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  profileImageUri: reComment.author.profileImageUri,
                  nickName: reComment.author.nickname,
                  createdAt: reComment.createdAt,
                  isWriter: presenter.author.id == comment.author.id,
                  contents: reComment.content,
                  isLiked: reComment.isLiked,
                  likeCount: '${reComment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                  onTappedLikeButton: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
