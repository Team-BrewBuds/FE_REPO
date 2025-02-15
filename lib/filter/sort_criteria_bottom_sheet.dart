import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

typedef SortCriteriaItem = (String title, void Function() onTapped);

class SortCriteriaBottomSheet extends StatefulWidget {
  final List<SortCriteriaItem> items;
  final int currentIndex;

  const SortCriteriaBottomSheet({
    super.key,
    required this.items,
    required this.currentIndex,
  });

  @override
  State<SortCriteriaBottomSheet> createState() => _SortCriteriaBottomSheetState();
}

class _SortCriteriaBottomSheetState extends State<SortCriteriaBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(bottom: 64),
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Wrap(
                children: [
                  Container(
                    height: 59,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1))),
                    child: Stack(
                      children: [
                        const Positioned(
                          top: 24,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text('정렬', style: TextStyles.title02SemiBold),
                          ),
                        ),
                        Positioned(
                          top: 21,
                          right: 16,
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/x.svg',
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...List<Widget>.generate(
                    widget.items.length,
                        (index) {
                      return InkWell(
                        onTap: () {
                          widget.items[index].$2();
                          context.pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              Text(
                                widget.items[index].$1,
                                style: TextStyles.labelMediumMedium.copyWith(
                                  color: widget.currentIndex == index
                                      ? ColorStyles.red
                                      : ColorStyles.black,
                                ),
                              ),
                              const Spacer(),
                              widget.currentIndex == index
                                  ? const Icon(Icons.check, size: 18, color: ColorStyles.red)
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
