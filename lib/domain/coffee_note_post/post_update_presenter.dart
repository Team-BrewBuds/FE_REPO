import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/mapper/post/post_mapper.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';

typedef AppBarState = ({bool isValid, String? errorMessage});
typedef ImageListViewState = ({List<String> images, List<TastedRecordInPost> tastedRecords});

final class PostUpdatePresenter extends Presenter {
  final PostApi postApi = PostApi();
  Post _post;

  PostUpdatePresenter({
    required Post post,
  }) : _post = post;

  String? get _errorMessage {
    if (_post.title.length < 2) {
      return '제목을 2자 이상 입력해 주세요.';
    } else if (_post.contents.length < 8) {
      return '내용을 8자 이상 입력해주세요.';
    } else {
      return null;
    }
  }

  AppBarState get appBarState => (
        isValid: _post.title.length >= 2 && _post.contents.length >= 8,
        errorMessage: _errorMessage,
      );

  PostSubject get subject => _post.subject;

  ImageListViewState get imageListViewState => (images: _post.imagesUrl, tastedRecords: _post.tastingRecords);

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

  Future<Result<String>> update() async {
    return postApi
        .updatePost(id: _post.id, data: _post.toJson())
        .then((_) => Result.success('게시글이 작성되었습니다.'))
        .onError((error, stackTrace) => Result.error('게시글 작성에 실패했습니다.'));
  }
}
