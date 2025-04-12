import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLine;
  final String expandText;
  final String shrinkText;

  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    required this.maxLine,
    required this.expandText,
    required this.shrinkText,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpandable = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D'),
          style: widget.style,
        );

        final painter = TextPainter(
          maxLines: widget.maxLine,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: span,
        );

        painter.layout(maxWidth: constraints.maxWidth);

        final exceeded = painter.didExceedMaxLines;
        return !exceeded
            ? Text.rich(span, maxLines: 2, overflow: TextOverflow.ellipsis)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _isExpandable
                    ? [
                        Text(widget.text, style: widget.style),
                        const SizedBox(height: 2),
                        ThrottleButton(
                          onTap: () {
                            setState(() {
                              _isExpandable = false;
                            });
                          },
                          child: Text(
                            widget.shrinkText,
                            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray50),
                          ),
                        )
                      ]
                    : [
                        Text.rich(span, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        ThrottleButton(
                          onTap: () {
                            setState(() {
                              _isExpandable = true;
                            });
                          },
                          child: Text(
                            widget.expandText,
                            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.gray50),
                          ),
                        )
                      ],
              );
      },
    );
  }
}
