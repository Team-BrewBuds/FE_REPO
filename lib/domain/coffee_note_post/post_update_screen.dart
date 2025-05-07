import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_post/coffee_note_post_exception.dart';
import 'package:brew_buds/domain/coffee_note_post/post_update_presenter.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostUpdateScreen extends StatefulWidget {
  final String title;
  final String content;
  final String tag;

  const PostUpdateScreen({
    super.key,
    required this.title,
    required this.content,
    required this.tag,
  });

  @override
  State<PostUpdateScreen> createState() => _PostUpdateScreenState();
}

class _PostUpdateScreenState extends State<PostUpdateScreen> with CenterDialogMixin<PostUpdateScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _tagController = TextEditingController(text: widget.tag);
    _tagFocusNode.addListener(() {
      _handleFocusChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _tagFocusNode.removeListener(() {
      _handleFocusChange();
    });
    _tagFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_tagFocusNode.hasFocus) {
      // **1️⃣ Focus 되면 자동으로 `#` 추가**
      if (_tagController.text.isEmpty) {
        _tagController.value =
            const TextEditingValue(text: '#', selection: TextSelection.collapsed(offset: '#'.length));
      }
    } else {
      // **2️⃣ Focus 해제 시 `#`만 남아있다면 모두 삭제**
      if (_tagController.text == '#') {
        _tagController.value = const TextEditingValue(text: '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Builder(
        builder: (context) {
          final isLoading = context.select<PostUpdatePresenter, bool>((presenter) => presenter.isLoading);
          return Stack(
            children: [
              Scaffold(
                appBar: _buildAppBar(),
                body: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Selector<PostUpdatePresenter, PostSubject>(
                            selector: (context, presenter) => presenter.subject,
                            builder: (context, subject, child) {
                              return _buildSubjectSelector(subject: subject);
                            }),
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
                        Selector<PostUpdatePresenter, ImageListViewState>(
                          selector: (context, presenter) => presenter.imageListViewState,
                          builder: (context, imageListViewState, _) {
                            if (imageListViewState.images.isNotEmpty) {
                              return _buildAttachedContent(
                                itemLength: imageListViewState.images.length,
                                itemBuilder: (index) {
                                  final image = imageListViewState.images[index];
                                  return _buildGridItem(
                                    imageWidget: ExtendedImage.network(
                                      image,
                                      fit: BoxFit.cover,
                                      border: index == 0 ? Border.all(color: ColorStyles.red, width: 2) : null,
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    ),
                                    isRepresentative: index == 0,
                                  );
                                },
                              );
                            } else if (imageListViewState.tastedRecords.isNotEmpty) {
                              return _buildAttachedContent(
                                itemLength: imageListViewState.tastedRecords.length,
                                itemBuilder: (index) {
                                  final tastedRecord = imageListViewState.tastedRecords[index];
                                  return _buildGridItem(
                                    imageWidget: ExtendedImage.network(
                                      tastedRecord.thumbnailUrl,
                                      fit: BoxFit.cover,
                                      border: index == 0 ? Border.all(color: ColorStyles.red, width: 2) : null,
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    ),
                                    isRepresentative: index == 0,
                                  );
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Positioned.fill(child: LoadingBarrier()),
            ],
          );
        }
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                '게시글 수정',
                style: TextStyles.title02SemiBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              child: ThrottleButton(
                onTap: () {
                  showCenterDialog(
                      title: '게시글 수정을 그만두시겠습니까?',
                      centerTitle: true,
                      content: '지금까지 작성한 내용은 저장되지 않아요.',
                      contentAlign: TextAlign.center,
                      cancelText: '그만두기',
                      doneText: '계속쓰기',
                      onCancel: () {
                        context.pop();
                      });
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
              child: Selector<PostUpdatePresenter, bool>(
                selector: (context, presenter) => presenter.canUpdate,
                builder: (context, canUpdate, child) {
                  return FutureButton<void, CoffeeNotePostException>(
                    onTap: () => context.read<PostUpdatePresenter>().update(),
                    onError: (exception) {
                      if (exception != null) {
                        EventBus.instance.fire(MessageEvent(message: exception.message));
                      } else {
                        EventBus.instance.fire(const MessageEvent(message: '알 수 없는 오류로 게시글 수정에 실패했어요.'));
                      }
                    },
                    onComplete: (_) {
                      EventBus.instance.fire(const MessageEvent(message: '게시글을 수정했어요.'));
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: canUpdate ? ColorStyles.red : ColorStyles.gray20,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        '완료',
                        style: TextStyles.labelSmallMedium.copyWith(
                          color: canUpdate ? ColorStyles.white : ColorStyles.gray40,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector({required PostSubject subject}) {
    return ThrottleButton(
      onTap: () {
        _showSubjectSelector(currentSubject: subject);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
        ),
        child: Row(
          children: [
            Text(subject.toString(), style: TextStyles.labelMediumMedium),
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
        inputFormatters: const [],
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
        onChanged: (newTitle) {
          context.read<PostUpdatePresenter>().onChangeTitle(newTitle);
        },
      ),
    );
  }

  Widget _buildContentTextField() {
    return TextFormField(
      focusNode: _contentFocusNode,
      controller: _contentController,
      keyboardType: TextInputType.multiline,
      inputFormatters: const [],
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
      onChanged: (newContent) {
        context.read<PostUpdatePresenter>().onChangeContent(newContent);
      },
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
      onChanged: (newTag) {
        context.read<PostUpdatePresenter>().onChangeTag(newTag);
      },
    );
  }

  Widget _buildAttachedContent({
    required int itemLength,
    required Widget Function(int index) itemBuilder,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: List<Widget>.generate(itemLength, itemBuilder).toList(),
      ),
    );
  }

  Widget _buildGridItem({
    required Widget imageWidget,
    required bool isRepresentative,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: imageWidget,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          decoration: BoxDecoration(
            color: isRepresentative ? ColorStyles.red : ColorStyles.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            '대표 이미지',
            style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white),
          ),
        ),
      ],
    );
  }

  _showSubjectSelector({required PostSubject? currentSubject}) async {
    final subjectList = [
      PostSubject.normal,
      PostSubject.caffe,
      PostSubject.beans,
      PostSubject.information,
      PostSubject.gear,
      PostSubject.question,
      PostSubject.worry,
    ];
    final result = await showBarrierDialog<PostSubject>(
      context: context,
      pageBuilder: (context, _, __) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 16, bottom: 24),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1)),
                            ),
                            child: Center(child: Text('게시글 주제', style: TextStyles.title02SemiBold)),
                          ),
                          ...List<Widget>.generate(
                            subjectList.length,
                            (index) {
                              final subject = subjectList[index];
                              return ThrottleButton(
                                onTap: () {
                                  context.pop(subject);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          subject.toString(),
                                          style: TextStyles.labelMediumMedium.copyWith(
                                            color: currentSubject == subject ? ColorStyles.red : ColorStyles.black,
                                          ),
                                        ),
                                      ),
                                      if (currentSubject == subject)
                                        const Icon(Icons.check, size: 18, color: ColorStyles.red),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).separator(separatorWidget: Container(height: 1, color: ColorStyles.gray20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      _onSelectedSubject(result);
    }
  }

  _onSelectedSubject(PostSubject subject) {
    context.read<PostUpdatePresenter>().onChangeSubject(subject);
  }
}

class HashLimiterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    int cursorPosition = newValue.selection.baseOffset;

    // 1️⃣ 입력값이 '#' 하나뿐인데 삭제하려고 하면 유지
    if (oldValue.text == '#' && text.isEmpty) {
      return TextEditingValue(
        text: oldValue.text,
        selection: TextSelection.collapsed(offset: oldValue.text.length),
      );
    }

    // 2️⃣ 특수문자 제한 (한글, 영문, 숫자, `#`, 띄어쓰기만 허용)
    text = text.replaceAll(RegExp(r'[^\p{L}\p{N}#\s]', unicode: true), '');

    // 3️⃣ 공백(` `)을 `#`으로 변환
    text = text.replaceAll(' ', '#');

    // 4️⃣ `#`이 여러 개 연속 입력되면 하나로 변환
    text = text.replaceAll(RegExp(r'#{2,}'), '#');

    if (text.isNotEmpty && !text.startsWith('#')) {
      text = '#$text';
    }

    // 6️⃣ 커서 위치 보정
    int diff = text.length - newValue.text.length;
    int newCursorPosition = (cursorPosition + diff).clamp(0, text.length);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
