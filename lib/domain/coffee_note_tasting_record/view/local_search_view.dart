import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/local_search_presenter.dart';
import 'package:brew_buds/model/common/local.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LocalSearchView extends StatefulWidget {
  final double maxHeight;

  const LocalSearchView._({
    required this.maxHeight,
  });

  @override
  State<LocalSearchView> createState() => _LocalSearchViewState();

  static Widget build({required double maxHeight}) => ChangeNotifierProvider(
        create: (context) => LocalSearchPresenter(),
        builder: (context, child) => LocalSearchView._(
          maxHeight: maxHeight,
        ),
      );
}

class _LocalSearchViewState extends State<LocalSearchView> {
  late final Debouncer<String> searchDebouncer;
  late final Throttle paginationThrottle;
  late final ValueNotifier<String> searchWord;
  late double height;
  late final maxHeight;
  late final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      _onChangeNewWord(textEditingController.text);
    });
    maxHeight = widget.maxHeight;
    height = widget.maxHeight;
    searchWord = ValueNotifier('');
    searchDebouncer = Debouncer(
      const Duration(milliseconds: 500),
      initialValue: '',
      onChanged: (newWord) {
        _onChangeNewWordDebounce(newWord);
      },
    );
    paginationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LocalSearchPresenter>().initState();
    });
  }

  @override
  void dispose() {
    textEditingController.removeListener(() {
      _onChangeNewWord(textEditingController.text);
    });
    searchDebouncer.cancel();
    paginationThrottle.cancel();
    textEditingController.dispose();
    searchWord.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<LocalSearchPresenter>().fetchMoreData();
  }

  _onChangeNewWord(String newWord) {
    searchDebouncer.setValue(newWord);
    searchWord.value = newWord;
  }

  _onChangeNewWordDebounce(String newWord) {
    if (newWord.isNotEmpty) {
      context.read<LocalSearchPresenter>().search(newWord);
    }
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
                      const SizedBox(height: 12),
                      Expanded(
                        child: Selector<LocalSearchPresenter, List<Local>>(
                          selector: (context, presenter) => presenter.page.results,
                          builder: (context, localList, child) => _buildLocalResults(localList: localList),
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
              GestureDetector(
                onTap: () async {
                  await _locateMe();
                },
                child: SvgPicture.asset(
                  'assets/icons/my_location.svg',
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                ),
              ),
              const Spacer(),
              Text('위치', style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black)),
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
        hintText: '시음 장소를 검색하세요',
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
                    child: GestureDetector(
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

  Widget _buildLocalResults({required List<Local> localList}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
          paginationThrottle.setValue(null);
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: localList.length,
        itemBuilder: (context, index) {
          final local = localList[index];
          return GestureDetector(
            onTap: () {
              context.pop(local.name);
            },
            child: Container(
              color: ColorStyles.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(local.name, style: TextStyles.labelMediumMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (local.distance.isNotEmpty) ...[
                        Text(local.distance, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50)),
                        Text('・', style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray50)),
                      ],
                      Text(local.address, style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray50)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 20),
      ),
    );
  }

  Future<void> _locateMe() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final context = this.context;
    if (context.mounted) {
      context.read<LocalSearchPresenter>().setMyLocation(x: '${position.longitude}', y: '${position.latitude}');
    }
  }
}
