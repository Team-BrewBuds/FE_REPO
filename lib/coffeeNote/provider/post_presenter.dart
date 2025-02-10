import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../data/repository/post_repository.dart';
import '../controller/custom_controller.dart';

final class PostPresenter extends ChangeNotifier {
  final PostRepository _postRepository;
  TextEditingController titleController = TextEditingController();
  CustomTagController tagController = CustomTagController();
  String _topic ='';

  bool _isTopicSelect = false;
  bool _isEnabled = false;
  bool get isEnabled => _isEnabled;
  bool get isTopicSelect => _isTopicSelect;

  String get title => titleController.text;
  String get tag => tagController.text;
  String get content => tagController.text;
  String get topic =>_topic;


  PostPresenter({required PostRepository postRepository})
      : _postRepository = postRepository {
    selectTopic;
    titleController.addListener(updateButton);
    tagController.addListener(updateButton);
    _topic = '게시글 주제를 선택해주세요';
  }

  // void initState(){
  //   _topic = '게시글 주제를 선택해주세요';
  //   titleController.addListener(updateButton);
  //   tagController.addListener(updateButton);
  //
  // }

  void dispose(){
    super.dispose();
    titleController.dispose();
    tagController.dispose();
  }

  void updateButton() {
    if (_isTopicSelect && titleController.text.length > 1 && tagController.text.length > 7) {
      _isEnabled = true;
    } else {
      _isEnabled = false;
    }

    notifyListeners();
  }

  selectTopic(String ?value) {
      _topic = value!.toString();
      _isTopicSelect = true;
      notifyListeners();

  }

  void isFormVaild(){

  }




  Future<bool> createPost({
    required String title,
    required String content,
    required String subject,
    required String tag,
    required List<double> tasted_recordes,
    required List<double>  photos

}) async {
    Map<String, dynamic> data = {
      "title":title,
      "content":content,
      "subject":subject,
      "tag": "tag",
      "tasted_records" : [1],
      "photos": [1]
    };
    String jsonData = json.encode(data);

    print(jsonData);

    try{
       await _postRepository.createPosts(data: jsonData);
      return true;
    }catch(e){
        print("등록 실패 ${e}");
    }
    return false;


}
}