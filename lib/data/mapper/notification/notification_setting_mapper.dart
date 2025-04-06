import 'package:brew_buds/data/dto/notification/notification_setting_dto.dart';
import 'package:brew_buds/model/notification/notification_setting.dart';

extension NotificationSettingToDomain on NotificationSettingDTO {
  NotificationSetting toDomain() => NotificationSetting(
        like: like,
        comment: comment,
        follow: follow,
        marketing: marketing,
      );
}

extension NotificationSettingToDTO on NotificationSetting {
  NotificationSettingDTO toDTO() => NotificationSettingDTO(
        like: like,
        comment: comment,
        follow: follow,
        marketing: marketing,
      );
}
