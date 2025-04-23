import 'package:brew_buds/domain/profile/model/profile_update_model.dart';

class ProfileUpdateEvent {
  final String senderId;
  final int userId;
  final ProfileUpdateModel profileUpdateModel;

  const ProfileUpdateEvent({
    required this.senderId,
    required this.userId,
    required this.profileUpdateModel,
  });
}