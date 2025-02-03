import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/drag_bar.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';

class WdgtSearchBottomSheet extends StatefulWidget {
  const WdgtSearchBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.height = 190,
    this.useIcon,
  });

  final String title;
  final String content;
  final double? height;
  final bool? useIcon;

  @override
  State<WdgtSearchBottomSheet> createState() => _WdgtSearchBottomSheetState();
}

class _WdgtSearchBottomSheetState extends State<WdgtSearchBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildDraggableIndicator(),
            SizedBox(
              height: 14,
            ),
            widget.useIcon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // 전체 Row를 가로로 중앙 정렬
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/navigation.svg',
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center, // 텍스트를 가운데 정렬
                        style: TextStyles.title02SemiBold,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/x.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      // 왼쪽에 빈 공간을 추가
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyles.title02SemiBold,
                          ),
                        ),
                      ),
                      // X 아이콘 버튼
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icons/x.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: widget.content,
                filled: true,
                fillColor: ColorStyles.gray10,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorStyles.gray40, width: 1),
                  // 포커스가 없을 때의 기본 테두리 색상
                  borderRadius: BorderRadius.circular(34),
                ),
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorStyles.gray40, width: 1),
                  borderRadius: BorderRadius.circular(34),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: ColorStyles.gray40, width: 1),
                  borderRadius: BorderRadius.circular(34),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                // 수직 패딩 값 조정
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0), // 아이콘 크기에 맞는 적당한 여백 설정
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: ColorStyles.gray50,
                    width: 10,
                    height: 10,
                  ),
                ),
                hintStyle: TextStyles.labelSmallMedium
                    .copyWith(color: ColorStyles.gray50),
              ),
              style: TextStyles.labelSmallMedium,
              cursorColor: ColorStyles.black,
              cursorErrorColor: ColorStyles.black,
              autovalidateMode: AutovalidateMode.always,
            ),
            // _buildSubjectList(),
          ],
        ),
      ),
    );
  }
}

Widget buildDraggableIndicator() {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: const DraggableIndicator());
}
