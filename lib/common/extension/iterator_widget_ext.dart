import 'package:flutter/material.dart';

extension IterableWidgetExt on Iterable<Widget> {
  Iterable<Widget> separator({required Widget separatorWidget}) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separatorWidget;
        yield iterator.current;
      }
    }
  }
}