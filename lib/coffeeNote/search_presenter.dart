import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SearchPresenter extends ChangeNotifier {

 String value = '제발';
  // StreamController 선언
  final StreamController<Map<String, dynamic>> _searchResultsController =
      StreamController.broadcast();

  // 스트림을 외부에서 사용할 수 있도록 getter 제공
  Stream<Map<String, dynamic>> get searchResultsStream =>
      _searchResultsController.stream;



  // 검색 함수
  Future<void> searchBean(String beanName) async {
    if (beanName.isEmpty) return; // 검색어가 없으면 호출하지 않음
    int page = 1;
    final url =
        'http://13.125.233.210/beans/search?name=$beanName&page=$page';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // 응답을 UTF-8로 디코딩
        String decodedResponse = utf8.decode(response.bodyBytes);
        Map<String, dynamic> results =
            json.decode(decodedResponse); // 응답을 파싱하여 저장

        if (results['results'] != null && results['results'].isNotEmpty) {
          // 결과가 존재하면 스트림으로 데이터 전송
          _searchResultsController.sink.add(results);
        } else {
          _searchResultsController.sink.add({}); // 결과가 없으면 빈 리스트로 설정

        }

        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      _searchResultsController.sink.addError('Failed to load data'); // 에러 처리
    }
  }

  // 리소스 정리
  void dispose() {
    _searchResultsController.close();
    super.dispose();
  }

}
