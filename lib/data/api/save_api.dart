import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'save_api.g.dart';

@RestApi()
abstract class SaveApi {
  @POST('/interactions/note/{type}/{id}/')
  Future<void> save({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  @DELETE('/interactions/note/{type}/{id}/')
  Future<void> unSave({
    @Path('type') required String type,
    @Path('id') required int id,
  });

  factory SaveApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _SaveApi(dio);
  }
}
