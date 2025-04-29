import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/like_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/save_button.dart';
import 'package:brew_buds/common/widgets/send_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/comments/comments_presenter.dart';
import 'package:brew_buds/domain/comments/widget/comment_presenter.dart';
import 'package:brew_buds/domain/comments/widget/comment_widget.dart';
import 'package:brew_buds/domain/detail/tasted_record/tasted_record_presenter.dart';
import 'package:brew_buds/domain/detail/widget/bean_detail.dart';
import 'package:brew_buds/domain/detail/widget/taste_graph.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum TastedRecordDetailAction {
  update,
  delete,
  block,
  report;
}

class TastedRecordDetailView extends StatefulWidget {
  const TastedRecordDetailView({super.key});

  static Widget buildWithPresenter({required int id}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TastedRecordPresenter(id: id)),
        ChangeNotifierProvider(
          create: (_) => CommentsPresenter(objectType: ObjectType.tastingRecord, objectId: id),
        ),
      ],
      child: const TastedRecordDetailView(),
    );
  }

  @override
  State<TastedRecordDetailView> createState() => _TastedRecordDetailViewState();
}

class _TastedRecordDetailViewState extends State<TastedRecordDetailView>
    with CenterDialogMixin<TastedRecordDetailView> {
  late final Throttle paginationThrottle;
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;
  int currentIndex = 0;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    paginationThrottle.cancel();
    super.dispose();
  }

  _fetchMoreData() {
    if (context.mounted) {
      context.read<CommentsPresenter>().fetchMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TastedRecordPresenter, bool>(
        selector: (context, presenter) => presenter.isEmpty,
        builder: (context, isEmpty, child) {
          if (isEmpty) {
            //수정필요
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showEmptyDialog().then((value) => context.pop());
            });
          }
          return ThrottleButton(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: _buildAppbar(),
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent - 300) {
                    paginationThrottle.setValue(null);
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    Selector<TastedRecordPresenter, List<String>>(
                      selector: (context, presenter) => presenter.imageUrlList,
                      builder: (context, imageUrlList, child) => SliverToBoxAdapter(
                        child: _buildImageListView(imageUrlList: imageUrlList),
                      ),
                    ),
                    Selector<TastedRecordPresenter, BottomButtonInfo>(
                      selector: (context, presenter) => presenter.bottomButtonInfo,
                      builder: (context, bottomButtonInfo, child) => SliverToBoxAdapter(
                        child: _buildButtons(
                          likeCount: bottomButtonInfo.likeCount,
                          isLiked: bottomButtonInfo.isLiked,
                          isSaved: bottomButtonInfo.isSaved,
                        ),
                      ),
                    ),
                    Selector<TastedRecordPresenter, String>(
                      selector: (context, presenter) => presenter.title,
                      builder: (context, title, child) => SliverToBoxAdapter(
                        child: _buildTitle(title: title),
                      ),
                    ),
                    Selector<TastedRecordPresenter, ProfileInfo>(
                      selector: (context, presenter) => presenter.profileInfo,
                      builder: (context, profileInfo, child) => SliverToBoxAdapter(
                        child: _buildAuthorProfile(
                          nickName: profileInfo.nickName,
                          authorId: profileInfo.authorId,
                          profileImageUrl: profileInfo.profileImageUrl,
                          isFollow: profileInfo.isFollow,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    Selector<TastedRecordPresenter, ContentsInfo>(
                      selector: (context, presenter) => presenter.contentsInfo,
                      builder: (context, contentsInfo, child) => SliverToBoxAdapter(
                        child: _buildContents(
                          rating: contentsInfo.rating,
                          flavors: contentsInfo.flavors,
                          tastedAt: contentsInfo.tastedAt,
                          contents: contentsInfo.contents,
                          location: contentsInfo.location,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 48)),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 24),
                        decoration: BoxDecoration(
                          color: ColorStyles.gray10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Selector<TastedRecordPresenter, BeanInfo>(
                              selector: (context, presenter) => presenter.beanInfo,
                              builder: (context, beanInfo, child) => BeanDetail(
                                beanType: beanInfo.beanType.toString(),
                                country: beanInfo.country,
                                region: beanInfo.region,
                                variety: beanInfo.variety,
                                process: beanInfo.process,
                                roastery: beanInfo.roastery,
                                extraction: beanInfo.extraction,
                                roastPoint: beanInfo.roastingPoint,
                              ),
                            ),
                            Selector<TastedRecordPresenter, TasteReview?>(
                              selector: (context, presenter) => presenter.tastingReview,
                              builder: (context, tastingReview, child) => tastingReview != null
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 32),
                                      child: TasteGraph(
                                        bodyValue: tastingReview.body,
                                        acidityValue: tastingReview.acidity,
                                        bitternessValue: tastingReview.bitterness,
                                        sweetnessValue: tastingReview.sweetness,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 48)),
                    Selector<CommentsPresenter, int>(
                      selector: (context, presenter) => presenter.totalCount,
                      builder: (context, totalCount, child) => SliverToBoxAdapter(
                        child: _buildCommentTitle(commentsCount: totalCount),
                      ),
                    ),
                    Selector<CommentsPresenter, List<CommentPresenter>>(
                      selector: (context, presenter) => presenter.commentPresenters,
                      builder: (context, commentPresenters, child) {
                        final isMyObject = context.read<TastedRecordPresenter>().isMyObject();
                        final authorId = context.read<TastedRecordPresenter>().authorId ?? 0;
                        return commentPresenters.isNotEmpty
                            ? SlidableAutoCloseBehavior(
                                child: SliverList.builder(
                                  itemCount: commentPresenters.length,
                                  itemBuilder: (context, index) {
                                    final presenter = commentPresenters[index];
                                    final isMyComment =
                                        context.read<TastedRecordPresenter>().isMine(presenter.author.id);
                                    return ChangeNotifierProvider.value(
                                      value: presenter,
                                      child: CommentWidget(
                                        objectAuthorId: authorId,
                                        isMyObject: isMyObject,
                                        isMyComment: isMyComment,
                                        onTapReply: () {
                                          _focusNode.requestFocus();
                                          context.read<TastedRecordPresenter>().selectedReply(
                                                presenter.author,
                                                presenter.id,
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SliverToBoxAdapter(child: buildEmptyComments());
                      },
                    ),
                    Selector<CommentsPresenter, bool>(
                      selector: (context, presenter) => presenter.hasNext && !presenter.isLoading,
                      builder: (context, hasNext, child) => hasNext
                          ? const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: ColorStyles.gray70,
                                  ),
                                ),
                              ),
                            )
                          : const SliverToBoxAdapter(),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                top: false,
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Selector<TastedRecordPresenter, CommentTextFieldState>(
                    selector: (context, presenter) => presenter.commentTextFieldState,
                    builder: (context, state, child) {
                      return _buildBottomTextField(
                        prentCommentAuthorNickname: state.prentCommentAuthorNickname,
                        authorNickname: state.authorNickname,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Text('시음기록', style: TextStyles.title02SemiBold),
            const Spacer(),
            FutureButton(
              onTap: () => showActionBottomSheet(),
              onComplete: (result) {
                switch (result) {
                  case TastedRecordDetailAction.update:
                    final tastedRecord = context.read<TastedRecordPresenter>().tastedRecord;
                    if (tastedRecord != null) {
                      ScreenNavigator.showTastedRecordUpdateScreen(
                        context: context,
                        tastedRecord: tastedRecord.copyWith(),
                      );
                    }
                    break;
                  case TastedRecordDetailAction.delete:
                    showCenterDialog(
                        title: '정말 삭제하시겠어요?',
                        centerTitle: true,
                        cancelText: '닫기',
                        doneText: '삭제하기',
                        onDone: () async {
                          try {
                            final context = this.context;
                            await context.read<TastedRecordPresenter>().onDelete();
                            if (context.mounted) {
                              EventBus.instance.fire(const MessageEvent(message: '해당 시음기록을 삭제했어요.'));
                              context.pop();
                            }
                          } catch (e) {
                            EventBus.instance.fire(const MessageEvent(message: '시음기록 삭제에 실패했어요.'));
                          }
                        });
                    break;
                  case TastedRecordDetailAction.block:
                    showCenterDialog(
                      title: '이 사용자를 차단하시겠어요?',
                      content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
                      cancelText: '취소',
                      doneText: '차단하기',
                      onDone: () async {
                        final context = this.context;
                        final nickname = context.read<TastedRecordPresenter>().authorNickname;
                        if (nickname != null) {
                          try {
                            await context.read<TastedRecordPresenter>().onBlock();
                            EventBus.instance.fire(MessageEvent(message: '$nickname님을 차단했어요.'));
                          } catch (e) {
                            EventBus.instance.fire(MessageEvent(message: '$nickname님 차단에 실패했어요.'));
                          }
                        }
                      },
                    );
                    break;
                  case TastedRecordDetailAction.report:
                    final id = context.read<TastedRecordPresenter>().id;
                    ScreenNavigator.pushToReportScreen(context, id: id, type: 'tasted_record');
                  default:
                    return;
                }
              },
              child: SvgPicture.asset(
                'assets/icons/more.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Container(
          width: double.infinity,
          height: 1,
          color: ColorStyles.gray20,
        ),
      ),
    );
  }

  Widget _buildBottomTextField({String? prentCommentAuthorNickname, required String authorNickname}) {
    final bool hasParent = prentCommentAuthorNickname != null;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 24),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorStyles.gray20)),
          color: ColorStyles.white,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorStyles.gray40),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            color: ColorStyles.white,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Visibility(
                visible: hasParent,
                child: Container(
                  padding: const EdgeInsets.only(left: 14, top: 16, bottom: 16, right: 14),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: ColorStyles.gray10,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$prentCommentAuthorNickname님에게 답글 남기는 중',
                        style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                      ),
                      const Spacer(),
                      ThrottleButton(
                        onTap: () {
                          context.read<TastedRecordPresenter>().cancelReply();
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
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: hasParent ? '답글 달기...' : '$authorNickname님에게 댓글 추가...',
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
                  contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    child: SendButton(
                      onTap: () {
                        return context
                            .read<TastedRecordPresenter>()
                            .createNewComment(content: _textEditingController.text);
                      },
                      onComplete: () {
                        _textEditingController.value = TextEditingValue.empty;
                      },
                      onError: (message) {
                        print(message);
                        print('asdklfjklasdjlg');
                        EventBus.instance.fire(MessageEvent(message: message));
                      },
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(maxHeight: max(48, 48.h), maxWidth: 63.w),
                  constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageListView({required List<String> imageUrlList}) {
    final width = MediaQuery.of(context).size.width;
    return HorizontalSliderWidget(
      itemLength: imageUrlList.length,
      itemBuilder: (context, index) => MyNetworkImage(
        imageUrl: imageUrlList[index],
        height: width,
        width: width,
      ),
    );
  }

  Widget _buildButtons({
    required int likeCount,
    required bool isLiked,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        children: [
          LikeButton(
            onTap: () => context.read<TastedRecordPresenter>().onTappedLikeButton(),
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          const Spacer(),
          SaveButton(
            onTap: () => context.read<TastedRecordPresenter>().onTappedSaveButton(),
            isSaved: isSaved,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Builder(builder: (context) {
        final id = context.read<TastedRecordPresenter>().beanId;
        final isOfficial = context.read<TastedRecordPresenter>().isOfficial ?? false;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              title,
              maxLines: null,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
                height: 26.25 / 22,
                letterSpacing: -0.02,
              ),
            ),
            if (isOfficial)
              ThrottleButton(
                onTap: () {
                  if (id != null && isOfficial) {
                    ScreenNavigator.showCoffeeBeanDetail(context: context, id: id);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    spacing: 2,
                    children: [
                      Text('원두상세', style: TextStyles.captionSmallMedium),
                      SvgPicture.asset('assets/icons/arrow.svg', width: 12, height: 12),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildAuthorProfile({
    required String nickName,
    int? authorId,
    required String profileImageUrl,
    required bool isFollow,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ThrottleButton(
        onTap: () {
          final id = authorId;
          if (id != null) {
            ScreenNavigator.pushToProfile(context: context, id: id);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyNetworkImage(
              imageUrl: profileImageUrl,
              height: 36,
              width: 36,
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                nickName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyles.title02SemiBold,
              ),
            ),
            if (!context.read<TastedRecordPresenter>().isMyObject()) ...[
              FollowButton(
                onTap: () => context.read<TastedRecordPresenter>().onTappedFollowButton(),
                isFollowed: isFollow,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContents({
    required double rating,
    required List<String> flavors,
    required String tastedAt,
    required String contents,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) {
                  final i = index + 1;
                  if (i <= rating) {
                    return SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                    );
                  } else if (i - rating < 1) {
                    return SvgPicture.asset(
                      'assets/icons/star_half.svg',
                      height: 16,
                      width: 16,
                    );
                  } else {
                    return SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(ColorStyles.gray40, BlendMode.srcIn),
                    );
                  }
                },
              ),
              const SizedBox(width: 2),
              Text(
                '$rating',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    height: 18 / 12,
                    letterSpacing: -0.01,
                    color: ColorStyles.gray70),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            spacing: 2,
            children: flavors
                .map<Widget>(
                  (flavor) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorStyles.gray70, width: 0.8),
                        borderRadius: const BorderRadius.all(Radius.circular(6))),
                    child: Text(flavor, style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70)),
                  ),
                )
                .toList()
              ..addAll(
                [
                  const Spacer(),
                  Text(tastedAt, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50)),
                ],
              ),
          ),
          const SizedBox(height: 12),
          Text(contents, style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: ColorStyles.gray10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                Text('장소', style: TextStyles.labelSmallSemiBold),
                const SizedBox(width: 8),
                Text(location, style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black)),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentTitle({required int commentsCount}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Text(
        '댓글 ($commentsCount)',
        style: TextStyles.title01SemiBold,
      ),
    );
  }

  Widget buildEmptyComments() {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('아직 댓글이 없어요', style: TextStyles.title02SemiBold),
          const SizedBox(height: 8),
          Text('댓글을 남겨보세요.', style: TextStyles.captionSmallMedium),
        ],
      ),
    );
  }

  Future<TastedRecordDetailAction?> showActionBottomSheet() {
    final isMine = context.read<TastedRecordPresenter>().isMyObject();
    return showBarrierDialog<TastedRecordDetailAction>(
      context: context,
      pageBuilder: (context, _, __) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: isMine ? _buildMineBottomSheet() : _buildOthersBottomSheet(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMineBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThrottleButton(
          onTap: () {
            context.pop(TastedRecordDetailAction.update);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '수정하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ThrottleButton(
          onTap: () {
            context.pop(TastedRecordDetailAction.delete);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '삭제하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ThrottleButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorStyles.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '닫기',
                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOthersBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThrottleButton(
          onTap: () {
            context.pop(TastedRecordDetailAction.report);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '신고하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ThrottleButton(
          onTap: () {
            context.pop(TastedRecordDetailAction.block);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '차단하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ThrottleButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorStyles.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '닫기',
                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showEmptyDialog() {
    return showBarrierDialog(
      context: context,
      barrierColor: ColorStyles.black90,
      pageBuilder: (context, _, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '시음기록을 불러오는데 실패했습니다.',
                          style: TextStyles.title02SemiBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.gray30,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '닫기',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.black,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '확인',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
