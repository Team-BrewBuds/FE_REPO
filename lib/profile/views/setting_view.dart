import 'dart:convert';
import 'dart:developer';

import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/login/views/login_page_sns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../features/login/presenter/login_presenter.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  List<String> setting = ['사용자 설정', '알림설정', '차단 관리'];
  List<String> account = ['계정', '계정 정보', '맞춤 정보'];
  List<String> backup = [
    '지원',
    '공지사항',
    '도움말',
    '개선 및 의견 남기기',
    '앱 평가하기',
    '원두 등록 요청',
    '1:1문의'
  ];
  List<String> info = ['정보', '서비스 이용약관', '개인정보 처리방침', '오픈소스 라이선스', '앱버전'];
  List<String> out = ['로그아웃', '회원 탈퇴'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: '설정'.text.make(),
      ),
      body: Stack(
        children: [
          Divider(
            height: 0.5,
          ),
          ListView(
            children: [
              GestureDetector(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: setting.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        switch (index) {
                          case 0:
                            context.push('/profile_edit'); // 프로필 편집

                          case 1:
                            context.push('/alarm'); // 알림
                          case 2:
                            context.push('/profile_block'); //차단

                        }
                      },
                      child: ListTile(
                        title: Text(setting[index]),
                        trailing: Container(
                            margin: const EdgeInsets.only(left: 20),
                            // title과 trailing 사이의 간격
                            child: const Icon(CupertinoIcons.right_chevron)),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 0.5,
                  ),
                ),
              ),
              Container(
                height: 14,
                color: ColorStyles.gray20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: account.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (index) {
                        case 0:
                          context.push('');
                        case 1:
                          context.push('/profile_accountInfo'); // 계정 정보
                        case 2:
                          context.push('/profile_fitInfo'); // 맞춤정보
                      }
                    },
                    child: ListTile(
                      title: Text(account[index]),
                      trailing: Container(
                          margin: const EdgeInsets.only(left: 20),
                          // title과 trailing 사이의 간격
                          child: const Icon(CupertinoIcons.right_chevron)),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0.5,
                ),
              ),
              Container(
                height: 14,
                color: ColorStyles.gray20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: backup.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(backup[index]),
                    trailing: Container(
                        margin: const EdgeInsets.only(left: 20),
                        // title과 trailing 사이의 간격
                        child: const Icon(CupertinoIcons.right_chevron)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0.5,
                ),
              ),
              Container(
                height: 14,
                color: ColorStyles.gray20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: info.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(info[index]),
                    trailing: Container(
                        margin: const EdgeInsets.only(left: 20),
                        // title과 trailing 사이의 간격
                        child: const Icon(CupertinoIcons.right_chevron)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0.5,
                ),
              ),
              Container(
                height: 14,
                color: ColorStyles.gray20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: out.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(out[index]),
                    onTap: () {

                      switch(index){
                        case 0 :  showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16),
                                height: 200,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: Text('로그아웃',
                                          style: TextStyle(
                                              color: ColorStyles.red,
                                              fontSize: 17)),
                                      onPressed: () {
                                        // 로그아웃 후 어느 페이지로 이동하는지..?
                                      },
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 343,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('닫기'),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            backgroundColor: Colors.black,
                                            foregroundColor: ColorStyles.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10))),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                        case 1: context.push('/account_out');
                      }
                    },
                    trailing: Container(
                        margin: const EdgeInsets.only(left: 20),
                        // title과 trailing 사이의 간격
                        child: const Icon(CupertinoIcons.right_chevron)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0.5,
                ),
              ),
              Container(
                height: 14,
                color: ColorStyles.gray20,
              )
            ],
          )
        ],
      ),
    );
  }
}
