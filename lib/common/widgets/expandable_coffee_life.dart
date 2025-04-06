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
    return SizedBox(
      height: 26,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
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
                decoration: const BoxDecoration(
                  color: ColorStyles.gray20,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
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
                decoration: const BoxDecoration(
                  color: ColorStyles.gray20,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(
                  child: Text(widget.coffeeLifeList[index], style: TextStyles.captionMediumMedium),
                ),
              );
            }
          }
          return Container();
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemCount: _isExpandable ? widget.coffeeLifeList.length + 1 : widget.maxLength + 1,
      ),
    );
  }
}

/*
return Row(
      children: List<Widget>.generate(
        min(coffeeLife.length, 3),
            (index) {
          if (index == 2) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: ColorStyles.white,
                border: Border.all(color: ColorStyles.gray70),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                child: Text(
                  '+ ${coffeeLife.length - 2}',
                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                ),
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: const BoxDecoration(
                color: ColorStyles.gray20,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                child: Text(coffeeLife[index], style: TextStyles.captionMediumMedium),
              ),
            );
          }
        },
      ).separator(separatorWidget: const SizedBox(width: 4)).toList(),
    );
 */