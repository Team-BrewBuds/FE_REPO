import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
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
  bool _isExpandable = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 4,
        children: List.generate(
          _isExpandable ? widget.coffeeLifeList.length + 1 : widget.maxLength + 1,
          (index) {
            if (_isExpandable) {
              if (index == widget.coffeeLifeList.length) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpandable = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Center(
                      child: Text(
                        '접기',
                        style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: ColorStyles.gray20,
                    border: Border.all(color: ColorStyles.gray20),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Center(
                    child: Text(widget.coffeeLifeList[index], style: TextStyles.captionMediumMedium),
                  ),
                );
              }
            } else {
              if (index == widget.maxLength) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpandable = true;
                    });
                  },
                  child: Container(
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
                );
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: ColorStyles.gray20,
                    border: Border.all(color: ColorStyles.gray20),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Center(
                    child: Text(widget.coffeeLifeList[index], style: TextStyles.captionMediumMedium),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
