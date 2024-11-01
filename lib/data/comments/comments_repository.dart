import 'package:brew_buds/data/comments/comments_api.dart';
import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommentsRepository {
  final CommentsApi _api;

  CommentsRepository._() : _api = CommentsApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));

  static final CommentsRepository _instance = CommentsRepository._();

  static CommentsRepository get instance => _instance;

  factory CommentsRepository() => instance;

  Future<CommentsPage> fetchCommentsPage({
    required String feedType,
    required int id,
    required int pageNo,
  }) => _api.fetchCommentsPage(feedType: feedType, id: id, pageNo: pageNo);
}
