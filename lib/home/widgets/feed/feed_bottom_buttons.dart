part of 'feed.dart';

class FeedBottomButtons extends StatelessWidget {
  final bool _isLiked;
  final String _likeCount;
  final bool _hasComment;
  final String _commentsCount;
  final bool _isSaved;
  final void Function() _onTapLikeButton;
  final void Function() _onTapCommentsButton;
  final void Function() _onTapSaveButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildLikeButton(),
          const SizedBox(width: 6),
          _buildCommentButton(),
          const Spacer(),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        _isLiked ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        colorFilter: ColorFilter.mode(_isLiked ? ColorStyles.red : ColorStyles.gray70, BlendMode.srcIn),
      ),
      text: _likeCount,
      onTapped: _onTapLikeButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }

  Widget _buildCommentButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        _hasComment ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
        colorFilter: ColorFilter.mode(_hasComment ? ColorStyles.red : ColorStyles.gray70, BlendMode.srcIn),
      ),
      text: _commentsCount,
      onTapped: _onTapCommentsButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }

  Widget _buildSaveButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        _isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        colorFilter: ColorFilter.mode(_isSaved ? ColorStyles.red : ColorStyles.gray70, BlendMode.srcIn),
      ),
      text: '저장',
      onTapped: _onTapSaveButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }

  const FeedBottomButtons({
    super.key,
    required bool isLiked,
    required String likeCount,
    required bool hasComment,
    required String commentsCount,
    required bool isSaved,
    required void Function() onTapLikeButton,
    required void Function() onTapCommentsButton,
    required void Function() onTapSaveButton,
  })  : _isLiked = isLiked,
        _likeCount = likeCount,
        _hasComment = hasComment,
        _commentsCount = commentsCount,
        _isSaved = isSaved,
        _onTapLikeButton = onTapLikeButton,
        _onTapCommentsButton = onTapCommentsButton,
        _onTapSaveButton = onTapSaveButton;
}
