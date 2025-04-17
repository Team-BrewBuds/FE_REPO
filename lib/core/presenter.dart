import 'package:brew_buds/core/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class Presenter extends ChangeNotifier {
  final String presenterId = const Uuid().v4();
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
