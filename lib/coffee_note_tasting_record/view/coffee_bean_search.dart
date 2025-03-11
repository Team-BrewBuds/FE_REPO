import 'package:brew_buds/coffee_note_tasting_record/view/coffee_bean_search_presenter.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

sealed class CoffeeBeanSearchBottomSheetResult {
  factory CoffeeBeanSearchBottomSheetResult.searched({required CoffeeBean coffeeBean}) = ResultsOfSearched;

  factory CoffeeBeanSearchBottomSheetResult.written({required String name}) = ResultsOfWritten;
}

final class ResultsOfSearched implements CoffeeBeanSearchBottomSheetResult {
  final CoffeeBean coffeeBean;

  const ResultsOfSearched({
    required this.coffeeBean,
  });
}

final class ResultsOfWritten implements CoffeeBeanSearchBottomSheetResult {
  final String name;

  const ResultsOfWritten({
    required this.name,
  });
}

class CoffeeBeanSearchBottomSheet extends StatefulWidget {
  final String initialText;
  final double maxHeight;

  const CoffeeBeanSearchBottomSheet._({
    required this.maxHeight,
    this.initialText = '',
  });

  static Widget build({
    required double maxHeight,
    String initialText = '',
  }) =>
      ChangeNotifierProvider(
        create: (context) => CoffeeBeanSearchPresenter(),
        builder: (context, child) => CoffeeBeanSearchBottomSheet._(
          maxHeight: maxHeight,
          initialText: initialText,
        ),
      );

  @override
  State<CoffeeBeanSearchBottomSheet> createState() => _CoffeeBeanSearchBottomSheetState();
}

class _CoffeeBeanSearchBottomSheetState extends State<CoffeeBeanSearchBottomSheet> {
  late final Debouncer<String> searchDebouncer;
  late final ValueNotifier<String> searchWord;
  late double height;
  late final maxHeight;
  late final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.initialText);
    textEditingController.addListener(() {
      _onChangeNewWord(textEditingController.text);
    });
    searchWord = ValueNotifier(widget.initialText);
    maxHeight = widget.maxHeight;
    height = widget.maxHeight;
    searchDebouncer = Debouncer(
      const Duration(milliseconds: 500),
      initialValue: widget.initialText,
      onChanged: (newWord) {
        _onChangeNewWordDebounce(newWord);
      },
    );
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoffeeBeanSearchPresenter>().search(widget.initialText);
    });
  }

  @override
  void dispose() {
    textEditingController.removeListener(() {
      _onChangeNewWord(textEditingController.text);
    });
    searchDebouncer.cancel();
    textEditingController.dispose();
    searchWord.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _onChangeNewWord(String newWord) {
    searchDebouncer.setValue(newWord);
    searchWord.value = newWord;
  }

  _onChangeNewWordDebounce(String newWord) {
    context.read<CoffeeBeanSearchPresenter>().search(newWord);
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.vertical > 0;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                if (focusNode.hasFocus) {
                  focusNode.unfocus();
                }
              },
              onVerticalDragEnd: (details) {
                if (!keyboardVisible) {
                  if (height > maxHeight * 0.85) {
                    setState(() {
                      height = maxHeight;
                    });
                  } else if (height > maxHeight * 0.3) {
                    setState(() {
                      height = maxHeight * 0.5;
                    });
                  } else {
                    context.pop();
                  }
                }
              },
              onVerticalDragUpdate: (details) {
                final double? delta = details.primaryDelta;
                setState(() {
                  if (delta != null && !keyboardVisible) {
                    height -= delta;
                  }
                });
              },
              child: AnimatedContainer(
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 100),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: ColorStyles.gray40)),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: keyboardVisible ? maxHeight : height,
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildAppBar(),
                      const SizedBox(height: 24),
                      _buildSearchBar(context),
                      Expanded(
                        child: Selector<CoffeeBeanSearchPresenter, CoffeeBeanSearchResult>(
                          selector: (context, presenter) => presenter.result,
                          builder: (context, result, child) => _buildSearchResults(
                            result.searchWord,
                            result.coffeebeans,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Container(
            width: 30,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFC7C7CC),
              borderRadius: BorderRadius.all(Radius.circular(2.5)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(width: 24),
              const Spacer(),
              Text('원두', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/x.svg',
                  height: 24,
                  width: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: textEditingController,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp(r'[a-zA-Zㄱ-ㅎ가-힣0-9 ]'), allow: true),
      ],
      decoration: InputDecoration(
        isDense: true,
        hintText: '원두 추출방식을 입력해주세요.',
        hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
        contentPadding: const EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 4),
        filled: true,
        fillColor: ColorStyles.white,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.gray40),
          borderRadius: BorderRadius.all(Radius.circular(34)),
          gapPadding: 8,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorStyles.gray40),
          borderRadius: BorderRadius.all(Radius.circular(34)),
          gapPadding: 8,
        ),
        prefixIconConstraints: const BoxConstraints(maxWidth: 36, maxHeight: 44),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 4, top: 12, bottom: 12),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(maxWidth: 36, maxHeight: 44),
        suffixIcon: ValueListenableBuilder<String>(
          valueListenable: searchWord,
          builder: (context, searchWord, child) {
            return searchWord.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 12, left: 4, top: 12, bottom: 12),
                    child: InkWell(
                      onTap: () {
                        textEditingController.value = const TextEditingValue();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/x_round.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                      ),
                    ))
                : const SizedBox.shrink();
          },
        ),
      ),
      style: TextStyles.labelSmallMedium,
      maxLines: 1,
      cursorColor: ColorStyles.black,
      cursorErrorColor: ColorStyles.black,
      cursorHeight: 16,
      cursorWidth: 1,
    );
  }

  Widget _buildSearchResults(String searchWord, List<CoffeeBean> coffeeBeans) {
    return coffeeBeans.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: coffeeBeans.length,
            itemBuilder: (context, index) {
              final name = coffeeBeans[index].name ?? '';
              return name.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        context.pop(CoffeeBeanSearchBottomSheetResult.searched(coffeeBean: coffeeBeans[index]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyles.title01SemiBold.copyWith(
                              color: ColorStyles.black,
                              fontWeight: FontWeight.w400,
                            ),
                            children: _getSpans(
                              name,
                              searchWord,
                              TextStyles.title01SemiBold.copyWith(
                                color: ColorStyles.red,
                              ),
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          )
        : Column(
            children: [
              if (searchWord.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchWord,
                          style: TextStyles.title01SemiBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pop(CoffeeBeanSearchBottomSheetResult.written(name: searchWord));
                        },
                        child: SvgPicture.asset(
                          'assets/icons/plus_round.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
            ],
          );
  }

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle textStyle) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord.isEmpty) {
      spans.add(TextSpan(text: text.substring(spanBoundary)));
      return spans;
    }

    do {
      final startIndex = text.indexOf(matchWord, spanBoundary);

      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: textStyle));

      spanBoundary = endIndex;
    } while (spanBoundary < text.length);

    return spans;
  }
}
