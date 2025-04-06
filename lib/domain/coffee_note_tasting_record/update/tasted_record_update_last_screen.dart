import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/core/tasted_record_update_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/update/tasted_record_update_presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/date_picker_bottom_sheet.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/local_search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show DateFormat;

class TastedRecordUpdateLastScreen extends StatefulWidget {
  final String contents;
  final String tag;

  const TastedRecordUpdateLastScreen({
    super.key,
    required this.contents,
    required this.tag,
  });

  @override
  State<TastedRecordUpdateLastScreen> createState() => _TastedRecordUpdateLastScreenState();
}

class _TastedRecordUpdateLastScreenState extends State<TastedRecordUpdateLastScreen>
    with TastedRecordUpdateMixin<TastedRecordUpdateLastScreen>, SnackBarMixin<TastedRecordUpdateLastScreen> {
  late final TextEditingController _contentsController;
  late final TextEditingController _hashTagController;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _hashTagFocusNode = FocusNode();

  @override
  int get currentStep => 3;

  @override
  void initState() {
    _contentsController = TextEditingController(text: widget.contents);
    _hashTagController = TextEditingController(text: widget.tag);
    _hashTagFocusNode.addListener(() {
      _handleFocusChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    _hashTagController.dispose();
    _contentsController.dispose();
    _focusNode.dispose();
    _hashTagFocusNode.removeListener(() {
      _handleFocusChange();
    });
    _hashTagFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_hashTagFocusNode.hasFocus) {
      // **1️⃣ Focus 되면 자동으로 `#` 추가**
      if (_hashTagController.text.isEmpty) {
        _hashTagController.value =
            const TextEditingValue(text: '#', selection: TextSelection.collapsed(offset: '#'.length));
      }
    } else {
      // **2️⃣ Focus 해제 시 `#`만 남아있다면 모두 삭제**
      if (_hashTagController.text == '#') {
        _hashTagController.value = const TextEditingValue(text: '');
      }
    }
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          buildTitle(),
          const SizedBox(height: 8),
          Selector<TastedRecordUpdatePresenter, int>(
            selector: (context, presenter) => presenter.star,
            builder: (context, star, child) => _buildRating(star: star),
          ),
          const SizedBox(height: 8),
          _buildContents(),
          const SizedBox(height: 20),
          _buildHashTag(),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: ColorStyles.gray10,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray40))),
                  child: Selector<TastedRecordUpdatePresenter, DateTime>(
                    selector: (context, presenter) => DateTime.parse(presenter.tastedAt),
                    builder: (context, tastedAt, child) => _buildDate(tastedAt: tastedAt),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray40))),
                  child: Selector<TastedRecordUpdatePresenter, String>(
                    selector: (context, presenter) => presenter.place,
                    builder: (context, place, child) => _buildPlace(place: place),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Selector<TastedRecordUpdatePresenter, bool>(
                    selector: (context, presenter) => presenter.isPrivate,
                    builder: (context, isPrivate, child) => _buildPrivate(isPrivate: isPrivate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 46),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorStyles.gray30,
                ),
                child: const Text('뒤로', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Selector<TastedRecordUpdatePresenter, bool>(
              selector: (context, presenter) => presenter.isValidLastPage,
              builder: (context, isValidLastPage, child) {
                return AbsorbPointer(
                  absorbing: !isValidLastPage,
                  child: GestureDetector(
                    onTap: () {
                      context.read<TastedRecordUpdatePresenter>().update().then((value) {
                        if (value) {
                          context.pop(true);
                        } else {
                          showSnackBar(message: '시음기록 수정에 실패했습니다.');
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isValidLastPage ? ColorStyles.black : ColorStyles.gray20,
                      ),
                      child: Text(
                        '수정완료',
                        style: TextStyles.labelMediumMedium.copyWith(
                          color: isValidLastPage ? ColorStyles.white : ColorStyles.gray40,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating({required int star}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('원두 평가', style: TextStyles.title01SemiBold),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  context.read<TastedRecordUpdatePresenter>().onChangeStar(index + 1);
                },
                child: SvgPicture.asset(
                  'assets/icons/star_fill.svg',
                  height: 36,
                  width: 36,
                  colorFilter: ColorFilter.mode(index < star ? ColorStyles.red : ColorStyles.gray50, BlendMode.srcIn),
                ),
              ),
            ).separator(separatorWidget: const SizedBox(width: 8)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('시음 내용', style: TextStyles.title01SemiBold),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 140,
          child: TextFormField(
            focusNode: _focusNode,
            controller: _contentsController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              isDense: true,
              hintText: '원두와 시음 경험에 대한 이야기를 자유롭게 나눠주세요.',
              hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.gray40, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorStyles.gray40, width: 1),
              ),
              disabledBorder: InputBorder.none,
            ),
            style: TextStyles.labelSmallMedium,
            textAlignVertical: TextAlignVertical.top,
            expands: true,
            maxLines: null,
            cursorColor: ColorStyles.black,
            cursorErrorColor: ColorStyles.black,
            cursorHeight: 16,
            cursorWidth: 1,
            onChanged: (newContent) {
              context.read<TastedRecordUpdatePresenter>().onChangeContents(newContent);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHashTag() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('해시태그', style: TextStyles.title01SemiBold),
        const SizedBox(height: 20),
        TextFormField(
          focusNode: _hashTagFocusNode,
          controller: _hashTagController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            HashLimiterFormatter(),
          ],
          decoration: InputDecoration(
            isDense: true,
            hintText: '태그를 입력해보세요.',
            hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray40, width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorStyles.gray40, width: 1),
            ),
            disabledBorder: InputBorder.none,
          ),
          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red),
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          cursorColor: ColorStyles.black,
          cursorErrorColor: ColorStyles.black,
          cursorHeight: 16,
          cursorWidth: 1,
          onChanged: (newHashTag) {
            context.read<TastedRecordUpdatePresenter>().onChangeHashTag(newHashTag);
          },
        ),
      ],
    );
  }

  Widget _buildDate({required DateTime tastedAt}) {
    final dateString = DateFormat('yyyy-MM-dd').format(tastedAt);
    return Row(
      children: [
        const Text('시음 날짜', style: TextStyles.title01SemiBold),
        const Spacer(),
        GestureDetector(
          onTap: () {
            showDatePicker(dateTime: DateTime.now());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 2, left: 8),
            decoration:
                const BoxDecoration(color: ColorStyles.gray30, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Text(dateString, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray80)),
                const SizedBox(width: 2),
                SvgPicture.asset(
                  'assets/icons/arrow.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(ColorStyles.gray80, BlendMode.srcIn),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlace({required String place}) {
    return Row(
      children: [
        const Text('시음 장소', style: TextStyles.title01SemiBold),
        const Spacer(),
        GestureDetector(
          onTap: () {
            _showLocalBeanSearchBottomSheet();
          },
          child: Row(
            children: [
              if (place.isEmpty) ...[
                SvgPicture.asset(
                  'assets/icons/plus_round.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                )
              ] else ...[
                Text(place, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray80)),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    _onChangePlace('');
                  },
                  child: SvgPicture.asset(
                    'assets/icons/x_round.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                  ),
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivate({required bool isPrivate}) {
    return Row(
      children: [
        const Text('나만 보기', style: TextStyles.title01SemiBold),
        const Spacer(),
        SizedBox(
          width: 50,
          height: 30,
          child: CupertinoSwitch(
            value: isPrivate,
            activeColor: ColorStyles.red,
            onChanged: (value) {
              context.read<TastedRecordUpdatePresenter>().onChangePrivate(value);
            },
          ),
        ),
      ],
    );
  }

  showDatePicker({required DateTime dateTime}) async {
    final result = await showBarrierDialog<DateTime>(
      context: context,
      pageBuilder: (context, _, __) => DatePickerBottomSheet(initialDateTime: dateTime),
    );

    if (result != null) {
      _onChangeTastedTime(result);
    }
  }

  _showLocalBeanSearchBottomSheet() async {
    final result = await showBarrierDialog<String>(
      context: context,
      pageBuilder: (context, _, __) {
        return LocalSearchView.build(
          maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
        );
      },
    );

    if (result != null) {
      _onChangePlace(result);
    }
  }

  _onChangePlace(String place) {
    context.read<TastedRecordUpdatePresenter>().onChangePlace(place);
  }

  _onChangeTastedTime(DateTime dateTime) {
    context.read<TastedRecordUpdatePresenter>().onChangeTastedAt(dateTime);
  }

  _onSuccessWrite() {
    context.pop(true);
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
