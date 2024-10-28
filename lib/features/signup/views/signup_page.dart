import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../provider/SignUpProvider.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '회원가입',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int _selectedIndex = -1; //gender default

  FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  bool _hasFocus = false;
  String? errorText;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
        print(_hasFocus);
      });
    });

    _ageController.addListener(() {
      setState(() {
        _showClearButton = _ageController.text.isNotEmpty;
      });
    });

    _nicknameController.addListener(() {
      setState(() {
        // 입력 값이 바뀔 때마다 조건에 따라 에러 메시지 설정
        errorText = _nicknameController.text.isNotEmpty &&
                (_nicknameController.text.length < 2 ||
                    _nicknameController.text.length > 12)
            ? '2 ~ 12자 이내만 가능해요.'
            : null;
      });
    });

    // TextField 포커스 여부
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  // 성별 검증
  Widget _buildGenderButton(int index, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? (index == 0 ? Color(0xFFFFF7F5) : Color(0xFFFFF7F5))
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? (index == 0 ? Color(0XFFFE2E00) : Color(0XFFFE2E00))
                : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0XFFFE2E00) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

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
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Consumer<SignUpProvider>(
              builder: (context, validator, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration:
                              BoxDecoration(color: ColorStyles.red10),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration:
                              BoxDecoration(color: Color(0xFFCFCFCF)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration:
                              BoxDecoration(color: Color(0xFFCFCFCF)),
                        ),
                      ),
                      Container(
                        width: 84.25,
                        height: 2,
                        decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                      )
                    ],
                  ),
                ),
                Text(
                  '버디님에 대해 알려주세요',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('닉네임'),
                TextField(
                  controller: _nicknameController,
                  // focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: '2 ~ 12자 이내',
                    suffixIcon: _hasFocus
                        ? (_nicknameController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: _nicknameController.text.length > 1
                                    ? Icon(
                                        CupertinoIcons
                                            .check_mark_circled_solid,
                                        color: Colors.green[400])
                                    : Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: Colors.grey[400]),
                                onPressed: () {
                                  _nicknameController.clear();
                                },
                              ))
                        : null,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    errorText: errorText,
                    errorStyle: const TextStyle(color: Color(0xFFFE2D00)),
                  ),
                  maxLength: 12,
                ),
                const SizedBox(height: 20),
                const Text('태어난 연도'),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  focusNode: _focusNode,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: validator.updateState,
                  decoration: InputDecoration(
                    hintText: '4자리 숫자를 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFE2D00))),
                    errorText: validator.ageError,
                    errorStyle: TextStyle(color: Color(0xFFFE2D00)),
                    helperText: validator.ageError == null
                        ? '버디님과 비슷한 연령대가 선호하는 원두를 추천해드려요'
                        : null,
                    suffixIcon: _hasFocus
                        ? (_ageController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: validator.ageError == null
                                    ? Icon(
                                        CupertinoIcons
                                            .check_mark_circled_solid,
                                        color: Colors.green[400])
                                    : Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: Colors.grey[400]),
                                onPressed: () {
                                  _ageController.clear();
                                  validator.updateState('');
                                },
                              ))
                        : null,
                  ),
                ),
                // SizedBox(height: 8),

                SizedBox(height: 20),
                Text('성별'),
                Row(
                  children: [
                    Expanded(child: _buildGenderButton(0, '여성')),
                    SizedBox(width: 8),
                    Expanded(child: _buildGenderButton(1, '남성')),
                  ],
                ),
              ],
            );
          }),
        ),
        bottomNavigationBar:
        Padding(
            padding:
                const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: '다음'.text.size(15).make(),
                onPressed: () {
                  if(context.read<SignUpProvider>().
                  ableCondition(_nicknameController.text,_ageController.text,_selectedIndex)){
                    context.read<SignUpProvider>().getUserData(_nicknameController.text, _ageController.text, _selectedIndex);
                    context.push('/signup/enjoy');
                  }

                },
                style: ButtonStyle(
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(vertical: 15),
                  ),
                  backgroundColor:
                  WidgetStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (context.read<SignUpProvider>().ageError == null &&
                          _ageController.text.isNotEmpty &&
                          _nicknameController.text.length > 1 &&
                          _selectedIndex != -1) {
                        return Colors.black; // 조건이 참일 때 색상
                      }
                      return ColorStyles.gray30; // 조건이 거짓일 때 색상
                    },
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.white; // 포커스 시 텍스트 색상
                      }
                      return ColorStyles.white; // 기본 텍스트 색상
                    },
                  ),
                ),
              ),
            ),
          )

    );
  }
}
