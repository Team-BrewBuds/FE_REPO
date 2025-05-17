import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/resizable_bottom_sheet_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/coffee_bean_search_presenter.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
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
  final double initialHeight;
  final double maxHeight;

  const CoffeeBeanSearchBottomSheet._({
    required this.initialHeight,
    required this.maxHeight,
    this.initialText = '',
  });

  static Widget build({
    required double initialHeight,
    required double maxHeight,
    String initialText = '',
  }) =>
      ChangeNotifierProvider(
        create: (context) => CoffeeBeanSearchPresenter(),
        builder: (context, child) => CoffeeBeanSearchBottomSheet._(
          initialHeight: initialHeight,
          maxHeight: maxHeight,
          initialText: initialText,
        ),
      );

  @override
  State<CoffeeBeanSearchBottomSheet> createState() => _CoffeeBeanSearchBottomSheetState();
}

class _CoffeeBeanSearchBottomSheetState extends State<CoffeeBeanSearchBottomSheet>
    with ResizableBottomSheetMixin<CoffeeBeanSearchBottomSheet> {
  late final Throttle paginationThrottle;
  late final ValueNotifier<String> searchWordNotifier;
  late double height;
  late final double maxHeight;
  late final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.initialText);
    searchWordNotifier = ValueNotifier(widget.initialText);
    maxHeight = widget.maxHeight;
    height = widget.initialHeight;
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoffeeBeanSearchPresenter>().search(widget.initialText);
    });
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    textEditingController.dispose();
    searchWordNotifier.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<CoffeeBeanSearchPresenter>().fetchMoreData();
  }

  @override
  bool get hasTextField => false;

  @override
  double get initialHeight => widget.initialHeight;

  @override
  double get maximumHeight => widget.maxHeight;

  @override
  double get minimumHeight => widget.initialHeight;

  @override
  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels > notification.metrics.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
    return false;
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
      child: Column(
        spacing: 24,
        children: [
          Row(
            children: [
              const SizedBox(width: 24),
              const Spacer(),
              Text('원두', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
              const Spacer(),
              ThrottleButton(
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
          _buildSearchBar(context),
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
        hintText: '원두 이름을 입력해 주세요.',
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
          valueListenable: searchWordNotifier,
          builder: (context, searchWord, child) {
            return searchWord.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 12, left: 4, top: 12, bottom: 12),
                    child: ThrottleButton(
                      onTap: () {
                        textEditingController.value = const TextEditingValue();
                        searchWordNotifier.value = '';
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
      onChanged: (text) {
        searchWordNotifier.value = text;
        context.read<CoffeeBeanSearchPresenter>().onChangeSearchWord(text);
      },
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

  @override
  Widget buildBottomWidget(BuildContext context) => const SizedBox.shrink();

  @override
  List<Widget> buildContents(BuildContext context) {
    // final isLoading = context.select<CommentsPresenter, bool>((presenter) => presenter.isLoading);
    return [
      Selector<CoffeeBeanSearchPresenter, CoffeeBeanSearchState>(
        selector: (context, presenter) => presenter.coffeeBeanSearchState,
        builder: (context, state, _) {
          if (state.isLoading && state.coffeebeans.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: CupertinoActivityIndicator(
                  color: ColorStyles.gray70,
                ),
              ),
            );
          } else if (state.coffeebeans.isNotEmpty) {
            final coffeeBeans = state.coffeebeans;
            return SliverList.builder(
              itemCount: coffeeBeans.length,
              itemBuilder: (context, index) {
                final name = coffeeBeans[index].name ?? '';
                return name.isNotEmpty
                    ? ThrottleButton(
                        onTap: () {
                          context.pop(CoffeeBeanSearchBottomSheetResult.searched(coffeeBean: coffeeBeans[index]));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyles.title01SemiBold.copyWith(
                                color: ColorStyles.black,
                                fontWeight: FontWeight.w400,
                              ),
                              children: _getSpans(
                                name,
                                searchWordNotifier.value,
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
            );
          } else {
            return ValueListenableBuilder(
              valueListenable: searchWordNotifier,
              builder: (context, searchWord, _) {
                return searchWord.isNotEmpty
                    ? SliverToBoxAdapter(
                        child: ThrottleButton(
                          onTap: () {
                            context.pop(CoffeeBeanSearchBottomSheetResult.written(name: searchWordNotifier.value));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            color: ColorStyles.white,
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
                                SvgPicture.asset(
                                  'assets/icons/plus_round.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter();
              },
            );
          }
        },
      ),
      Selector<CoffeeBeanSearchPresenter, bool>(
        selector: (context, presenter) => presenter.hasNext,
        builder: (context, hasNext, _) {
          if (hasNext) {
            return const SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: ColorStyles.gray70,
                  ),
                ),
              ),
            );
          } else {
            return const SliverToBoxAdapter();
          }
        },
      ),
    ];
  }
}
