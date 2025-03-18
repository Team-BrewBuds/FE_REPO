import 'dart:convert';

import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:brew_buds/model/photo.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:flutter/foundation.dart';

typedef AppBarState = ({bool isValid, String? errorMessage});
typedef ImageListViewState = ({List<Photo> images, List<TastedRecordInProfile> tastedRecords});
typedef BottomButtonState = ({bool hasImages, List<TastedRecordInProfile> tastedRecords});

final class PostWritePresenter extends ChangeNotifier {
  final PostApi postApi = PostApi();
  final PhotoApi photoApi = PhotoApi();
  PostSubject? _subject;
  String _title = '';
  String _content = '';
  String _tag = '';
  List<Photo> _images = [];
  List<TastedRecordInProfile> _tastedRecords = [];

  List<Photo> get images => _images;

  ImageListViewState get imageListViewState => (images: _images, tastedRecords: _tastedRecords);

  BottomButtonState get bottomsButtonState => (hasImages: _images.isNotEmpty, tastedRecords: _tastedRecords);

  PostSubject? get subject => _subject;

  String? get _errorMessage {
    if (_subject == null) {
      return '게시물 주제를 선택해주세요.';
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

  Future<Result<String>> write() async {
    final Map<String, dynamic> data = {};
    data['title'] = _title;
    data['content'] = _content;
    final subjectKey = _subject?.toJsonValue();
    if (subjectKey != null) {
      data['subject'] = subjectKey;
    } else {
      return Result.error('게시물 주제를 선택해주세요.');
    }
    data['tag'] = _tag;

    if (_images.isNotEmpty && _tastedRecords.isNotEmpty) {
      return Result.error('사진, 시음기록 중 한 종류만 첨부할 수 있어요.');
    }

    if (_images.isNotEmpty) {
      final List<int> imageCreatedResult = await _uploadImages();
      if (imageCreatedResult.isNotEmpty) {
        data['photos'] = imageCreatedResult;
      } else {
        return Result.error('사진 등록 실패.');
      }
    }

    if (_tastedRecords.isNotEmpty) {
      data['tasted_records'] = _tastedRecords.map((tastedRecord) => tastedRecord.id).toList();
    }

    return postApi
        .createPost(data: data)
        .then((_) => Result.success('게시글이 작성되었습니다.'))
        .onError((error, stackTrace) => Result.error('게시글 작성에 실패했습니다.'));
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
