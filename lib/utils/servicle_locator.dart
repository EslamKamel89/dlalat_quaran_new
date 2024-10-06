import 'package:dio/dio.dart';
import 'package:dlalat_quaran_new/utils/api_service/dio_consumer.dart';
import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;
void initServiceLocator() {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: serviceLocator()));
}
