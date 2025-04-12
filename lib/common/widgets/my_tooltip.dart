import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_tooltip/super_tooltip.dart';

class MyTooltip extends StatefulWidget {
  final String content;
  final Widget child;
  final bool showCancelButton;
  final Duration? duration;

  const MyTooltip({
    super.key,
    required this.content,
    required this.child,
    this.showCancelButton = true,
    this.duration,
  });

  @override
  State<MyTooltip> createState() => _MyTooltipState();
}

class _MyTooltipState extends State<MyTooltip> {
  final tooltipTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 1.4,
    letterSpacing: -0.01,
    color: ColorStyles.white,
  );
  late final SuperTooltipController _superTooltipController;

  @override
  void initState() {
    _superTooltipController = SuperTooltipController();
    super.initState();
  }

  @override
  void dispose() {
    _superTooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThrottleButton(
      onTap: () {
        final duration = widget.duration;
        if (duration != null) {
          Future.delayed(duration, () {
            _superTooltipController.hideTooltip();
          });
        } else {
          _superTooltipController.showTooltip();
        }
      },
      child: SuperTooltip(
        controller: _superTooltipController,
        borderWidth: 0,
        borderRadius: 0,
        borderColor: Colors.transparent,
        showBarrier: false,
        bubbleDimensions: EdgeInsets.zero,
        hasShadow: false,
        arrowBaseWidth: 0,
        arrowLength: 0,
        arrowTipDistance: 12,
        arrowTipRadius: 0,
        minimumOutsideMargin: 0,
        right: 28,
        content: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: ColorStyles.black90,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.content,
                  style: tooltipTextStyle,
                  maxLines: null,
                ),
              ),
              if (widget.showCancelButton) ...[
                const SizedBox(width: 8),
                ThrottleButton(
                  onTap: () {
                    _superTooltipController.hideTooltip();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/x.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                  ),
                ),
              ],
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
