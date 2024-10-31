import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../di/router.dart';
import '../presenter/login_presenter.dart';

class snsLogin extends StatefulWidget {
  final LoginPresenter presenter;

  const snsLogin({super.key, required this.presenter});

  @override
  State<snsLogin> createState() => _snsLoginState();
}

class _snsLoginState extends State<snsLogin> {
  late List<bool> _checked;
  final List<String> _terms = [
    '약관 전체동의',
    '(필수) 브루버즈 이용약관 동의',
    '(필수) 개인정보 수집 및 이용 동의',
    '(필수) 14세 이상 확인',
    '(선택) 개인정보 마케팅 활용 동의'
  ];

  void _checkModal(String name) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              height: 500, // 높이 설정
              color: Colors.white,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            // alignment: Alignment., // 중앙 정렬
                            child: Text(
                              '서비스 이용약관에 동의해주세요',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(CupertinoIcons.xmark),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                          itemCount: _terms.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                color: Colors.grey.withOpacity(0.2),
                                // 배경색 설정
                                child: CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: isAllChecked,
                                    checkColor: Colors.red,
                                    activeColor: Colors.white,
                                    tileColor: Colors.blue,
                                    title: Text('약관 전체 동의'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        for (int i = 0;
                                            i < _checked.length;
                                            i++) {
                                          _checked[i] = value ?? false;
                                        }
                                      });
                                    }),
                              );
                            } else {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Colors.red,
                                activeColor: Colors.white,
                                tileColor: Colors.blue,
                                value: _checked[index],
                                title: Text(_terms[index]),
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checked[index] = value ?? false;
                                  });
                                },
                              );
                            }
                          }),
                    ),
                    SizedBox(height: 2), // Divider 위에 여백 추가
                    Divider(),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 345.0,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (isAllChecked) {
                              switch (name) {
                                case 'kakao':
                                  if(await widget.presenter.loginWithKakao()){
                                    context.push("/signup");
                                  }else{
                                    context.push("/");
                                  }
                                  break;
                                case 'naver':
                                  if(await widget.presenter.loginWithNaver()){
                                    context.push("/signup");
                                  }else{
                                    context.push("/");
                                  }
                                  break;
                                case 'apple':
                                  if(await widget.presenter.loginWithApple()){
                                    context.push("/signup");
                                  }else{
                                    context.push("/");
                                  }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: isAllChecked
                                ? Colors.black
                                : ColorStyles.gray30,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('다음')),
                    )
                  ],
                ),
              )),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checked = List<bool>.filled(_terms.length, false);
  }

  bool get isAllChecked => _checked.sublist(0, 3).every((element) => element);

  @override
  Widget build(BuildContext context) {
    final height = 55.0;
    final width = 353.0;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '간편로그인으로\n빠르게 가입하세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                SizedBox(
                  width: width, // 버튼 가로 크기 통일
                  height: height, // 버튼 높이 통일
                  child: ElevatedButton(
                    onPressed: () {
                      _checkModal('kakao'); // Kakao 로그인 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE812), // Kakao 배경 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login/k.png',
                        ),
                        const Text(
                          '카카오로 로그인',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: width, // 버튼 가로 크기 통일
                  height: height, // 버튼 높이 통일
                  child: ElevatedButton(
                    onPressed: () {
                      _checkModal('naver');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03C75A), // 배경 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login/naver_btn.png',
                        ),
                        const Text(
                          '네이버로 로그인',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SignInWithAppleButton(
                    onPressed: () {
                      _checkModal('apple');
                    },
                    style: SignInWithAppleButtonStyle.black,
                    text: 'Apple로 로그인',
                    height: height),
                ElevatedButton(
                    onPressed: AuthService().logout, child: Text('logout')),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _gotoSNS() {}
}
