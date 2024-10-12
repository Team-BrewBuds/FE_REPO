part of 'feed.dart';

class FeedProfile extends StatelessWidget {
  final String _writerProfileImageUri;
  final String _writerNickName;
  final String _writingTime;
  final String _views;
  final bool _isFollowed;
  final void Function() _onTapProfile;
  final void Function() _onTapFollowButton;

  const FeedProfile({
    super.key,
    required String writerProfileImageUri,
    required String writerNickName,
    required String writingTime,
    required String views,
    required bool isFollowed,
    required void Function() onTapProfile,
    required void Function() onTapFollowButton,
  })  : _writerProfileImageUri = writerProfileImageUri,
        _writerNickName = writerNickName,
        _writingTime = writingTime,
        _views = views,
        _isFollowed = isFollowed,
        _onTapProfile = onTapProfile,
        _onTapFollowButton = onTapFollowButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTapProfile,
      child: Container(
        width: double.infinity,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
//프로필 사진
            Container(
              height: 36,
              width: 36,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                shape: BoxShape.circle,
              ),
              child: Image.network(_writerProfileImageUri, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
//닉네임
                    child: Text(_writerNickName, textAlign: TextAlign.start, style: TextStyles.titleSmallBold),
                  ),
                  Expanded(
                    child: Text(
                      '$_writingTime・$_views',
                      style: TextStyles.labelSmallRegular.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            FollowButton(onTap: _onTapFollowButton, isFollowed: _isFollowed),
          ],
        ),
      ),
    );
  }
}
