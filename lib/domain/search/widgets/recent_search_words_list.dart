import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef SearchHistoryItem = ({String word, void Function() onTap, void Function() onDelete});

class SearchHistoryList extends StatelessWidget {
  final int _itemLength;
  final bool _isLoading;
  final SearchHistoryItem Function(int index) _itemBuilder;
  final void Function() _onAllDelete;

  const SearchHistoryList({
    super.key,
    required int itemLength,
    required bool isLoading,
    required SearchHistoryItem Function(int index) itemBuilder,
    required void Function() onAllDelete,
  })  : _itemLength = itemLength,
        _isLoading = isLoading,
        _itemBuilder = itemBuilder,
        _onAllDelete = onAllDelete;

  @override
  Widget build(BuildContext context) {
    return !_isLoading && _itemLength == 0
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('최근 검색어', style: TextStyles.title02SemiBold),
                    const Spacer(),
                    ThrottleButton(
                      onTap: () {
                        _onAllDelete();
                      },
                      child: Text('모두 지우기', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CupertinoActivityIndicator())
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 6,
                    children: List.generate(
                      _itemLength,
                      (index) {
                        final item = _itemBuilder(index);
                        return ThrottleButton(
                          onTap: () {
                            item.onTap.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: ColorStyles.gray70),
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.word, style: TextStyles.captionMediumRegular),
                                const SizedBox(width: 6),
                                ThrottleButton(
                                  onTap: () {
                                    item.onDelete.call();
                                  },
                                  child: SvgPicture.asset('assets/icons/x.svg', height: 14, width: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 28),
            ],
          );
  }
}
