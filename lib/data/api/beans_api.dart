import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_detail_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retrofit/retrofit.dart';

part 'beans_api.g.dart';

@RestApi()
abstract class BeansApi {
  @GET('/beans/profile/{id}/')
  Future<String> fetchBeans({
    @Path('id') required int id,
    @Query('page') required int pageNo,
    @Query('avg_star_max') double? starMax,
    @Query('avg_star_min') double? starMin,
    @Query('bean_type') String? beanType,
    @Query('is_decaf') bool? isDecaf,
    @Query('ordering') String? ordering,
    @Query('origin_country') String? country,
    @Query('roast_point_max') double? roastingPointMax,
    @Query('roast_point_min') double? roastingPointMin,
  });

  @GET('/beans/search/')
  Future<String> searchBeans({
    @Query('name') String? name,
    @Query('page') required int pageNo,
  });

  @GET('/beans/{id}/')
  Future<CoffeeBeanDetailDTO> fetchBeanDetail({
    @Path('id') required int id,
  });

  @GET('beans/{id}/tasted_records/')
  Future<String> fetchTastedRecordsForCoffeeBean({
    @Path('id') required int id,
  });

  factory BeansApi() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return _BeansApi(dio);
  }
}
