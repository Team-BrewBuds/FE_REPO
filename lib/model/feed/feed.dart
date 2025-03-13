import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';

sealed class Feed {
  factory Feed.post({required Post data}) = PostFeed;

  factory Feed.tastedRecord({required TastedRecordInFeed data}) = TastedRecordFeed;
}

final class PostFeed implements Feed {
  final Post data;

  PostFeed({required this.data});
}

final class TastedRecordFeed implements Feed {
  final TastedRecordInFeed data;

  TastedRecordFeed({required this.data});
}
