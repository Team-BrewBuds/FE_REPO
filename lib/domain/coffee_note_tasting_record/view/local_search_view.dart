import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/resizable_bottom_sheet_mixin.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/view/local_search_presenter.dart';
import 'package:brew_buds/model/common/local.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
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

class _LocalSearchViewState extends State<LocalSearchView> with ResizableBottomSheetMixin<LocalSearchView> {
  late final Debouncer<String> searchDebouncer;
  late final Throttle paginationThrottle;
  late final ValueNotifier<String> searchWord;
  late double height;
  late final double maxHeight;
  late final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    textEditingController = TextEditingController();
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
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
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
    context.read<LocalSearchPresenter>().search(newWord);
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              ThrottleButton(
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
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
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
                      child: ThrottleButton(
                        onTap: () {
                          textEditingController.value = const TextEditingValue();
                          _onChangeNewWord('');
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
          _onChangeNewWord(textEditingController.text);
        },
      ),
    );
  }

  Widget _buildLocalResults({required List<Local> localList}) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 14),
      sliver: SliverList.separated(
        itemCount: localList.length,
        itemBuilder: (context, index) {
          final local = localList[index];
          return ThrottleButton(
            onTap: () {
              context.pop(local.name);
            },
            child: Container(
              color: ColorStyles.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

    LocationPermission permission = await Geolocator.requestPermission();
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

  @override
  Widget buildBottomWidget(BuildContext context) => const SizedBox.shrink();

  @override
  List<Widget> buildContents(BuildContext context) {
    return [
      Selector<LocalSearchPresenter, List<Local>>(
        selector: (context, presenter) => presenter.localList,
        builder: (context, localList, child) => _buildLocalResults(localList: localList),
      ),
      Builder(
        builder: (context) {
          final hasNext = context.select<LocalSearchPresenter, bool>((presenter) => presenter.hasNext);
          return hasNext
              ? const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: ColorStyles.gray70,
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter(child: SizedBox(height: 14));
        },
      ),
    ];
  }

  @override
  bool get hasTextField => false;

  @override
  double get initialHeight => widget.maxHeight;

  @override
  double get maximumHeight => widget.maxHeight;

  @override
  double get minimumHeight => widget.maxHeight * 0.7;

  @override
  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels > notification.metrics.maxScrollExtent * 0.7) {
      paginationThrottle.setValue(null);
    }
    return false;
  }
}
