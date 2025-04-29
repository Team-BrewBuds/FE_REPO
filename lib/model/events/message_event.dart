import 'package:flutter/material.dart';

final class MessageEvent {
  final BuildContext context;
  final String message;

  const MessageEvent({
    required this.context,
    required this.message,
  });
}