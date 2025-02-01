import 'package:brew_buds/coffeeNote/provider/post_presenter.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
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
  final PostRepository postRepository = PostRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostPresenter>(context, listen: false);
    });
  }

  @override
  void dispose() {
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
            style: TextStyles.captionMediumNarrowMedium),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostPresenter(postRepository: postRepository),
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Consumer<PostPresenter>(
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
        Consumer<PostPresenter>(
          builder: (context, presenter, child) {
            return TextButton(
              onPressed: () {
                if (presenter.isEnabled) {
                  presenter.createPost(
                      title: presenter.title,
                      content: presenter.tagController
                          .extractContentWithoutTags(presenter.tag),
                      subject: presenter.topic,
                      tag: presenter.tagController
                          .updateTagsFromContent(presenter.tag),
                      tasted_recordes: [1],
                      photos: [0]);
                } else {
                  if (presenter.title.length < 2) {
                    _showToast('제목을 2글자 이상 입력하세요',
                        backgroundColor: Colors.black);
                  } else if (presenter.tag.length < 7) {
                    _showToast('내용을 8글자 이상 입력하세요',
                        backgroundColor: Colors.black);
                  } else if (!presenter.isTopicSelect) {
                    _showToast('게시물 주제를 선택하세요.', backgroundColor: Colors.black);
                  } else {
                    presenter.updateButton();
                  }
                }
              },
              child: Container(
                width: 55,
                height: 32,
                decoration: BoxDecoration(
                  color: presenter.isEnabled
                      ? ColorStyles.red // 활성화 상태
                      : ColorStyles.gray20, // 비활성화 상태
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '등록',
                    style: TextStyle(
                      color: presenter.isEnabled
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
  Widget _buildSubjectSelection(PostPresenter presenter) {
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
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              presenter.isTopicSelect ? presenter.topic : '게시글 주제를 선택해주세요',
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
  Widget _buildTitleInput(PostPresenter presenter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: presenter.titleController,
        cursorColor: ColorStyles.black,
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
  Widget _buildContentInput(PostPresenter presenter) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          controller: presenter.tagController,
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
  Widget _buildBottomButtons(PostPresenter presenter) {
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
            onTapped: () => {},
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
