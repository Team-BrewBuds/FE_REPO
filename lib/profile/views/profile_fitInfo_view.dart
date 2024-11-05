import 'package:flutter/material.dart';

import '../../common/color_styles.dart';

class FitInfoView extends StatefulWidget {
  const FitInfoView({super.key});

  @override
  State<FitInfoView> createState() => _FitInfoViewState();
}

class _FitInfoViewState extends State<FitInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 65.0), // 제목 왼쪽 여백 추가
          child: Text('맞춤 정보'),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '저장',
                style: TextStyle(color: ColorStyles.red, fontSize: 20),
              )),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
