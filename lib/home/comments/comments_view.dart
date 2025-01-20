import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/home/comments/comments_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    final maxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final bool _keyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
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
                    height: _keyboardVisible ? maxHeight : _height,
                    padding: MediaQuery.of(context).viewInsets,
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
                            child: presenter.comments.isNotEmpty
                                ? SingleChildScrollView(
                                    child: buildComments(presenter),
                                  )
                                : const Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '아직 댓글이 없어요',
                                          style: TextStyles.title02SemiBold,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '댓글을 남겨보세요.',
                                          style: TextStyles.captionSmallMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration:
                                const BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: ColorStyles.gray40))),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorStyles.gray40),
                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                color: ColorStyles.white,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Visibility(
                                    visible: presenter.isReply,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 14, top: 16, bottom: 16, right: 14),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                        color: ColorStyles.gray10,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${presenter.replyAuthor?.nickname}님에게 답글 남기는 중',
                                            style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              presenter.cancelReply();
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/x_round.svg',
                                              height: 24,
                                              width: 24,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    controller: _textEditingController,
                                    maxLines: null,
                                    cursorHeight: 16,
                                    cursorWidth: 1,
                                    cursorColor: ColorStyles.black,
                                    style: TextStyles.labelSmallMedium,
                                    decoration: InputDecoration(
                                      hintText:
                                          '${presenter.isReply ? presenter.replyAuthor?.nickname : presenter.author.nickname} 님에게 댓글 추가..',
                                      hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.zero,
                                        gapPadding: 8,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.zero,
                                        gapPadding: 8,
                                      ),
                                      contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
                                        child:  InkWell(
                                          onTap: () {

                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: ColorStyles.black,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '전송',
                                              style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      constraints: const BoxConstraints(maxHeight: 112)
                                    ),
                                  ),
                                ],
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
          return Column(
            children: [
              _buildSlidableComment(
                CommentItem(
                  padding: comment.reComments.isEmpty
                      ? const EdgeInsets.all(16)
                      : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                  profileImageUri: comment.author.profileImageUri,
                  nickName: comment.author.nickname,
                  createdAt: comment.createdAt,
                  isWriter: presenter.author.id == comment.author.id,
                  contents: comment.content,
                  isLiked: comment.isLiked,
                  likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                  canReply: true,
                  onTappedReply: () {
                    presenter.onTappedReply(comment.author);
                  },
                  onTappedLikeButton: () {},
                ),
              ),
              if (comment.reComments.isNotEmpty) ...[
                ReCommentsList(
                  reCommentsLength: comment.reComments.length,
                  reCommentsBuilder: (index) {
                    final reComment = comment.reComments[index];
                    return _buildSlidableComment(
                      CommentItem(
                        padding: const EdgeInsets.only(left: 60, right: 16, top: 12, bottom: 12),
                        profileImageUri: reComment.author.profileImageUri,
                        nickName: reComment.author.nickname,
                        createdAt: reComment.createdAt,
                        isWriter: presenter.author.id == comment.author.id,
                        contents: reComment.content,
                        isLiked: reComment.isLiked,
                        likeCount: '${reComment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                        onTappedLikeButton: () {},
                      ),
                    );
                  },
                )
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildSlidableComment(CommentItem commentItem) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                color: ColorStyles.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/delete.svg',
                      height: 32,
                      width: 32,
                      colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                    ),
                    Text(
                      '삭제하기',
                      style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                color: ColorStyles.gray30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/declaration.svg',
                      height: 32,
                      width: 32,
                      colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                    ),
                    Text(
                      '신고하기',
                      style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray70),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: commentItem,
    );
  }
}
