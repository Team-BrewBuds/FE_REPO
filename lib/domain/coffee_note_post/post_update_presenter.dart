import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/domain/coffee_note_post/coffee_note_post_exception.dart';
import 'package:brew_buds/domain/coffee_note_post/model/post_update_model.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';

typedef AppBarState = ({bool canUpdate, String? errorMessage});
typedef ImageListViewState = ({List<String> images, List<TastedRecordInPost> tastedRecords});

final class PostUpdatePresenter extends Presenter {
  final PostApi postApi = PostApi();
  Post _post;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get canUpdate => _post.title.length >= 2 && _post.contents.length >= 8;

  PostSubject get subject => _post.subject;

  ImageListViewState get imageListViewState => (images: _post.imagesUrl, tastedRecords: _post.tastingRecords);

  PostUpdatePresenter({
    required Post post,
  }) : _post = post;

  onChangeSubject(PostSubject subject) {
    _post = _post.copyWith(subject: subject);
    notifyListeners();
  }

  onChangeTitle(String newTitle) {
    _post = _post.copyWith(title: newTitle);
    notifyListeners();
  }

  onChangeContent(String newContent) {
    _post = _post.copyWith(contents: newContent);
    notifyListeners();
  }

  onChangeTag(String newTag) {
    _post = _post.copyWith(tag: newTag.replaceAll('#', ','));
    notifyListeners();
  }

  Future<void> update() async {
    if (_post.title.length < 2) {
      throw ShortTitleLength();
    } else if (_post.contents.length < 8) {
      throw ShortContentsLength();
    }
    _isLoading = true;
    notifyListeners();

    final PostUpdateModel updateModel = PostUpdateModel(
      title: _post.title,
      contents: _post.contents,
      subject: _post.subject,
      tag: _post.tag,
    );

    try {
      await postApi.updatePost(id: _post.id, data: updateModel.toJson());
      EventBus.instance.fire(PostUpdateEvent(senderId: presenterId, id: _post.id, updateModel: updateModel));
    } catch (e) {
      throw ApiError();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
