import 'package:brew_buds/domain/setting/model/setting_item.dart';

enum SettingCategory {
  user,
  account,
  support,
  information,
  etc;

  @override
  String toString() => switch (this) {
        SettingCategory.user => '사용자 설정',
        SettingCategory.account => '계정',
        SettingCategory.support => '지원',
        SettingCategory.information => '정보',
        SettingCategory.etc => '',
      };

  List<SettingItem> get items => switch (this) {
        SettingCategory.user => [SettingItem.notification, SettingItem.block],
        SettingCategory.account => [SettingItem.account, SettingItem.detail],
        SettingCategory.support => [SettingItem.evaluation],
        SettingCategory.information => [SettingItem.terms, SettingItem.policy, SettingItem.version],
        SettingCategory.etc => [SettingItem.logout, SettingItem.signOut],
      };
}
