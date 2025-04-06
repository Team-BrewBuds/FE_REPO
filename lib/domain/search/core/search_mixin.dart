import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/search/core/search_presenter.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

mixin SearchMixin<T extends StatefulWidget, Presenter extends SearchPresenter>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final TabController tabController;
  late final TextEditingController textEditingController;
  late final FocusNode textFieldFocusNode;
  late final ValueNotifier<bool> showSuggestPage;

  int get initialIndex;

  String get initialText;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: initialIndex);
    textEditingController = TextEditingController(text: initialText);
    textFieldFocusNode = FocusNode();
    showSuggestPage = ValueNotifier(false);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Presenter>().initState();

      showSuggestPage.addListener(() {
        context.read<Presenter>().onChangePageState(showSuggestPage.value);
      });

      textFieldFocusNode.addListener(() {
        if (textFieldFocusNode.hasFocus && !showSuggestPage.value) {
          showSuggestPage.value = true;
        }
      });

      textEditingController.addListener(() {
        context.read<Presenter>().onChangeSearchWord(textEditingController.text);
      });
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.removeListener(() {
      if (textFieldFocusNode.hasFocus && !showSuggestPage.value) {
        showSuggestPage.value = true;
      }
    });
    textEditingController.removeListener(() {
      context.read<Presenter>().onChangeSearchWord(textEditingController.text);
    });
    showSuggestPage.removeListener(() {
      context.read<Presenter>().onChangePageState(showSuggestPage.value);
    });
    tabController.dispose();
    textEditingController.dispose();
    showSuggestPage.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  AppBar buildAppBar({required bool showSuggestPage});

  Widget buildBody();

  onTappedCancelButton();

  onComplete(String searchWord);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showSuggestPage,
      builder: (context, showSuggestPage, child) {
        return GestureDetector(
          onTap: () {
            textFieldFocusNode.unfocus();
          },
          child: Scaffold(
            appBar: buildAppBar(showSuggestPage: showSuggestPage),
            body: showSuggestPage ? _buildSuggestBody() : buildBody(),
          ),
        );
      },
    );
  }

  Widget buildSearchTextFiled() {
    return TextField(
      controller: textEditingController,
      focusNode: textFieldFocusNode,
      maxLines: 1,
      cursorHeight: 16,
      cursorWidth: 1,
      cursorColor: ColorStyles.black,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: '검색어를 입력하세요',
        hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
        fillColor: ColorStyles.gray10,
        filled: true,
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
        contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 4),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
          ),
        ),
        suffixIcon: Selector<Presenter, bool>(
          selector: (context, presenter) => presenter.hasWord,
          builder: (context, hasWord, child) {
            return hasWord
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 4),
                    child: GestureDetector(
                      onTap: () {
                        clearTextField();
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
      onSubmitted: (searchWord) {
        onComplete(searchWord);
      },
    );
  }

  Widget _buildSuggestBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTabBar(),
        const SizedBox(height: 24),
        Expanded(
          child: Selector<Presenter, SuggestState>(
            selector: (context, presenter) => presenter.suggestState,
            builder: (context, suggestState, child) =>
                suggestState.searchWord.isEmpty && suggestState.suggestSearchWords.isEmpty
                    ? const SizedBox.shrink()
                    : suggestState.suggestSearchWords.isNotEmpty
                        ? _buildSuggestSearchWords(
                            suggestSearchWords: suggestState.suggestSearchWords,
                            searchWord: suggestState.searchWord,
                          )
                        : buildEmpty(),
          ),
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
      child: TabBar(
        controller: tabController,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: ColorStyles.black),
        ),
        labelPadding: const EdgeInsets.only(bottom: 4),
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        labelStyle: TextStyles.title01SemiBold,
        labelColor: ColorStyles.black,
        unselectedLabelStyle: TextStyles.title01SemiBold,
        unselectedLabelColor: ColorStyles.gray50,
        dividerHeight: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        tabs: SearchSubject.values
            .map(
              (subject) => Tab(
                height: 16.8,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Center(
                        child: Text(subject.toString(), style: TextStyles.title01SemiBold),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
        onTap: (index) {
          context.read<Presenter>().onChangeTab(index);
        },
      ),
    );
  }

  Widget _buildSuggestSearchWords({required List<String> suggestSearchWords, required String searchWord}) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
      itemCount: suggestSearchWords.length,
      itemBuilder: (context, index) {
        final word = suggestSearchWords[index];
        return GestureDetector(
          onTap: () {
            onSelectedWord(word);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.5),
            child: RichText(
              text: TextSpan(
                style: TextStyles.title01SemiBold.copyWith(
                  color: ColorStyles.black,
                  fontWeight: FontWeight.w400,
                ),
                children: _getSpans(
                  word,
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
        );
      },
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '검색 결과가 없어요',
              style: TextStyles.title01SemiBold,
            ),
            Text(
              '검색어의 철자가 정확한지 확인해 주세요.\n등록되지 않은 원두거나, 해당 검색어와 관련된글이 없으면 검색되지 않을 수 있어요.',
              style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ],
        ),
      ),
    );
  }

  onSelectedWord(String word) {
    textEditingController.value = TextEditingValue(text: word);
    context.read<Presenter>().onChangeSearchWord(word);
    onComplete(word);
  }

  clearTextField() {
    textEditingController.value = TextEditingValue.empty;
    context.read<Presenter>().onChangeSearchWord('');
  }


  showSnackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black90,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
