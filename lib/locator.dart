import 'package:get_it/get_it.dart';
import 'package:movie_corns/api/services/movieAPI.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => MovieApi('movies'));
  locator.registerLazySingleton(() => MovieService());
}
