import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
}
