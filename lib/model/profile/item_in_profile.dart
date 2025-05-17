import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/noted/noted_object.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';

sealed class ItemInProfile {}

final class TastedRecordInProfileItem implements ItemInProfile {
  final TastedRecordInProfile data;

  TastedRecordInProfileItem({required this.data});
}

final class PostInProfileItem implements ItemInProfile {
  final PostInProfile data;

  PostInProfileItem({required this.data});
}

final class SavedBeanInProfileItem implements ItemInProfile {
  final BeanInProfile data;

  SavedBeanInProfileItem({required this.data});
}

final class SavedNoteInProfileItem implements ItemInProfile {
  final NotedObject data;

  SavedNoteInProfileItem({required this.data});
}
