import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:brew_buds/common/styles/color_styles.dart';

class MyRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const MyRefreshControl({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 56,
      refreshIndicatorExtent: 56,
      onRefresh: onRefresh,
      builder: (
          BuildContext context,
          RefreshIndicatorMode refreshState,
          double pulledExtent,
          double refreshTriggerPullDistance,
          double refreshIndicatorExtent,
          ) {
        switch (refreshState) {
          case RefreshIndicatorMode.drag:
            final double percentageComplete = clampDouble(
              pulledExtent / refreshTriggerPullDistance,
              0.0,
              1.0,
            );
            const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
            return Opacity(
              opacity: opacityCurve.transform(percentageComplete),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CupertinoActivityIndicator.partiallyRevealed(
                      progress: percentageComplete,
                      color: ColorStyles.gray70,
                    ),
                  ),
                ),
              ),
            );
          case RefreshIndicatorMode.armed:
          case RefreshIndicatorMode.refresh:
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CupertinoActivityIndicator(color: ColorStyles.gray70),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}