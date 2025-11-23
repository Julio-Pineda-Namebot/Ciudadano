import "package:ciudadano/core/api/dio_client.dart";
import "package:ciudadano/core/api/logger_interceptor.dart";
import "package:ciudadano/features/app_shell/presentation/bloc/presentation_cubit.dart";
import "package:ciudadano/features/auth/data/interceptors/auth_interceptor.dart";
import "package:ciudadano/features/auth/data/repositories/auth_repository_impl.dart";
import "package:ciudadano/features/auth/data/sources/auth_api_source.dart";
import "package:ciudadano/features/auth/data/sources/auth_secure_storage_source.dart";
import "package:ciudadano/features/auth/domain/repositories/auth_repository.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_get_profile_if_authenticated.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_login_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_register_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_resend_verification_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_reset_password_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_send_reset_password_email_use_case.dart";
import "package:ciudadano/features/auth/domain/usecases/auth_verify_email_use_case.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:get_it/get_it.dart";
import "package:logger/logger.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

final sl = GetIt.instance;

Future<void> setUpServiceLocator() async {
  // Global
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(const FlutterSecureStorage());
  sl.registerSingleton(
    Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
    ),
  );
  sl.registerSingleton(LoggerInterceptor(sl()));
  sl.registerSingleton(AuthInterceptor());
  sl.registerSingleton(DioClient());

  // Repositories
  sl.registerSingleton(AuthApiSource(sl()));
  sl.registerSingleton(AuthSecureStorageSource(sl()));
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));

  // Use Cases

  // Auth
  sl.registerSingleton(AuthRegisterUseCase(sl()));
  sl.registerSingleton(AuthLoginUseCase(sl()));
  sl.registerSingleton(AuthResetPasswordUseCase(sl()));
  sl.registerSingleton(AuthSendResetPasswordEmailUseCase(sl()));
  sl.registerSingleton(AuthResendVerificationEmailUseCase(sl()));
  sl.registerSingleton(AuthVerifyEmailUseCase(sl()));
  sl.registerSingleton(AuthGetProfileIfAuthenticated(sl()));

  // Blocs / Cubits
  sl.registerFactory(() => PresentationCubit());
  sl.registerFactory(() => AuthCubit(sl()));
}
