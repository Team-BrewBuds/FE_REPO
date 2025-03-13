enum SettingItem {
  notification,
  block,
  account,
  detail,
  notice,
  help,
  improvements,
  evaluation,
  registrationOfBeans,
  inquiry,
  terms,
  policy,
  openSourceLicense,
  version,
  logout,
  signOut;

  @override
  String toString() => switch(this) {
    SettingItem.notification => '알림 설정',
    SettingItem.block => '차단 관리',
    SettingItem.account => '계정 정보',
    SettingItem.detail => '맞춤 정보',
    SettingItem.notice => '공지 사항',
    SettingItem.help => '도움말',
    SettingItem.improvements => '개선 및 의견 남기기',
    SettingItem.evaluation => '앱 평가하기',
    SettingItem.registrationOfBeans => '원두 등록 요청',
    SettingItem.inquiry => '1:1 문의',
    SettingItem.terms => '서비스 이용약관',
    SettingItem.policy => '개인정보 처리방침',
    SettingItem.openSourceLicense => '오픈소스 라이센스',
    SettingItem.version => '앱버전',
    SettingItem.logout => '로그아웃',
    SettingItem.signOut => '회원 탈퇴',
  };
}
