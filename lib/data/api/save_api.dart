import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
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

  factory SaveApi() => _SaveApi(DioClient.instance.dio);
}
