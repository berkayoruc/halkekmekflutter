import 'package:get_it/get_it.dart';
import 'location.dart';

GetIt getIt = GetIt.instance;

void setupLocators() {
  getIt.registerLazySingleton(() => LocationService());
}