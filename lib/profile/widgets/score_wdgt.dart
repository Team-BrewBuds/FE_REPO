import 'package:brew_buds/profile/widgets/no_data_wdgt.dart';
import 'package:flutter/material.dart';

class Scorewidget extends StatefulWidget {
  final List<dynamic> scoreData;
  const Scorewidget({super.key, required this.scoreData});

  @override
  State<Scorewidget> createState() => _ScorewidgetState();
}

class _ScorewidgetState extends State<Scorewidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child:
      widget.scoreData.isEmpty ?
      NoDataWdgt(title: '별점 분포', fileImage: null, onPressed: (){},) :
      Column(),
    );
  }
}
