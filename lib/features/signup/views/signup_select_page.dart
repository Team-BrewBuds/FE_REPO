import 'package:flutter/material.dart';

class SignUpSelect extends StatefulWidget {
  @override
  _TasteProfileSelectorState createState() => _TasteProfileSelectorState();
}

class _TasteProfileSelectorState extends State<SignUpSelect> {
  final List<String> categories = ['바디감', '산미', '쓴맛', '단맛'];
  final List<List<String>> labels = [
    ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
    ['약한', '약간 약한', '보통', '약간 강한', '강한'],
  ];
  List<int?> selectedIndices = List.filled(4, null); // 초기 선택값 없음

  final Color selectedColor = Color(0xFFFE2E00);

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
        actions: [
          TextButton(
            child: Text('건너뛰기', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              // Handle skip action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0,right: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:12.0),
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
                      decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                    ),
                  ),Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Container(
                      width: 84.25,
                      height: 2,
                      decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                    ),
                  ),Container(
                    width: 84.25,
                    height: 2,
                    decoration: BoxDecoration(color: Color(0xFFFE2D00)),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 4.0),
                  child: SizedBox(
                    width: 275,
                    child: Text(
                      '평소에 어떤 커피를 즐기세요?',
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 0,
                        letterSpacing: -0.40,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 275,
                  child: Text(
                    '버디 님의 커피 취향에 꼭 맞는 원두를 만나보세요.',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 13,
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
              children: List.generate(categories.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(categories[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    _buildSelector(index),
                  ],
                );
              }),
            ),
            Container(
              width: 343,
              height: 47,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: ShapeDecoration(
                color: Color(0xFF111111),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '다음',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 0.09,
                            letterSpacing: -0.14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) ],
        ),
      ),
    );
  }

  Widget _buildSelector(int categoryIndex) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          // 선분들
          Positioned(
            left: 0,
            right: 0,
            top: 20, // 원의 중앙에 맞추기 위해 조정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                // 마지막 원 다음에는 선이 없어야 함
                if (index == 4) return SizedBox(width: 40);
                return Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 40), // 원의 너비만큼 공간
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
          // 원과 텍스트
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? selectedColor : Colors.grey),
                      ),
                      child: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? selectedColor : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    labels[categoryIndex][index],
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? selectedColor : Colors.black,
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