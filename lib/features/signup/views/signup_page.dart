import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

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
  final TextEditingController _controller = TextEditingController();
  bool _showClearButton = false;
  bool _showWarning = false;
  int _selectedIndex = -1;

  String? _nicknameError;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateState(String value) {
    setState(() {
      _showWarning = _isUnderAge(value);
    });
  }

  bool _isUnderAge(String yearStr) {
    if (yearStr.length != 4) return false;
    int? birthYear = int.tryParse(yearStr);
    if (birthYear == null) return false;
    int currentYear = DateTime.now().year;
    int age = currentYear - birthYear;
    return age < 14;
  }

  void _validateNickname(String value) {
    setState(() {
      if (value.length < 2) {
        _nicknameError = '2 ~ 12자 이내만 가능해요.';
      } else {
        _nicknameError = null;
      }
    });
  }

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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
                      decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                    ),
                  ),Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                    ),
                  ),Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                    ),
                  ),Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFCFCFCF)),
                  )
                ],
              ),
            ),
            Text(
              '버디님에 대해 알려주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('닉네임'),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                hintText: '2 ~ 12자 이내',
                border: OutlineInputBorder(),
                errorText: _nicknameError,
              ),
              maxLength: 12,
              onChanged: _validateNickname,
            ),
            SizedBox(height: 20),
            Text('태어난 연도'),
            TextField(
              onChanged: _updateState,
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: '2010',
                border: OutlineInputBorder(),
                suffixIcon: _showClearButton
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _updateState('');
                        },
                      )
                    : null,
              ),
            ),
            SizedBox(height: 8),
            if (!_showWarning)
              Text(
                '버디님과 비슷한 연령대가 선호하는 원두를 추천해드려요',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            SizedBox(height: 8),
            if (_showWarning)
              Text(
                '만 14세 미만은 가입할 수 없어요.',
                style: TextStyle(color: Colors.red),
              ),
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 46.0, left: 16,right: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('다음'),
            onPressed: () {
              context.push("/signup/enjoy");
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
