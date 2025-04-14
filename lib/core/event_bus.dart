import 'dart:async';

class EventBus {
  EventBus._();

  static final EventBus _instance = EventBus._();

  static EventBus get instance => _instance;

  factory EventBus() => instance;

  final _eventController = StreamController<dynamic>.broadcast();

  Stream<T> on<T>() => _eventController.stream.where((event) => event is T).cast<T>();

  void fire(event) => _eventController.add(event);

  void dispose() => _eventController.close();
}