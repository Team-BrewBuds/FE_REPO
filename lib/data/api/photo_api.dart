import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'photo_api.g.dart';

@RestApi()
abstract class PhotoApi {
  @POST('/records/photo/')
  Future<String> createPhotos({
    @Body() required Map<String, dynamic> data
  });


  @PUT('/records/post/')
  Future<void> updatePhotos({
    @Query('object_id') required int id,
    @Query('object_type') required String type,
    @Body() required Map<String, dynamic> data
  });

  @DELETE('/records/post/')
  Future<void> deletePhotos({
    @Query('object_id') required int id,
    @Query('object_type') required String type,
  });

  factory PhotoApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _PhotoApi(dio);
  }
}
