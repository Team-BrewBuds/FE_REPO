import 'package:brew_buds/data/api/profile_api.dart';
import '../../model/profile.dart';

class ProfileRepository {
  final ProfileApi _api = ProfileApi();

  ProfileRepository._();

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<void> fetchProfile() => _api.fetchMyProfile();

  Future<void> fetchUpdateProfile(Map<String, dynamic> data) => _api.updateMyProfile(body: data);
}
