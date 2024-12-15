import 'package:flutter/material.dart';

import 'no_data_wdgt.dart';

class LikeFlaverWdgt extends StatefulWidget {
  final List<dynamic> data;
  const LikeFlaverWdgt({super.key, required this.data});

  @override
  State<LikeFlaverWdgt> createState() => _LikeFlaverWdgtState();
}

class _LikeFlaverWdgtState extends State<LikeFlaverWdgt> {
  String info = "선호하는 맛은 회원님이 3.5점 이상으로 평가한 원두의 맛에, 별점에 따른 가중치를 부여한 뒤 가중 평균을 계산하여 그 결과를 바탕으로 최소 1개, 최대 5개의 맛까지 순위대로 나타냅니다.";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child:
      widget.data.isEmpty ?
      NoDataWdgt(title: '선호하는 맛', info: info ,fileImage: null, onPressed: (){},) :
      Column(),
    );
  }
}
