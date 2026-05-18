import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core Imports (Relative Path)
import '../network/api_client.dart';

// Features Imports (Relative Path)
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart'; // 🔥 FIX: इम्पोर्ट अब सही जगह सबसे ऊपर आ गया है

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External Dependencies
  sl.registerLazySingleton<Dio>(() => Dio());

  // 2. Core Dependencies
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

  // 3. Auth Feature Dependencies
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<AuthRemoteDataSource>()));
  
  // 4. Bloc Factory
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>())); // 🔥 FIX: यह लाइन अब फंक्शन के अंदर है
}