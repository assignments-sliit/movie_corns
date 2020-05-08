import 'package:get_it/get_it.dart';
import 'package:movie_corns/api/services/movieAPI.dart';

/*
 * IT17050272 - D. Manoj Kumar | IT17143950 - G.M.A.S. Bastiansz
 * 
 * Includes all the locators
 */

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => MovieApi('movies'));
  locator.registerLazySingleton(() => MovieService());
}
