import 'dart:developer';

import 'package:brew_buds/features/signup/models/signup_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPageFirst extends StatefulWidget {
  const LoginPageFirst({super.key});

  @override
  State<LoginPageFirst> createState() => _LoginPageFirstState();
}

class _LoginPageFirstState extends State<LoginPageFirst> {
  int _currentIndex = 0;
  final SignUpLists _lists = SignUpLists();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkStorage(); // 저장된 값 확인
  }

  Future<void> _checkStorage() async {
    // 로컬 스토리지 토큰 확인 여부
    String? value = await _storage.read(key: 'auth_token');

    if(value != null){
      _storage.deleteAll();  //로그인 전 토큰 남아있으면 모두 삭제.
    } else {
      log('storage token is $value');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: PageView.builder(
                itemCount: _lists.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(_lists.images[index]),
                      Text(
                        _lists.title_data[index],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Text(
                        _lists.content_data[index],
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          _buildIndicator(),
          const Spacer(),
          SizedBox(
            width: 343,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.push("/login/sns");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: '로그인/회원가입'.text.size(16).make(),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              '둘러보기',
              style: TextStyle(color: Colors.black, fontSize: 16.0, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 3; i++) // 페이지 개수만큼 점 생성
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: _currentIndex == i ? 25 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == i ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
