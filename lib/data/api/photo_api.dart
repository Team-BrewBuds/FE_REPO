import 'dart:typed_data';

import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PhotoApi {
  final Dio _dio;

  PhotoApi._(this._dio);

  factory PhotoApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return PhotoApi._(dio);
  }

  Future<String> createPhotos({required List<Uint8List> imageDataList}) async {
    final formData = FormData();
    for (int index = 0; index < imageDataList.length; index++) {
      final imageData = imageDataList[index];
      formData.files.add(
        MapEntry(
          'photo_url[$index]',
          MultipartFile.fromBytes(imageData, filename: '${DateTime.now()}.png'),
        ),
      );
    }
    final options = Options(method: 'POST', contentType: 'multipart/form-data').compose(
      _dio.options,
      '/records/photo/',
      data: formData,
    );
    final String value;
    try {
      final result = await _dio.fetch<String>(options);
      value = result.data!;
    } catch (e) {
      rethrow;
    }

    return value;
  }

  Future<String> createProfilePhoto({required Uint8List imageData}) async {
    final formData = FormData();
    formData.files.add(
      MapEntry(
        'photo_url',
        MultipartFile.fromBytes(imageData, filename: '${DateTime.now()}.png'),
      ),
    );
    final options = Options(method: 'POST', contentType: 'multipart/form-data').compose(
      _dio.options,
      '/records/photo/profile/',
      data: formData,
    );
    final String value;
    try {
      final result = await _dio.fetch<String>(options);
      value = result.data!;
    } catch (e) {
      rethrow;
    }

    return value;
  }
}
