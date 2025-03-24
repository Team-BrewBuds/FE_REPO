import 'package:brew_buds/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'report_api.g.dart';

@RestApi()
abstract class ReportApi {
  @POST('/interactions/report/{type}/{id}/')
  Future<void> report({
    @Path('type') required String type,
    @Path('id') required int id,
    required Map<String, dynamic> data,
  });

  factory ReportApi() => _ReportApi(DioClient.instance.dio);
}
