import 'package:brew_buds/domain/profile/model/profile_update_model.dart';

sealed class ProfileUpdateEvent {}

final class ProfileDataUpdateEvent implements ProfileUpdateEvent {
  final String senderId;
  final int userId;
  final ProfileUpdateModel profileUpdateModel;

  const ProfileDataUpdateEvent({
    required this.senderId,
    required this.userId,
    required this.profileUpdateModel,
  });
}

final class ProfileImageUpdateEvent implements ProfileUpdateEvent {
  final String senderId;
  final int userId;
  final String imageUrl;

  ProfileImageUpdateEvent({
    required this.senderId,
    required this.userId,
    required this.imageUrl,
  });
}
