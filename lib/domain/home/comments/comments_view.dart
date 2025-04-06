import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/home/comments/comments_presenter.dart';
import 'package:brew_buds/domain/report/report_screen.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class _CommentBottomSheetState extends State<CommentBottomSheet> with SnackBarMixin<CommentBottomSheet> {
  late final ScrollController _scrollController;
  late final TextEditingController _textEditingController;
  late double _height;

  bool _longAnimation = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _height = widget.minimumHeight;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CommentsPresenter>().initState();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
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
                height: keyboardVisible ? maxHeight : _height,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 12),
                    Container(height: 1, color: ColorStyles.gray10),
                    Expanded(
                      child: context.select<CommentsPresenter, bool>((presenter) => presenter.isLoading)
                          ? Container(
                              color: ColorStyles.gray20,
                              child: const Center(
                                child: CupertinoActivityIndicator(
                                  color: ColorStyles.gray70,
                                ),
                              ),
                            )
                          : Selector<CommentsPresenter, DefaultPage<Comment>>(
                              selector: (context, presenter) => presenter.page,
                              builder: (context, page, child) {
                                return page.results.isNotEmpty
                                    ? NotificationListener<ScrollNotification>(
                                        onNotification: (ScrollNotification scroll) {
                                          if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                                            context.read<CommentsPresenter>().fetchMoreData();
                                          }
                                          return false;
                                        },
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          clipBehavior: Clip.hardEdge,
                                          itemBuilder: (context, index) => _buildComment(page.results[index]),
                                          itemCount: page.results.length,
                                        ),
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
                                      );
                              },
                            ),
                    ),
                    Selector<CommentsPresenter, BottomTextFieldState>(
                      selector: (context, presenter) => presenter.bottomTextFieldState,
                      builder: (context, state, child) => _buildBottomTextField(
                        reCommentAuthorNickname: state.reCommentAuthorNickname,
                        authorNickname: state.authorNickname,
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

  Widget buildComments({required List<Comment> comments}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(
        comments.length,
        (index) => _buildComment(comments[index]),
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Column(
      children: [
        _buildSlidableComment(
          CommentItem(
            padding: comment.reComments.isEmpty
                ? const EdgeInsets.all(16)
                : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
            profileImageUrl: comment.author.profileImageUrl,
            nickName: comment.author.nickname,
            createdAt: comment.createdAt,
            isWriter: context.read<CommentsPresenter>().isMine(comment),
            contents: comment.content,
            isLiked: comment.isLiked,
            likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
            canReply: true,
            onTappedProfile: () {
              context.pop();
              pushToProfile(context: context, id: comment.author.id);
            },
            onTappedReply: () {
              context.read<CommentsPresenter>().onTappedReply(comment);
            },
            onTappedLikeButton: () {
              context.read<CommentsPresenter>().onTappedLikeButton(comment: comment);
            },
          ),
          isMine: context.read<CommentsPresenter>().isMine(comment),
          canDelete: context.read<CommentsPresenter>().canDelete(comment.author.id),
          onDelete: () {
            context.read<CommentsPresenter>().deleteComment(comment: comment);
          },
          onReport: () {
            pushToReportScreen(context, id: comment.id, type: 'comment').then(
              (value) {
                if (value != null) {
                  showSnackBar(message: value);
                }
              },
            );
          },
        ),
        if (comment.reComments.isNotEmpty) ...[
          ReCommentsList(
            reCommentsLength: comment.reComments.length,
            reCommentsBuilder: (index) {
              final reComment = comment.reComments[index];
              return _buildSlidableComment(
                CommentItem(
                  padding: const EdgeInsets.only(left: 60, right: 16, top: 12, bottom: 12),
                  profileImageUrl: reComment.author.profileImageUrl,
                  nickName: reComment.author.nickname,
                  createdAt: reComment.createdAt,
                  isWriter: context.read<CommentsPresenter>().isMine(reComment),
                  contents: reComment.content,
                  isLiked: reComment.isLiked,
                  likeCount: '${reComment.likeCount > 9999 ? '9999+' : reComment.likeCount}',
                  onTappedProfile: () {
                    context.pop();
                    pushToProfile(context: context, id: reComment.author.id);
                  },
                  onTappedLikeButton: () {
                    context.read<CommentsPresenter>().onTappedLikeButton(comment: reComment);
                  },
                ),
                isMine: context.read<CommentsPresenter>().isMine(reComment),
                canDelete: context.read<CommentsPresenter>().canDelete(reComment.author.id),
                onDelete: () {
                  context.read<CommentsPresenter>().deleteComment(comment: reComment);
                },
                onReport: () {
                  pushToReportScreen(context, id: reComment.id, type: 'comment').then(
                    (value) {
                      if (value != null) {
                        showSnackBar(message: value);
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSlidableComment(
    CommentItem commentItem, {
    required bool canDelete,
    Function()? onDelete,
    required bool isMine,
    Function()? onReport,
  }) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: !isMine && canDelete ? 0.4 : 0.2,
        motion: const DrawerMotion(),
        children: [
          if (canDelete)
            Expanded(
              child: ThrottleButton(
                onTap: () {
                  onDelete?.call();
                },
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
          if (!isMine)
            Expanded(
              child: ThrottleButton(
                onTap: () {
                  onReport?.call();
                },
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

  Widget _buildBottomTextField({String? reCommentAuthorNickname, required String authorNickname}) {
    final bool isReply = reCommentAuthorNickname != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: ColorStyles.gray40))),
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
              visible: isReply,
              child: Container(
                padding: const EdgeInsets.only(left: 14, top: 16, bottom: 16, right: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: ColorStyles.gray10,
                ),
                child: Row(
                  children: [
                    Text(
                      '$reCommentAuthorNickname님에게 답글 남기는 중',
                      style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                    ),
                    const Spacer(),
                    ThrottleButton(
                      onTap: () {
                        context.read<CommentsPresenter>().cancelReply();
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
                  hintText: isReply ? '답글 달기...' : '$authorNickname님에게 댓글 추가...',
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
                    child: ThrottleButton(
                      onTap: () {
                        context
                            .read<CommentsPresenter>()
                            .createNewComment(content: _textEditingController.text)
                            .then((value) {
                          _textEditingController.clear();
                        });
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
                  constraints: const BoxConstraints(maxHeight: 112)),
            ),
          ],
        ),
      ),
    );
  }
}
