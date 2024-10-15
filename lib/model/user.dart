final class User {
  final String thumbnailUri;
  final String nickName;
  final int followCount;
  final bool isFollowed;

  User({
    required this.thumbnailUri,
    required this.nickName,
    required this.followCount,
    required this.isFollowed,
  });
}