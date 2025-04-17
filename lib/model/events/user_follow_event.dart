class UserFollowEvent {
  final String senderId;
  final int userId;
  final bool isFollow;

  const UserFollowEvent({
    required this.senderId,
    required this.userId,
    required this.isFollow,
  });
}