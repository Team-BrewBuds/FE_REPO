import 'dart:async';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

class HybridBounceClampingScrollPhysics extends ScrollPhysics {
  final bool Function(ScrollMetrics metrics, double delta) shouldHandleBySheet;

  const HybridBounceClampingScrollPhysics({
    super.parent,
    required this.shouldHandleBySheet,
  });

  @override
  HybridBounceClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HybridBounceClampingScrollPhysics(
      parent: buildParent(ancestor),
      shouldHandleBySheet: shouldHandleBySheet,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (shouldHandleBySheet(position, offset)) {
      return 0.0; // 스크롤 무시 (우리가 바텀시트에 위임)
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}

mixin ResizableBottomSheetMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey _bottomWidgetKey = GlobalKey();
  final ValueNotifier<double> _bottomWidgetHeightNotifier = ValueNotifier(0);
  late final ScrollController _scrollController;
  late final StreamSubscription<bool> _keyboardSubscription;
  late double _height;
  bool _longAnimation = false;
  bool _scrollStartedAtTop = false;

  double get maximumHeight;

  double get minimumHeight;

  double get initialHeight;

  bool get hasTextField;

  String get title;

  bool get isAtTop => _scrollController.hasClients && _scrollController.offset <= 0;

  @override
  void initState() {
    _height = initialHeight;
    _scrollController = ScrollController();
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _height = maximumHeight;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomWidgetHeight());
    super.initState();
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateBottomWidgetHeight() {
    final context = _bottomWidgetKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    final newHeight = box?.size.height ?? 0;

    if (newHeight != _bottomWidgetHeightNotifier.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bottomWidgetHeightNotifier.value = newHeight;
      });
    }
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _scrollStartedAtTop = _scrollController.offset <= 0;
    }
    if (notification is ScrollEndNotification) {
      if (_height < minimumHeight * 0.5) {
        context.pop();
      } else {
        final target =
            (_height - minimumHeight).abs() < (_height - maximumHeight).abs() ? minimumHeight : maximumHeight;

        setState(() {
          _height = target;
          _longAnimation = true;
        });
      }
    }

    return false;
  }

  Widget buildContents(BuildContext context);

  Widget buildBottomWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onVerticalDragStart: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onVerticalDragEnd: (_) {
                if (_height < minimumHeight * 0.5) {
                  context.pop();
                } else {
                  final target =
                      (_height - minimumHeight).abs() < (_height - maximumHeight).abs() ? minimumHeight : maximumHeight;

                  setState(() {
                    _height = target;
                    _longAnimation = true;
                  });
                }
              },
              onVerticalDragUpdate: (details) {
                final double? delta = details.primaryDelta;

                if (delta != null) {
                  setState(() {
                    _height = _height - delta;
                    _longAnimation = true;
                  });
                }
              },
              child: AnimatedContainer(
                curve: Curves.bounceOut,
                onEnd: () {
                  if (_longAnimation) {
                    setState(() {
                      _longAnimation = false;
                    });
                  }
                },
                duration: const Duration(milliseconds: 100),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: ColorStyles.gray40)),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                width: double.infinity,
                height: _height,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                          color: ColorStyles.gray70,
                          borderRadius: BorderRadius.all(Radius.circular(21)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Text(title, style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.black)),
                      ),
                      Container(height: 1, color: ColorStyles.gray10),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: onScrollNotification,
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: HybridBounceClampingScrollPhysics(
                              parent: const BouncingScrollPhysics(),
                              shouldHandleBySheet: (metrics, offset) {
                                final bool isPullingDown = offset > 0;
                                if (isPullingDown) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                if (_scrollStartedAtTop && isPullingDown) {
                                  setState(() {
                                    _height = (_height - offset);
                                    _longAnimation = true;
                                  });
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                            ),
                            slivers: [
                              buildContents(context),
                            ],
                          ),
                        ),
                      ),
                      if (hasTextField)
                        ValueListenableBuilder(
                          valueListenable: _bottomWidgetHeightNotifier,
                          builder: (context, height, _) {
                            final isTextFieldPinned = _height >= minimumHeight;
                            if (isTextFieldPinned) {
                              return SizedBox(height: height);
                            } else {
                              if (height - (minimumHeight - _height) > 0) {
                                return SizedBox(height: height - (minimumHeight - _height));
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasTextField)
          Positioned(
            left: 0,
            right: 0,
            bottom: _height < minimumHeight
                ? MediaQuery.of(context).viewInsets.bottom - (minimumHeight - _height)
                : MediaQuery.of(context).viewInsets.bottom, // 키보드 위에 표시
            child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                _updateBottomWidgetHeight();
                return true;
              },
              child: SizeChangedLayoutNotifier(
                child: Material(
                  key: _bottomWidgetKey,
                  color: ColorStyles.white,
                  child: buildBottomWidget(context),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
