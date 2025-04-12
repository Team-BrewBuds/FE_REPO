import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';

class ExpandableCoffeeLife extends StatefulWidget {
  final List<String> coffeeLifeList;
  final int maxLength;

  @override
  State<ExpandableCoffeeLife> createState() => _ExpandableCoffeeLifeState();

  const ExpandableCoffeeLife({
    super.key,
    required this.coffeeLifeList,
    required this.maxLength,
  });
}

class _ExpandableCoffeeLifeState extends State<ExpandableCoffeeLife> {
  final ValueNotifier<bool> _expandedNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder(
          valueListenable: _expandedNotifier,
          builder: (context, isExpanded, _) {
            return Row(
              spacing: 4,
              children: [
                if (isExpanded)
                  ...widget.coffeeLifeList.map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: ColorStyles.gray20,
                        border: Border.all(color: ColorStyles.gray20),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(
                        child: Text(e, style: TextStyles.captionMediumMedium),
                      ),
                    ),
                  )
                else
                  ...widget.coffeeLifeList.sublist(0, min(widget.coffeeLifeList.length, widget.maxLength)).map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: ColorStyles.gray20,
                            border: Border.all(color: ColorStyles.gray20),
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Center(
                            child: Text(e, style: TextStyles.captionMediumMedium),
                          ),
                        ),
                      ),
                if (widget.coffeeLifeList.length > widget.maxLength)
                  ThrottleButton(
                    onTap: () {
                      _expandedNotifier.value = !_expandedNotifier.value;
                    },
                    child: isExpanded
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Center(
                              child: Text(
                                '접기',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: ColorStyles.white,
                              border: Border.all(color: ColorStyles.gray70),
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(
                              child: Text(
                                '+ ${widget.coffeeLifeList.length - widget.maxLength}',
                                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                              ),
                            ),
                          ),
                  ),
              ],
            );
          }),
    );
  }
}
