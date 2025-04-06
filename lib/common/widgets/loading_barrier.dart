import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingBarrier extends StatelessWidget {
  final bool hasOpacity;

  const LoadingBarrier({super.key, this.hasOpacity = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (hasOpacity)
          const Opacity(
            opacity: 0.7,
            child: ModalBarrier(dismissible: false, color: ColorStyles.black),
          )
        else
          const ModalBarrier(dismissible: false, color: Colors.transparent),
        const Center(
          child: CupertinoActivityIndicator(
            color: ColorStyles.gray70,
          ),
        ),
      ],
    );
  }
}
