import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PostWriteScreen extends StatefulWidget {
  const PostWriteScreen({
    super.key,
  });

  @override
  State<PostWriteScreen> createState() => _PostWriteScreenState();
}

class _PostWriteScreenState extends State<PostWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  unfocusAll() {
    _titleFocusNode.unfocus();
    _contentFocusNode.unfocus();
    _tagFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocusAll();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildSubjectSelector(subject: null),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTitleTextField(),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100),
                    child: _buildContentTextField(),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTagTextField(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20, width: 1))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.5),
                          child: SvgPicture.asset('assets/icons/image.svg', width: 24, height: 24),
                        ),
                        SizedBox(height: 2),
                        Text('사진', style: TextStyles.captionSmallMedium),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.5),
                          child: SvgPicture.asset('assets/icons/coffee.svg', width: 24, height: 24),
                        ),
                        SizedBox(height: 2),
                        Text('기록', style: TextStyles.captionSmallMedium),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      toolbarHeight: 50,
      title: Container(
        height: 49,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                '글쓰기',
                style: TextStyles.title02SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/x.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: const BoxDecoration(
                    color: ColorStyles.gray20,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Text('완료', style: TextStyles.labelSmallMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector({required String? subject}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
        ),
        child: Row(
          children: [
            Text(subject ?? '게시물 주제를 선택해주세요', style: TextStyles.labelMediumMedium),
            const Spacer(),
            SvgPicture.asset('assets/icons/down.svg', height: 24, width: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
      ),
      child: TextFormField(
        focusNode: _titleFocusNode,
        controller: _titleController,
        keyboardType: TextInputType.text,
        inputFormatters: [],
        decoration: InputDecoration.collapsed(
          hintText: '제목을 입력하세요.',
          hintStyle: TextStyles.title02SemiBold.copyWith(color: ColorStyles.gray50),
        ),
        style: TextStyles.title02SemiBold,
        cursorColor: ColorStyles.black,
        cursorErrorColor: ColorStyles.black,
        cursorHeight: 16,
        cursorWidth: 1,
        maxLines: 1,
      ),
    );
  }

  Widget _buildContentTextField() {
    return TextFormField(
      focusNode: _contentFocusNode,
      controller: _contentController,
      keyboardType: TextInputType.text,
      inputFormatters: [],
      decoration: InputDecoration(
        isDense: true,
        hintText: '버디님의 커피 생활을 공유해보세요.',
        hintStyle: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50),
        contentPadding: EdgeInsets.zero,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: TextStyles.bodyRegular,
      maxLines: null,
      cursorColor: ColorStyles.black,
      cursorErrorColor: ColorStyles.black,
      cursorHeight: 16,
      cursorWidth: 1,
    );
  }

  Widget _buildTagTextField() {
    return TextFormField(
      focusNode: _tagFocusNode,
      controller: _tagController,
      keyboardType: TextInputType.text,
      inputFormatters: [HashLimiterFormatter()],
      decoration: InputDecoration(
        isDense: true,
        hintText: '#태그',
        hintStyle: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50),
        contentPadding: EdgeInsets.zero,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      style: TextStyles.bodyRegular.copyWith(color: ColorStyles.red),
      maxLines: null,
      cursorColor: ColorStyles.black,
      cursorErrorColor: ColorStyles.black,
      cursorHeight: 16,
      cursorWidth: 1,
    );
  }
}

class HashLimiterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regex = RegExp(r'(^|\s)(?!#)(\w+)');
    final duplicateHashRegex = RegExp(r'#{2,}'); // 연속된 ## 제거

    // 단어 앞에 # 자동 추가
    String formatted = newValue.text.replaceAllMapped(regex, (match) {
      return '${match.group(1)}#${match.group(2)}';
    });

    // 연속된 #을 하나로 변환
    formatted = formatted.replaceAll(duplicateHashRegex, '#');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
