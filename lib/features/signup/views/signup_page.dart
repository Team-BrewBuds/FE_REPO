import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int _selectedIndex = -1; //gender default

  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  bool _hasFocus = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        setState(() {
          _hasFocus = _focusNode.hasFocus;
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
              (_nicknameController.text.length < 2 || _nicknameController.text.length > 12)
              ? '2 ~ 12자 이내만 가능해요.'
              : null;
        });
      });
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });

    _ageController.removeListener(() {
      setState(() {
        _showClearButton = _ageController.text.isNotEmpty;
      });
    });

    _nicknameController.removeListener(() {
      setState(() {
        // 입력 값이 바뀔 때마다 조건에 따라 에러 메시지 설정
        errorText = _nicknameController.text.isNotEmpty &&
                (_nicknameController.text.length < 2 || _nicknameController.text.length > 12)
            ? '2 ~ 12자 이내만 가능해요.'
            : null;
      });
    });
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
          color: isSelected ? (index == 0 ? const Color(0xFFFFF7F5) : const Color(0xFFFFF7F5)) : Colors.white,
          border: Border.all(
            color: isSelected ? (index == 0 ? const Color(0XFFFE2E00) : const Color(0XFFFE2E00)) : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0XFFFE2E00) : Colors.black,
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
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SignUpPresenter>(
          builder: (context, validator, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration: const BoxDecoration(color: ColorStyles.red10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration: const BoxDecoration(color: Color(0xFFCFCFCF)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          width: 84.25,
                          height: 2,
                          decoration: const BoxDecoration(color: Color(0xFFCFCFCF)),
                        ),
                      ),
                      Container(
                        width: 84.25,
                        height: 2,
                        decoration: const BoxDecoration(color: Color(0xFFCFCFCF)),
                      )
                    ],
                  ),
                ),
                const Text(
                  '버디님에 대해 알려주세요',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('닉네임'),
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
                                    ? Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green[400])
                                    : Icon(CupertinoIcons.clear_circled_solid, color: Colors.grey[400]),
                                onPressed: () {
                                  _nicknameController.clear();
                                },
                              ))
                        : null,
                    border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
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
                    border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFFE2D00))),
                    errorText: validator.ageError,
                    errorStyle: const TextStyle(color: Color(0xFFFE2D00)),
                    helperText: validator.ageError == null ? '버디님과 비슷한 연령대가 선호하는 원두를 추천해드려요' : null,
                    suffixIcon: _hasFocus
                        ? (_ageController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: validator.ageError == null
                                    ? Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green[400])
                                    : Icon(CupertinoIcons.clear_circled_solid, color: Colors.grey[400]),
                                onPressed: () {
                                  _ageController.clear();
                                  validator.updateState('');
                                },
                              ))
                        : null,
                  ),
                ),
                // SizedBox(height: 8),

                const SizedBox(height: 20),
                const Text('성별'),
                Row(
                  children: [
                    Expanded(child: _buildGenderButton(0, '여성')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGenderButton(1, '남성')),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (context
                  .read<SignUpPresenter>()
                  .ableCondition(_nicknameController.text, _ageController.text, _selectedIndex)) {
                context
                    .read<SignUpPresenter>()
                    .getUserData(_nicknameController.text, _ageController.text, _selectedIndex);
                context.push('/signup/enjoy');
              }
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 15),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (context.read<SignUpPresenter>().ageError == null &&
                      _ageController.text.isNotEmpty &&
                      _nicknameController.text.length > 1 &&
                      _selectedIndex != -1) {
                    return Colors.black; // 조건이 참일 때 색상
                  }
                  return ColorStyles.gray30; // 조건이 거짓일 때 색상
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused)) {
                    return Colors.white; // 포커스 시 텍스트 색상
                  }
                  return ColorStyles.white; // 기본 텍스트 색상
                },
              ),
            ),
            child: '다음'.text.size(15).make(),
          ),
        ),
      ),
    );
  }
}
