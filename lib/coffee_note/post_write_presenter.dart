import 'dart:convert';
import 'dart:io';

import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/model/photo.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

typedef AppBarState = ({bool isValid, String? errorMessage});
typedef BottomButtonState = ({bool hasImages, bool hasTastingRecords});

final class PostWritePresenter extends ChangeNotifier {
  final PostApi postApi = PostApi();
  final PhotoApi photoApi = PhotoApi();
  PostSubject? _subject;
  String _title = '';
  String _content = '';
  String _tag = '';
  List<Photo> _images = [];
  List<TastingRecordInProfile> _tastingRecords = [];

  List<Photo> get images => _images;

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

  Future<bool> addImages(List<AssetEntity> images) async {
    if (_images.length + images.length > 10) {
      return false;
    } else {
      final imageDataList = await Stream.fromIterable(images).asyncMap((image) async => image.originBytes).toList();
      final safeImageDataList = imageDataList.whereType<Uint8List>();
      _images = List.from(_images)..addAll(safeImageDataList.map((data) => Photo.withData(data: data)));
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

  onSyncTastingRecords(List<TastingRecordInProfile> tastingRecords) {
    _tastingRecords = List.from(tastingRecords);
  }

  Future<bool> write() async {
    final Map<String, dynamic> data = {};
    data['title'] = _title;
    data['content'] = _content;
    final subjectKey = _subject?.toJsonValue();
    if (subjectKey != null) {
      data['subject'] = subjectKey;
    }
    data['tag'] = _tag;
    // if (_images.isNotEmpty) {
    //   await _uploadImages();
    // }
    if (_tastingRecords.isNotEmpty) {
      data['tasted_records'] = _tastingRecords.map((tastingRecord) => tastingRecord.id).toList();
    }

    return postApi.createPosts(data: data).then((_) => true).onError(
          (error, stackTrace) {
            return false;
          });
  }

  Future<void> _uploadImages() async {
    final Map<String, dynamic> data = {};
    data['photo_url'] = images.whereType<PhotoWithData>().map((photo) => photo.data).toList();
    await photoApi.createPhotos(data: data).then((jsonString) {
      print(jsonString);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
    });
  }
}
