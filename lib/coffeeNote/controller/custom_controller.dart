import 'package:flutter/material.dart';

import '../../common/styles/color_styles.dart';

class CustomTagController extends TextEditingController {
  static const int maxTags = 5; // 태그 최대 개수 제한
  ValueNotifier<int> tagCountNotifier = ValueNotifier<int>(0);
  List<String> _tags = [];

  List<String> get tags => _tags;


  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final TextStyle defaultStyle =
        style ?? const TextStyle(color: Colors.black, fontSize: 16);
    final TextStyle hashtagStyle = defaultStyle.copyWith(color: ColorStyles.red);

    List<TextSpan> children = [];
    final RegExp regex = RegExp(r'(\s+|#\w+|\S+)');
    final Iterable<Match> matches = regex.allMatches(text);

    int tagCount = 0; // 현재 태그 개수



    for (final Match match in matches) {
      final String word = match.group(0)!;

      if (word.startsWith('#') && word.length > 1) {
        tagCount++;
        if (tagCount > maxTags) {
          print('ee');
          break;
        }
        children.add(TextSpan(text: word, style: hashtagStyle));
      } else {
        children.add(TextSpan(text: word, style: defaultStyle));
      }
    }

    return TextSpan(style: defaultStyle, children: children);
  }

  // @override
  // set text(String newText) {
  //   // 태그 수 확인 및 제한
  //   final List<String> tags = _extractTags(newText);
  //
  //   if (tags.length > maxTags) {
  //     // 태그 초과 시, 처음 30개의 태그만 남기고 나머지는 제거
  //     final RegExp regex = RegExp(r'#\w+');
  //     int tagCounter = 0;
  //     final String truncatedText = newText.replaceAllMapped(regex, (match) {
  //       tagCounter++;
  //       if (tagCounter > maxTags) {
  //         return ''; // 초과 태그 제거
  //       }
  //       return match.group(0)!;
  //     });
  //     super.text = truncatedText;
  //   } else {
  //     super.text = newText;
  //   }
  //   notifyListeners(); // 텍스트 변경 알림
  // }





  List<String> updateTagsFromContent(String content) {
    // 예시: 내용에서 해시태그(#)를 추출하여 태그로 설정
    _tags = content
        .split(' ')
        .where((word) => word.startsWith('#'))
        .map((word) => word.substring(1)) // # 제거
        .toList();

    return _tags;
  }

  String extractContentWithoutTags(String content) {
    if (RegExp(r'#\w+').hasMatch(content)) { // ✅ Check if there are any hashtags
      return content.replaceAll(RegExp(r'#\w+'), '').trim();
    }
    return content; // ✅ Return original content if no hashtags exist
  }


}
