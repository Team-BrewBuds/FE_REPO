import 'package:brew_buds/core/api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'block_api.g.dart';

@RestApi()
abstract class BlockApi {
  @GET('/interactions/relationship/block/')
  Future<String> fetchBlockList();

  @POST('/interactions/relationship/block/{id}/')
  Future<void> block({
    @Path('id') required int id,
  });

  @DELETE('/interactions/relationship/block/{id}/')
  Future<void> unBlock({
    @Path('id') required int id,
  });

  factory BlockApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _BlockApi(dio);
  }
}
