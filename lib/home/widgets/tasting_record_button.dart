import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastingRecordButton extends StatelessWidget {
  final String _name;
  final String _bodyText;
  final void Function() _onTap;

  const TastingRecordButton({
    super.key,
    required String name,
    required String bodyText,
    required void Function() onTap,
  })  : _name = name,
        _bodyText = bodyText,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Container(
        color: ColorStyles.gray10,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('시음기록', style: TextStyles.titleMediumSemiBold),
                      const SizedBox(width: 6),
                      Container(width: 1, height: 12, color: ColorStyles.black),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _name,
                          style: TextStyles.titleMediumSemiBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _bodyText,
                    style: TextStyles.textMediumRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/arrow.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
