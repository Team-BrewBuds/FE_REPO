import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasteGraph extends StatelessWidget {
  final int bodyValue;
  final int acidityValue;
  final int bitternessValue;
  final int sweetnessValue;

  const TasteGraph({
    super.key,
    required this.bodyValue,
    required this.acidityValue,
    required this.bitternessValue,
    required this.sweetnessValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('테이스팅', style: TextStyles.title02SemiBold),
        const SizedBox(height: 24),
        _buildTasteSlider(minText: '가벼운', maxText: '무거운', value: bodyValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '산미약한', maxText: '산미강한', value: acidityValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '쓴맛약한', maxText: '쓴맛강한', value: bitternessValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '단맛약한', maxText: '단맛강한', value: sweetnessValue),
      ],
    );
  }

  Widget _buildTasteSlider({required String minText, required String maxText, required int value}) {
    final activeStyle = TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red);
    final inactiveStyle = TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60);
    return SizedBox(
      height: 16,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 46.sp,
            child: Text(
              minText,
              textAlign: TextAlign.center,
              style: value != 0 && value < 3 ? activeStyle : inactiveStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = (constraints.maxWidth - 12) / 4;
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                          ],
                        ),
                      ),
                      if (value == 1)
                        Positioned(
                          left: 0 - 7,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        )
                      else if (value == 5)
                        Positioned(
                          right: 0 - 7,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        )
                      else if (value > 1 && value < 5)
                        Positioned(
                          left: (barWidth * (value - 1)) + ((value - 2) * 4) - 5,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 46.sp,
            child: Text(
              maxText,
              textAlign: TextAlign.center,
              style: value > 3 ? activeStyle : inactiveStyle,
            ),
          ),
        ],
      ),
    );
  }
}
