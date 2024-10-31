import 'dart:convert';

import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/signup/models/signup_lists.dart';
import 'package:brew_buds/features/signup/provider/SignUpProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/color_styles.dart';

class SignUpSelect extends StatefulWidget {
  @override
  _TasteProfileSelectorState createState() => _TasteProfileSelectorState();
}

class _TasteProfileSelectorState extends State<SignUpSelect> {
  Map<String, dynamic> _preferred = {}; // 최종 값 map으로 저장.
  List<int?> selectedIndices = List.filled(4, null); // 초기 선택값 없음
  SignUpLists lists = SignUpLists();

  @override
  void initState() {
    super.initState();
  }

  // 선택 사항들을 map 형식으로 구현.
  Map<String, dynamic> mapData() {
    for (int i = 0; i < selectedIndices.length; i++) {
      if (selectedIndices[i] != null) {
        _preferred[lists.categories_en[i]] = [selectedIndices[i]!];
      }
    }
    Map<String, int> incrementedMap =
        _preferred.map((key, value) => MapEntry(key, value[0] + 1));
    return incrementedMap;
  }

  // 모든 정보가 선택되었는지 확인
  bool _isAllSelected() {
    return selectedIndices.every((index) => index != null);
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            child: Text('건너뛰기', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              // Handle skip action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: List.generate(
                      4,
                      (index) => Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Container(
                              width: 84.25,
                              height: 2,
                              decoration:
                                  BoxDecoration(color: Color(0xFFFE2D00)),
                            ),
                          )),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 28.0, bottom: 4.0, right: 84),
                    child: SizedBox(
                      width: 275,
                      child: Text(
                        '평소에 어떤 커피를 즐기세요?',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 24,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '버디님의 커피 취향에 꼭 맞는 원두를 만나보세요.',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0.11,
                        letterSpacing: -0.13,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(lists.categories.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(lists.categories[index],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      _buildSelector(index),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
        child: SizedBox(
          width: double.infinity,
          child: Consumer<SignUpProvider>(
            builder: (BuildContext context, signProvider, Widget? child) {
              return ElevatedButton(
                child: Text('다음'),
                onPressed: () {

                  if (_isAllSelected()) {
                    signProvider.getPreferredBeanTaste(mapData()); // provider에 값 저장
                    try {
                      Map<String, dynamic> data = signProvider.toJson(); // 모든 설문 json 형식으로 데이터 형성.
                      if (data != null) {
                        print(jsonEncode(data));
                        // 닉네임 검사 로직 추가 해야함 ( 백엔드 기능 추가 필요)
                        AuthService().register(data);
                        context.push('/signup/finish');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor:
                      _isAllSelected() ? Colors.black : ColorStyles.gray30,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSelector(int categoryIndex) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                if (index == 4 || index == 0) return SizedBox(width: 20);
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              bool isSelected = selectedIndices[categoryIndex] == index;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndices[categoryIndex] = index;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: isSelected
                                      ? ColorStyles.gray
                                      : Colors.grey),
                            )
                          : null,
                      child: Center(
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? ColorStyles.gray : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    lists.labels[categoryIndex][index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? ColorStyles.gray : Colors.black,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
