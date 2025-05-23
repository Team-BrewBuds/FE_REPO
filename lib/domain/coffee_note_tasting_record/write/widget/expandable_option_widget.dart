import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandableOptionWidget extends StatefulWidget {
  final String title;
  final Widget expandableChild;
  final bool hasBottomBorder;
  final Function(GlobalKey key)? onExpanded;

  const ExpandableOptionWidget({
    super.key,
    required this.title,
    required this.expandableChild,
    this.hasBottomBorder = true,
    this.onExpanded,
  });

  @override
  State<ExpandableOptionWidget> createState() => _ExpandableOptionWidgetState();
}

class _ExpandableOptionWidgetState extends State<ExpandableOptionWidget> {
  final ValueNotifier<bool> _isExpandableNotifier = ValueNotifier(false);

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    _isExpandableNotifier.addListener(() {
      if (_isExpandableNotifier.value) {
        widget.onExpanded?.call(_globalKey);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isExpandableNotifier,
      builder: (context, isExpandable, child) {
        return Container(
          key: _globalKey,
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: isExpandable ? 24 : 12),
          decoration: BoxDecoration(
            color: ColorStyles.gray10,
            border: widget.hasBottomBorder ? const Border(bottom: BorderSide(color: ColorStyles.gray30)) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThrottleButton(
                onTap: () {
                  _isExpandableNotifier.value = !_isExpandableNotifier.value;
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.title} (선택)',
                        style: TextStyles.labelSmallMedium,
                      ),
                    ),
                    SvgPicture.asset(
                      isExpandable ? 'assets/icons/minus_round.svg' : 'assets/icons/plus_round.svg',
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
              if (isExpandable)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: widget.expandableChild,
                ),
            ],
          ),
        );
      },
    );
  }
}
