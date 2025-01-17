import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef EtcBottomSheetItem = (String text, Color color, void Function() onTapped);

class EtcBottomSheet extends StatelessWidget {
  final List<EtcBottomSheetItem> items;

  const EtcBottomSheet({
    super.key,
    required this.items,
  });

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
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (items.isNotEmpty)
                    ...items.map(
                      (item) => InkWell(
                        onTap: () {
                          item.$3();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          decoration:
                              const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
                          child: Text(
                            item.$1,
                            style: TextStyles.title02SemiBold.copyWith(color: item.$2),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: ButtonFactory.buildRoundedButton(
                      onTapped: () {
                        context.pop();
                      },
                      text: '닫기',
                      style: RoundedButtonStyle.fill(
                        color: ColorStyles.black,
                        textColor: ColorStyles.white,
                        size: RoundedButtonSize.xLarge,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
