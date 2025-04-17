import 'package:brew_buds/model/tasted_record/tasted_record.dart';

sealed class TastedRecordEvent {
  String get senderId;
}

final class TastedRecordCreateEvent implements TastedRecordEvent {
  @override
  final String senderId;

  const TastedRecordCreateEvent({
    required this.senderId,
  });
}

final class TastedRecordDeleteEvent implements TastedRecordEvent {
  @override
  final String senderId;
  final int id;

  const TastedRecordDeleteEvent({
    required this.senderId,
    required this.id,
  });
}

final class TastedRecordUpdateEvent implements TastedRecordEvent {
  @override
  final String senderId;
  final TastedRecord tastedRecord;

  const TastedRecordUpdateEvent({
    required this.senderId,
    required this.tastedRecord,
  });
}

final class TastedRecordLikeEvent implements TastedRecordEvent {
  @override
  final String senderId;
  final int id;
  final bool isLiked;
  final int likeCount;

  const TastedRecordLikeEvent({
    required this.senderId,
    required this.id,
    required this.isLiked,
    required this.likeCount,
  });
}

final class TastedRecordSaveEvent implements TastedRecordEvent {
  @override
  final String senderId;
  final int id;
  final bool isSaved;

  const TastedRecordSaveEvent({
    required this.senderId,
    required this.id,
    required this.isSaved,
  });
}
