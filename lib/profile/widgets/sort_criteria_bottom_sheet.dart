import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SortCriteriaBottomSheet extends StatefulWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const SortCriteriaBottomSheet({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
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
              height: 294,
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Column(
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
                  Column(children: List<Widget>.generate(widget.itemCount, widget.itemBuilder),),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
