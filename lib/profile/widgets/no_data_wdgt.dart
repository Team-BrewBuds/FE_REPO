import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/gap.dart';
import '../../common/text_styles.dart';

class NoDataWdgt extends StatefulWidget {
  final String title;
  final String? info;
  final FileImage? fileImage;
  final VoidCallback onPressed;

  const NoDataWdgt({
    super.key,
    required this.title,
    required this.fileImage,
    required this.onPressed,
    this.info, // onPressed도 required로 추가
  });

  @override
  State<NoDataWdgt> createState() => _NoDataWdgtState();
}

class _NoDataWdgtState extends State<NoDataWdgt> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyles.title02SemiBold,
                  )
                ],
              ),
              gap.gapH20,
              Text(
                '아직 작성한 시음기록이 없어요.',
                style: TextStyles.title02Bold,
              ),
              gap.gapH10,
              Text(
                '시음 기록 1개 작성하고 내 커피 취향을 알아보는 건 어때요?',
                style: TextStyles.textlightSmall,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 180,
                height: 180,
                color: ColorStyles.gray30,
              ),
              // Image.network('') ,
              SizedBox(
                height: 30,
              ),
              Container(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  child: Text('시음기록 작성하기'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorStyles.red20,
                    foregroundColor: ColorStyles.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      // 둥근 테두리 적용 (12px)
                      side: BorderSide(
                        color: ColorStyles.red20, // 테두리 색상
                        // 테두리 두께
                      ),
                    ),
                  ),
                ),
              ),
              gap.gapH20,
              if(widget.info != null)
                Container(
                  height: 70,
                  color: ColorStyles.gray10,
                  child: Text("${widget.info}", style: TextStyles.textlightSmall),
                )
            ],
          ),
        ));
  }
}
