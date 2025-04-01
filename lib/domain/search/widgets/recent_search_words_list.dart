import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef RecentSearchWordsItem = ({String word, void Function() onTap, void Function() onDelete});

class RecentSearchWordsList extends StatelessWidget {
  final int _itemLength;
  final bool _isLoading;
  final RecentSearchWordsItem Function(int index) _itemBuilder;
  final void Function() _onAllDelete;

  const RecentSearchWordsList({
    super.key,
    required int itemLength,
    required bool isLoading,
    required RecentSearchWordsItem Function(int index) itemBuilder,
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
                    const Text('최근 검색어', style: TextStyles.title02SemiBold),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        _onAllDelete();
                      },
                      child: Text('모두 지우기', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 26,
                child: _isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final item = _itemBuilder(index);
                          return GestureDetector(
                            onTap: () {
                              item.onTap.call();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorStyles.gray70),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(item.word, style: TextStyles.captionMediumRegular),
                                  const SizedBox(width: 2),
                                  GestureDetector(
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
                        separatorBuilder: (context, index) => const SizedBox(width: 6),
                        itemCount: _itemLength,
                      ),
              ),
              const SizedBox(height: 28),
            ],
          );
  }
}
