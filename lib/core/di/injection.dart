import 'package:get_it/get_it.dart';
import '../../features/events/data/services/event_services.dart';
import '../../features/events/presentation/bloc/events_bloc.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => DioClient.getInstance());
  getIt.registerLazySingleton(() => EventService(getIt()));
  getIt.registerFactory(() => EventsBloc(getIt()));
}