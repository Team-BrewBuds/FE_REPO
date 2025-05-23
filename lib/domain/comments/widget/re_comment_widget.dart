import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/profile_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/domain/comments/widget/re_comment_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ReCommentWidget extends StatefulWidget {
  final int objectAuthorId;
  final bool isMyComment;
  final bool isMyObject;
  final Future<void> Function() onDelete;

  const ReCommentWidget({
    super.key,
    required this.objectAuthorId,
    required this.isMyComment,
    required this.isMyObject,
    required this.onDelete,
  });

  @override
  State<ReCommentWidget> createState() => _ReCommentWidgetState();
}

class _ReCommentWidgetState extends State<ReCommentWidget> with TickerProviderStateMixin {
  late final SlidableController _slidableController;

  @override
  void initState() {
    _slidableController = SlidableController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSlidableComment();
  }

  Widget _buildSlidableComment() {
    return Builder(builder: (context) {
      return Slidable(
        controller: _slidableController,
        endActionPane: ActionPane(
          extentRatio: (widget.isMyObject || widget.isMyComment) && !widget.isMyComment ? 0.4 : 0.2,
          motion: const DrawerMotion(),
          children: [
            if (widget.isMyObject || widget.isMyComment)
              Expanded(
                child: FutureButton(
                  onTap: () => widget.onDelete.call(),
                  onError: (_) {
                    _slidableController.close();
                  },
                  onComplete: (_) {
                    _slidableController.close();
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
            if (!widget.isMyComment)
              Expanded(
                child: ThrottleButton(
                  onTap: () {
                    final id = context.read<ReCommentPresenter>().id;
                    _slidableController.close();
                    ScreenNavigator.pushToReportScreen(context, id: id, type: 'comment');
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
        child: _buildComment(context),
      );
    });
  }

  Widget _buildComment(BuildContext context) {
    final isWriter = context.read<ReCommentPresenter>().authorId == widget.objectAuthorId;
    return Container(
      padding: const EdgeInsets.only(left: 60, top: 12, bottom: 12, right: 16),
      color: ColorStyles.gray10,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThrottleButton(
                onTap: () {
                  final id = context.read<ReCommentPresenter>().authorId;
                  ScreenNavigator.showProfile(context: context, id: id);
                },
                child: Builder(builder: (context) {
                  final imageUrl = context.select<ReCommentPresenter, String>((presenter) => presenter.profileImageUrl);
                  return ProfileImage(
                    imageUrl: imageUrl,
                    height: 36,
                    width: 36,
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(builder: (context) {
                          final nickName =
                              context.select<ReCommentPresenter, String>((presenter) => presenter.nickName);
                          return Text(
                            nickName,
                            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.black),
                          );
                        }),
                        const SizedBox(width: 4),
                        Builder(builder: (context) {
                          final createdAt = context.select<ReCommentPresenter, String>(
                            (presenter) => presenter.createdAt,
                          );
                          return Text(
                            createdAt,
                            style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
                          );
                        }),
                        if (isWriter) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorStyles.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '작성자',
                              style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Builder(builder: (context) {
                      final contents = context.select<ReCommentPresenter, String>((presenter) => presenter.contents);
                      return Text(
                        contents,
                        maxLines: null,
                        style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FutureButton(
                onTap: () => context.read<ReCommentPresenter>().onTapLike(),
                child: Container(
                  padding: const EdgeInsets.only(top: 14),
                  width: 36.w,
                  child: Builder(builder: (context) {
                    final isLiked = context.select<ReCommentPresenter, bool>((presenter) => presenter.isLiked);
                    final likeCount = context.select<ReCommentPresenter, int>((presenter) => presenter.likeCount);
                    return Column(
                      children: [
                        SvgPicture.asset(
                          isLiked ? 'assets/icons/like_fill.svg' : 'assets/icons/like.svg',
                          width: 18,
                          height: 18,
                          colorFilter:
                              ColorFilter.mode(isLiked ? ColorStyles.red : ColorStyles.gray70, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          likeCount > 9999 ? '$likeCount+' : '$likeCount',
                          style: TextStyles.captionSmallMedium.copyWith(
                            color: !isLiked ? ColorStyles.gray50 : ColorStyles.red,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
