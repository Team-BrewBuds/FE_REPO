import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/detail/model/tasting_review.dart';
import 'package:brew_buds/detail/tasted_record_presenter.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TastedRecordDetailView extends StatefulWidget {
  const TastedRecordDetailView({super.key});

  @override
  State<TastedRecordDetailView> createState() => _TastedRecordDetailViewState();
}

class _TastedRecordDetailViewState extends State<TastedRecordDetailView> {
  final GlobalKey _commentsListKey = GlobalKey();
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;
  int currentIndex = 0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TastedRecordPresenter>().init();
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppbar(),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Selector<TastedRecordPresenter, List<String>>(
                  selector: (context, presenter) => presenter.imageUriList,
                  builder: (context, imageUriList, child) => _buildImageListView(imageUriList: imageUriList),
                ),
                Selector<TastedRecordPresenter, BottomButtonInfo>(
                  selector: (context, presenter) => presenter.bottomButtonInfo,
                  builder: (context, bottomButtonInfo, child) => _buildButtons(
                    likeCount: bottomButtonInfo.likeCount,
                    isLiked: bottomButtonInfo.isLiked,
                    commentCount: bottomButtonInfo.commentCount,
                    isSaved: bottomButtonInfo.isSaved,
                  ),
                ),
                Selector<TastedRecordPresenter, String>(
                  selector: (context, presenter) => presenter.title,
                  builder: (context, title, child) => _buildTitle(title: title),
                ),
                Selector<TastedRecordPresenter, ProfileInfo>(
                  selector: (context, presenter) => presenter.profileInfo,
                  builder: (context, profileInfo, child) => _buildAuthorProfile(
                    nickName: profileInfo.nickName,
                    authorId: profileInfo.authorId,
                    profileImageUri: profileInfo.profileImageUri,
                    isFollow: profileInfo.isFollow,
                  ),
                ),
                const SizedBox(height: 32),
                Selector<TastedRecordPresenter, ContentsInfo>(
                  selector: (context, presenter) => presenter.contentsInfo,
                  builder: (context, contentsInfo, child) => _buildContents(
                    rating: contentsInfo.rating,
                    flavors: contentsInfo.flavors,
                    tastedAt: contentsInfo.tastedAt,
                    contents: contentsInfo.contents,
                    location: contentsInfo.location,
                  ),
                ),
                const SizedBox(height: 48),
                Container(
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
                        builder: (context, beanInfo, child) => _buildBeanDetail(
                          beanType: beanInfo.beanType,
                          isDecaf: beanInfo.isDecaf,
                          country: beanInfo.country,
                          region: beanInfo.region,
                          process: beanInfo.process,
                          roastingPoint: beanInfo.roastingPoint,
                        ),
                      ),
                      Selector<TastedRecordPresenter, TastingReview?>(
                        selector: (context, presenter) => presenter.tastingReview,
                        builder: (context, tastingReview, child) => tastingReview != null
                            ? _buildTastingGraph(
                                bodyValue: tastingReview.body,
                                acidityValue: tastingReview.acidity,
                                acerbityValue: tastingReview.bitterness,
                                sweetnessValue: tastingReview.sweetness,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ].separator(separatorWidget: const SizedBox(height: 32)).toList(),
                  ),
                ),
                const SizedBox(height: 48),
                Selector<TastedRecordPresenter, CommentsInfo>(
                  selector: (context, presenter) => presenter.commentsInfo,
                  builder: (context, commentsInfo, child) => buildComments(
                    authorId: commentsInfo.authorId,
                    comments: commentsInfo.page?.comments ?? [],
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: _buildBottomTextField(),
        ),
      ),
    );
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
            InkWell(
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
            const Text('시음기록', style: TextStyles.title02SemiBold),
            const Spacer(),
            Selector<TastedRecordPresenter, bool>(
              selector: (context, presenter) => presenter.isMine,
              builder: (context, isMine, child) => InkWell(
                onTap: () {
                  showSortCriteriaBottomSheet(isMine: isMine);
                },
                child: SvgPicture.asset(
                  'assets/icons/more.svg',
                  fit: BoxFit.cover,
                  height: 24,
                  width: 24,
                ),
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

  Widget _buildBottomTextField() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 12),
        decoration:
            const BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20)), color: ColorStyles.white),
        child: TextField(
          controller: _textEditingController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: '~ 님에게 댓글 추가..',
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
                  if (_textEditingController.text.isNotEmpty) {}
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
    );
  }

  Widget _buildImageListView({required List<String> imageUriList}) {
    final width = MediaQuery.of(context).size.width;
    return HorizontalSliderWidget(
      itemLength: imageUriList.length,
      itemBuilder: (context, index) => MyNetworkImage(
        imageUri: imageUriList[index],
        height: width,
        width: width,
        color: const Color(0xffD9D9D9),
      ),
    );
  }

  Widget _buildButtons({
    required int likeCount,
    required isLiked,
    required int commentCount,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        children: [
          buildLikeButton(likeCount: likeCount, isLiked: isLiked),
          const SizedBox(width: 6),
          buildCommentButton(commentCount: commentCount),
          const Spacer(),
          buildSaveButton(isSaved: isSaved),
        ],
      ),
    );
  }

  Widget buildLikeButton({required int likeCount, required bool isLiked}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        isLiked ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isLiked ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '좋아요 $likeCount',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {
        context.read<TastedRecordPresenter>().onTappedLikeButton();
      },
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildCommentButton({required int commentCount}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '댓글 $commentCount',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {
        if (_commentsListKey.currentContext != null) {
          Scrollable.ensureVisible(
            _commentsListKey.currentContext!,
            duration: const Duration(milliseconds: 300),
          );
        }
      },
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildSaveButton({required bool isSaved}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isSaved ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      iconAlign: ButtonIconAlign.left,
      onTapped: () {},
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          height: 26.25 / 22,
          letterSpacing: -0.02,
        ),
      ),
    );
  }

  Widget _buildAuthorProfile({
    required String nickName,
    int? authorId,
    required String profileImageUri,
    required bool isFollow,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          final id = authorId;
          if (id != null) {
            context.pop();
            pushToProfile(context: context, id: id);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyNetworkImage(
              imageUri: profileImageUri,
              height: 36,
              width: 36,
              color: const Color(0xffD9D9D9),
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
            //isFollow Api
            FollowButton(onTap: () {}, isFollowed: isFollow),
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
        children: [
          Row(
            children: List.generate(rating.ceil(), (index) {
              final isHalf = index + 1 > rating;
              return SvgPicture.asset(
                height: 16,
                width: 16,
                isHalf ? 'assets/icons/star_half.svg' : 'assets/icons/star_fill.svg',
                colorFilter: isHalf ? null : const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
              );
            })
              ..addAll(
                [
                  const SizedBox(width: 2),
                  Text(
                    '$rating',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 18 / 12,
                        letterSpacing: -0.01,
                        color: ColorStyles.gray70),
                  ),
                ],
              ),
          ),
          const SizedBox(height: 7),
          Row(
            children: flavors
                .map((flavor) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 0.8),
                          borderRadius: const BorderRadius.all(Radius.circular(6))),
                      child: Text(flavor, style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70)),
                    ))
                .separator(separatorWidget: const SizedBox(width: 2))
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
                const Text('장소', style: TextStyles.labelSmallSemiBold),
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

  Widget _buildTastingGraph({
    required double bodyValue,
    required double acidityValue,
    required double acerbityValue,
    required double sweetnessValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('테이스팅', style: TextStyles.title02SemiBold),
        const SizedBox(height: 5),
        _buildTastingSlider(minText: '가벼운', maxText: '무거운', value: bodyValue),
        const SizedBox(height: 0),
        _buildTastingSlider(minText: '산미약한', maxText: '산미강한', value: acidityValue),
        const SizedBox(height: 0),
        _buildTastingSlider(minText: '쓴맛약한', maxText: '쓴맛강한', value: acerbityValue),
        const SizedBox(height: 0),
        _buildTastingSlider(minText: '단맛약한', maxText: '단맛강한', value: sweetnessValue),
      ],
    );
  }

  Widget _buildTastingSlider({required String minText, required String maxText, required double value}) {
    const minValue = 1;
    const maxValue = 5;
    final midValue = ((minValue + maxValue) / 2).ceil();
    final activeStyle = TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red);
    final inactiveStyle = TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            minText,
            textAlign: TextAlign.center,
            style: value < midValue ? activeStyle : inactiveStyle,
          ),
        ),
        Expanded(
          flex: 9,
          child: AbsorbPointer(
            child: SfSliderTheme(
              data: const SfSliderThemeData(
                trackCornerRadius: 0,
                activeTrackHeight: 2,
                inactiveTrackHeight: 2,
                tickOffset: Offset(0, -2),
                minorTickSize: Size.zero,
                tickSize: Size(4, 2),
                inactiveTickColor: ColorStyles.gray10,
                activeTickColor: ColorStyles.gray10,
                activeTrackColor: Color(0xffd9d9d9),
                inactiveTrackColor: Color(0xffd9d9d9),
                thumbColor: ColorStyles.red,
                thumbRadius: 7,
              ),
              child: SfSlider(
                interval: 1,
                showTicks: true,
                value: value < minValue
                    ? minValue
                    : value > maxValue
                        ? maxValue
                        : value,
                min: minValue,
                max: maxValue,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            maxText,
            textAlign: TextAlign.center,
            style: value > midValue ? activeStyle : inactiveStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildBeanDetail({
    required String? beanType,
    required bool? isDecaf,
    required List<String> country,
    required String? region,
    required String? process,
    required String? roastingPoint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('원두 상세정보', style: TextStyles.title02SemiBold),
        const SizedBox(height: 20),
        ...[
          if (beanType != null)
            Row(
              children: [
                const Text('원두 유형', style: TextStyles.labelSmallSemiBold),
                const Spacer(),
                Text(beanType + ((isDecaf ?? false) ? '(디카페인)' : ''), style: TextStyles.labelSmallMedium),
              ],
            ),
          if (country.isNotEmpty)
            Row(
              children: [
                const Text('원산지', style: TextStyles.labelSmallSemiBold),
                const Spacer(),
                if (country.length > 1) ...[
                  Text('${country.first} 외 ${country.length - 1}', style: TextStyles.labelSmallMedium),
                ] else if (country.length == 1) ...[
                  Text(country.first, style: TextStyles.labelSmallMedium),
                ],
              ],
            ),
          if (region != null)
            Row(
              children: [
                const Text('생산 지역', style: TextStyles.labelSmallSemiBold),
                const Spacer(),
                Text(
                  region,
                  style: TextStyles.labelSmallMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          if (process != null)
            Row(
              children: [
                const Text('가공 방식', style: TextStyles.labelSmallSemiBold),
                const Spacer(),
                Text(process, style: TextStyles.labelSmallMedium),
              ],
            ),
          if (roastingPoint != null)
            Row(
              children: [
                const Text('로스팅 포인트', style: TextStyles.labelSmallSemiBold),
                const Spacer(),
                Text(roastingPoint, style: TextStyles.labelSmallMedium),
              ],
            ),
        ].separator(separatorWidget: const SizedBox(height: 13)),
      ],
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
    return const SizedBox(
      height: 270,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('아직 댓글이 없어요', style: TextStyles.title02SemiBold),
          SizedBox(height: 8),
          Text('댓글을 남겨보세요.', style: TextStyles.captionSmallMedium),
        ],
      ),
    );
  }

  Widget buildComments({required int? authorId, required List<Comment> comments}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCommentTitle(commentsCount: comments.length),
        if (comments.isEmpty) ...[buildEmptyComments()] else
          ...comments.map(
            (comment) {
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
                      isWriter: authorId == comment.author.id,
                      contents: comment.content,
                      isLiked: comment.isLiked,
                      likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                      canReply: true,
                      onTappedProfile: () {
                        context.pop();
                        pushToProfile(context: context, id: comment.author.id);
                      },
                      onTappedReply: () {},
                      onTappedLikeButton: () {
                        context.read<TastedRecordPresenter>().onTappedCommentLikeButton(comment);
                      },
                    ),
                    canDelete: context.read<TastedRecordPresenter>().canDeleteComment(authorId: comment.author.id),
                    onDelete: () {
                      context.read<TastedRecordPresenter>().onTappedDeleteCommentButton(comment);
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
                            profileImageUri: reComment.author.profileImageUri,
                            nickName: reComment.author.nickname,
                            createdAt: reComment.createdAt,
                            isWriter: authorId == comment.author.id,
                            contents: reComment.content,
                            isLiked: reComment.isLiked,
                            likeCount: '${reComment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                            onTappedProfile: () {
                              context.pop();
                              pushToProfile(context: context, id: reComment.author.id);
                            },
                            onTappedLikeButton: () {
                              context.read<TastedRecordPresenter>().onTappedCommentLikeButton(
                                    reComment,
                                    parentComment: comment,
                                  );
                            },
                          ),
                          canDelete:
                              context.read<TastedRecordPresenter>().canDeleteComment(authorId: comment.author.id),
                          onDelete: () {
                            context.read<TastedRecordPresenter>().onTappedDeleteCommentButton(reComment);
                          },
                        );
                      },
                    )
                  ]
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildSlidableComment(CommentItem commentItem, {required bool canDelete, Function()? onDelete}) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: canDelete ? 0.4 : 0.2,
        motion: const DrawerMotion(),
        children: [
          if (canDelete)
            Expanded(
              child: InkWell(
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

  showSortCriteriaBottomSheet({required bool isMine}) {
    showBarrierDialog(
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
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: isMine ? _buildMineBottomSheet() : _buildOthersBottomSheet(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMineBottomSheet() {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () {},
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
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '샥제햐기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ButtonFactory.buildRoundedButton(
            onTapped: () {
              context.pop();
            },
            text: '닫기',
            style: RoundedButtonStyle.fill(
              color: ColorStyles.black,
              textColor: ColorStyles.white,
              size: RoundedButtonSize.xLarge,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOthersBottomSheet() {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () {},
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
        InkWell(
          onTap: () {},
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
          child: ButtonFactory.buildRoundedButton(
            onTapped: () {
              context.pop();
            },
            text: '닫기',
            style: RoundedButtonStyle.fill(
              color: ColorStyles.black,
              textColor: ColorStyles.white,
              size: RoundedButtonSize.xLarge,
            ),
          ),
        )
      ],
    );
  }
}
