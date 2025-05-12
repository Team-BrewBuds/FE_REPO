import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_refresh_control.dart';
import 'package:brew_buds/common/widgets/send_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/resizable_bottom_sheet_mixin.dart';
import 'package:brew_buds/domain/comments/comments_presenter.dart';
import 'package:brew_buds/domain/comments/presenter/comments_bottom_sheet_presenter.dart';
import 'package:brew_buds/domain/comments/widget/comment_presenter.dart';
import 'package:brew_buds/domain/comments/widget/comment_widget.dart';
import 'package:brew_buds/model/common/object_type.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CommentsBottomSheet extends StatefulWidget {
  final double maxHeight;
  final double initialHeight;

  const CommentsBottomSheet._({
    required this.maxHeight,
    required this.initialHeight,
  });

  static Widget buildWithPresenter({
    required double maxHeight,
    required double initialHeight,
    required ObjectType objectType,
    required int objectId,
    required User objectAuthor,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentsBottomSheetPresenter>(
          create: (_) => CommentsBottomSheetPresenter(objectType: objectType, objectId: objectId, author: objectAuthor),
        ),
        ChangeNotifierProvider<CommentsPresenter>(
          create: (_) => CommentsPresenter(objectType: objectType, objectId: objectId),
        ),
      ],
      child: CommentsBottomSheet._(maxHeight: maxHeight, initialHeight: initialHeight),
    );
  }

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet>
    with ResizableBottomSheetMixin<CommentsBottomSheet>, TickerProviderStateMixin {
  late final SlidableController slidableController;
  late final Throttle<void> paginationThrottle;
  late final TextEditingController _textEditingController;
  late final FocusNode _textEditingFocusNode;

  @override
  bool get hasTextField => true;

  @override
  double get initialHeight => widget.initialHeight;

  @override
  void initState() {
    slidableController = SlidableController(this);
    _textEditingController = TextEditingController();
    _textEditingFocusNode = FocusNode();
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<CommentsPresenter>().fetchMoreData();
  }

  @override
  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels > notification.metrics.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
    return false;
  }

  @override
  Widget buildBottomWidget(BuildContext context) {
    return Selector<CommentsBottomSheetPresenter, BottomTextFieldState>(
      selector: (context, presenter) => presenter.bottomTextFieldState,
      builder: (context, state, child) => _buildBottomTextField(
        reCommentAuthorNickname: state.reCommentAuthorNickname,
        authorNickname: state.authorNickname,
      ),
    );
  }

  @override
  List<Widget> buildContents(BuildContext context) {
    return [
      MyRefreshControl(onRefresh: () => context.read<CommentsPresenter>().onRefresh()),
      Builder(
        builder: (context) {
          final isLoading = context.select<CommentsPresenter, bool>((presenter) => presenter.isLoading);
          return isLoading
              ? SliverFillRemaining(
                  child: Container(
                    color: ColorStyles.gray20,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: ColorStyles.gray70,
                      ),
                    ),
                  ),
                )
              : Selector<CommentsPresenter, List<CommentPresenter>>(
                  selector: (context, presenter) => presenter.commentPresenters,
                  builder: (context, commentPresenters, child) {
                    final isMyObject = context.read<CommentsBottomSheetPresenter>().isMyObject();
                    final authorId = context.read<CommentsBottomSheetPresenter>().authorId;
                    return commentPresenters.isNotEmpty
                        ? SlidableAutoCloseBehavior(
                            child: SliverList.builder(
                              itemCount: commentPresenters.length,
                              itemBuilder: (context, index) {
                                final presenter = commentPresenters[index];
                                final isMyComment =
                                    context.read<CommentsBottomSheetPresenter>().isMine(presenter.author.id);
                                return ChangeNotifierProvider.value(
                                  value: presenter,
                                  child: CommentWidget(
                                    objectAuthorId: authorId,
                                    isMyObject: isMyObject,
                                    isMyComment: isMyComment,
                                    onTapReply: () {
                                      _textEditingFocusNode.requestFocus();
                                      context.read<CommentsBottomSheetPresenter>().selectedReply(
                                            presenter.author,
                                            presenter.id,
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : SliverFillRemaining(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Text(
                                    '아직 댓글이 없어요',
                                    style: TextStyles.title02SemiBold,
                                  ),
                                  Text(
                                    '댓글을 남겨보세요.',
                                    style: TextStyles.captionSmallMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                );
        },
      ),
    ];
  }

  Widget _buildBottomTextField({String? reCommentAuthorNickname, required String authorNickname}) {
    final bool isReply = reCommentAuthorNickname != null;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
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
                        context.read<CommentsBottomSheetPresenter>().cancelReply();
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
              focusNode: _textEditingFocusNode,
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
                      child: SendButton(
                        onTap: () => context.read<CommentsBottomSheetPresenter>().createNewComment(
                              content: _textEditingController.text,
                            ),
                        onError: (message) {
                          EventBus.instance.fire(MessageEvent(message: message));
                        },
                        onComplete: () {
                          _textEditingController.clear();
                        },
                      )),
                  constraints: const BoxConstraints(maxHeight: 112)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maximumHeight => widget.maxHeight;

  @override
  double get minimumHeight => widget.initialHeight;

  @override
  Widget buildTitle(context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
      child: Text(
        '댓글',
        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
