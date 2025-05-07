import 'dart:convert';
import 'dart:typed_data';

import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/exception/post_exception.dart';
import 'package:brew_buds/model/photo.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';

typedef AppBarState = ({bool isValid, String? errorMessage});
typedef ImageListViewState = ({List<Photo> images, List<TastedRecordInProfile> tastedRecords});
typedef BottomButtonState = ({bool hasImages, List<TastedRecordInProfile> tastedRecords});

final class PostWritePresenter extends Presenter {
  final PostApi postApi = PostApi();
  final PhotoApi photoApi = PhotoApi();
  PostSubject? _subject;
  String _title = '';
  String _content = '';
  String _tag = '';
  List<Photo> _images = [];
  List<TastedRecordInProfile> _tastedRecords = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Photo> get images => _images;

  ImageListViewState get imageListViewState => (images: _images, tastedRecords: _tastedRecords);

  BottomButtonState get bottomsButtonState => (hasImages: _images.isNotEmpty, tastedRecords: _tastedRecords);

  PostSubject? get subject => _subject;

  String? get _errorMessage {
    if (_subject == null) {
      return '게시글 주제를 선택해 주세요.';
    } else if (_title.length < 2) {
      return '제목을 2자 이상 입력해 주세요.';
    } else if (_content.length < 8) {
      return '내용을 8자 이상 입력해주세요.';
    } else {
      return null;
    }
  }

  AppBarState get appBarState => (
        isValid: _subject != null && _title.length >= 2 && _content.length >= 8,
        errorMessage: _errorMessage,
      );

  onChangeSubject(PostSubject subject) {
    _subject = subject;
    notifyListeners();
  }

  onChangeTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  onChangeContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }

  onChangeTag(String newTag) {
    _tag = newTag.replaceAll('#', ',');
  }

  Future<bool> addImages(List<Uint8List> images) async {
    if (_images.length + images.length > 10) {
      return false;
    } else {
      _images = List.from(_images)..addAll(images.map((data) => Photo.withData(data: data)));
      notifyListeners();
      return true;
    }
  }

  bool addImageData(Uint8List imageData) {
    if (_images.length > 9) {
      return false;
    } else {
      _images = List.from(_images)..add(Photo.withData(data: imageData));
      notifyListeners();
      return true;
    }
  }

  onDeleteImageAt(int index) {
    _images = List.from(_images)..removeAt(index);
    notifyListeners();
  }

  onChangeTastedRecords(List<TastedRecordInProfile> tastedRecords) {
    _tastedRecords = List.from(tastedRecords);
    notifyListeners();
  }

  onDeleteTastedRecordAt(int index) {
    _tastedRecords = List.from(_tastedRecords)..removeAt(index);
    notifyListeners();
  }

  Future<void> write() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (_title.length < 2) {
      _isLoading = false;
      notifyListeners();
      throw const InvalidTitleException();
    }

    if (_content.length < 8) {
      _isLoading = false;
      notifyListeners();
      throw const InvalidContentsException();
    }

    if (_images.isNotEmpty && _tastedRecords.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
      throw const MultiUploadException();
    }

    final Map<String, dynamic> data = {};
    data['title'] = _title;
    data['content'] = _content;
    final subjectKey = _subject?.toJsonValue();
    if (subjectKey != null) {
      data['subject'] = subjectKey;
    } else {
      _isLoading = false;
      notifyListeners();
      throw const EmptySubjectException();
    }
    data['tag'] = _tag;



    if (_images.isNotEmpty) {
      try {
        final imageCreatedResult = await _uploadImages();
        if (imageCreatedResult.isNotEmpty) {
          data['photos'] = imageCreatedResult;
        } else {
          _isLoading = false;
          notifyListeners();
          throw const ImageUploadFailedException();
        }
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        throw const ImageUploadFailedException();
      }
    }

    if (_tastedRecords.isNotEmpty) {
      data['tasted_records'] = _tastedRecords.map((tastedRecord) => tastedRecord.id).toList();
    }

    try {
      await postApi.createPost(data: data);
    } catch (e) {
      throw const PostWriteFailedException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<int>> _uploadImages() async {
    final imageDataList = images.whereType<PhotoWithData>().map((photo) => photo.data).toList();
    final List<Uint8List> compressedImageDataList = [];
    for (final imageData in imageDataList) {
      compressedImageDataList.add(await compressList(imageData));
    }
    return photoApi.createPhotos(imageDataList: compressedImageDataList).then(
      (jsonString) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        return jsonList.map((json) => json['id'] as int).toList();
      },
    ).onError((error, stackTrace) => []);
  }
}
