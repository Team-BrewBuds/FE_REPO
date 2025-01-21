import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:brew_buds/coffeeNote/provider/coffee_note_presenter.dart';
import 'package:brew_buds/coffeeNote/controller/custom_controller.dart';
import 'package:brew_buds/model/post_subject.dart';
import '../../common/factory/icon_button_factory.dart';
import '../../common/styles/color_styles.dart';
import '../../common/styles/text_styles.dart';
import '../../common/widget/wdgt_datePicker.dart';
import '../../common/widget/wdgt_valid_question.dart';
import '../widget/wdgt_bottom_sheet.dart';

class WriteCoffeeFreeNote extends StatefulWidget {
  const WriteCoffeeFreeNote({super.key});

  @override
  State<WriteCoffeeFreeNote> createState() => _WriteCoffeeFreeNoteState();
}

class _WriteCoffeeFreeNoteState extends State<WriteCoffeeFreeNote> {
  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();
  late String _topic;
  bool _isTopicSelect = false;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _topic = '게시글 주제를 선택해주세요';
    _title.addListener(_updateButton);
    _content.addListener(_updateButton);
  }

  void _updateButton() {
    setState(() {
      _isEnabled =
          _isTopicSelect && _title.text.length > 1 && _content.text.length > 7;
    });
  }

  void _selectTopic(String value) {
    setState(() {
      _topic = value;
      _isTopicSelect = true;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    bool? shouldPop = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WdgtValidQuestion(
          title: '게시물 등록을 그만두시겠습니까?',
          content: '지금까지 쓴 내용은 저장되지 않아요.',
        );
      },
    );
    return shouldPop ?? false;
  }

  void _showToast(String message, {Color backgroundColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          textAlign: TextAlign.center,
          message,
          style: TextStyles.captionMediumNarrowMedium
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoffeeNotePresenter(),
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Consumer<CoffeeNotePresenter>(
            builder: (BuildContext context, presenter, Widget? child) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Divider(thickness: 1.0, color: ColorStyles.gray20),
                    _buildSubjectSelection(presenter),
                    const Divider(thickness: 1.0, color: ColorStyles.gray20),
                    _buildTitleInput(presenter),
                    _buildContentInput(presenter),
                    _buildBottomButtons(presenter),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // 앱바 위젯
  AppBar _buildAppBar() {
    return AppBar(
      title: Text('글쓰기', style: TextStyles.title02SemiBold),
      actions: [
        Consumer<CoffeeNotePresenter>(
          builder: (context, presenter, child) {
            return TextButton(
              onPressed: () {
                if (_isEnabled) {
                  // Process if enabled
                  print('success');
                } else {
                  // Show validation messages as "toast"
                  if (_title.text.length < 2) {
                    _showToast('주제를 2글자 이상 입력하세요', backgroundColor: Colors.black);
                  } else if (_content.text.length < 7) {
                    _showToast('내용을 8글자 이상 입력하세요', backgroundColor: Colors.black);
                  } else if (!_isTopicSelect) {
                    _showToast('게시물 주제를 선택하세요.', backgroundColor: Colors.black);
                  }
                }
              },
              child: Container(
                width: 55,
                height: 32,
                decoration: BoxDecoration(
                  color: _isEnabled
                      ? ColorStyles.red // 활성화 상태
                      : ColorStyles.gray20, // 비활성화 상태
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '등록',
                    style: TextStyle(
                      color: _isEnabled
                          ? ColorStyles.white // 활성화 상태 텍스트 색상
                          : ColorStyles.gray40, // 비활성화 상태 텍스트 색상
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 주제 선택을 위한 BottomSheet 호출
  Widget _buildSubjectSelection(CoffeeNotePresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (context) => WdgtBottomSheet(
              title: '게시물 주제',
              presenter: presenter,
              onTap: _selectTopic,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isTopicSelect ? _topic : '게시글 주제를 선택해주세요',
              style: TextStyles.labelMediumMedium,
            ),
            SvgPicture.asset(
              "assets/icons/down.svg",
              color: ColorStyles.black,
              width: 24.0,
              height: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  // 제목 입력 필드
  Widget _buildTitleInput(CoffeeNotePresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _title,
        cursorColor: ColorStyles.black,
        validator: (value) {
          return presenter
              .validateMultiLineText(value!); // Apply the multi-line validation
        },
        decoration: InputDecoration(
          hintText: '제목을 입력하세요.',
          hintStyle:
          TextStyles.title02SemiBold.copyWith(color: ColorStyles.gray50),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray20),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray20),
          ),
        ),
      ),
    );
  }

  // 내용 입력 필드
  Widget _buildContentInput(CoffeeNotePresenter presenter) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          controller: _content,
          cursorColor: ColorStyles.black,
          decoration: InputDecoration(
            hintText: '내용을 입력하세요.',
            hintStyle:
            TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray20),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray20),
            ),
          ),
          maxLines: null,
          expands: true,
        ),
      ),
    );
  }

  // 하단 버튼들
  Widget _buildBottomButtons(CoffeeNotePresenter presenter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 46, top: 24, left: 16, right: 16),
      child: Row(
        children: [
          IconButtonFactory.buildVerticalButtonWithIconWidget(
            iconWidget: SvgPicture.asset(
              'assets/icons/album.svg',
              width: 20,
              height: 20,
            ),
            text: '사진',
            onTapped: () => presenter.pickImage(),
            textStyle: TextStyles.captionSmallMedium,
          ),
          const SizedBox(width: 10),
          IconButtonFactory.buildVerticalButtonWithIconWidget(
            iconWidget: SvgPicture.asset(
              'assets/icons/coffee.svg',
              width: 20,
              height: 20,
            ),
            text: '기록',
            onTapped: () {},
            textStyle: TextStyles.captionSmallMedium,
          ),
          const SizedBox(width: 10),
          IconButtonFactory.buildVerticalButtonWithIconWidget(
            iconWidget: SvgPicture.asset(
              'assets/icons/tag.svg',
              width: 20,
              height: 20,
            ),
            text: '태그',
            onTapped: () {},
            textStyle: TextStyles.captionSmallMedium,
          ),
        ],
      ),
    );
  }
}
