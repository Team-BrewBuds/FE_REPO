import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
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
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 21, left: 16, right: 16, bottom: 14),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ColorStyles.gray20, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 24, height: 24),
                            const Spacer(),
                            Text('정렬', style: TextStyles.title02SemiBold),
                            const Spacer(),
                            ThrottleButton(
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
                          ],
                        ),
                      ),
                      ...List<Widget>.generate(
                        widget.items.length,
                        (index) {
                          return ThrottleButton(
                            onTap: () {
                              widget.items[index].$2();
                              context.pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              color: ColorStyles.white,
                              child: Row(
                                children: [
                                  Text(
                                    widget.items[index].$1,
                                    style: TextStyles.labelMediumMedium.copyWith(
                                      color: widget.currentIndex == index ? ColorStyles.red : ColorStyles.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  widget.currentIndex == index
                                      ? const Icon(Icons.check, size: 18, color: ColorStyles.red)
                                      : const SizedBox.shrink(),
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
          ),
        ),
      ],
    );
  }
}
