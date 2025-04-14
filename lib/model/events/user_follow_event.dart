class UserFollowEvent {
  final int userId;
  final bool isFollow;
  UserFollowEvent(this.userId, this.isFollow);
}