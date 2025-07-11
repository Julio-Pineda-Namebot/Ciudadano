import "package:ciudadano/core/network/dio_cliente.dart";
import "package:ciudadano/features/chats/data/repository/chat_repository_impl.dart";
import "package:ciudadano/features/chats/data/source/chat_api_source.dart";
import "package:ciudadano/features/chats/data/source/chat_local_source.dart";
import "package:ciudadano/features/chats/domain/repository/chat_repository.dart";
import "package:ciudadano/features/chats/domain/usecases/create_chat_group_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/get_contacts_by_phone_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/get_groups_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/get_messages_by_group_use_case.dart";
import "package:ciudadano/features/chats/domain/usecases/send_message_to_group_use_case.dart";
import "package:ciudadano/features/chats/presentation/bloc/contacts/chat_contacts_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/create_group/create_chat_group_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/group_messages/group_messages_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/groups/chat_groups_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/send_message_to_group/send_message_to_group_cubit.dart";
import "package:ciudadano/features/events/data/repository/socket_repository_impl.dart";
import "package:ciudadano/features/events/data/source/socket_source.dart";
import "package:ciudadano/features/events/domain/repository/socket_repository.dart";
import "package:ciudadano/features/events/presentation/bloc/socket_bloc.dart";
import "package:ciudadano/features/geolocalization/data/repository/location_repository_impl.dart";
import "package:ciudadano/features/geolocalization/domain/repository/location_repository.dart";
import "package:ciudadano/features/geolocalization/presentation/bloc/location_cubit.dart";
import "package:ciudadano/features/incidents/data/repository/incident_repository_impl.dart";
import "package:ciudadano/features/incidents/data/source/incident_api_service.dart";
import "package:ciudadano/features/incidents/domain/repository/incident_repository.dart";
import "package:ciudadano/features/incidents/domain/usecases/create_incident_use_case.dart";
import "package:ciudadano/features/incidents/domain/usecases/get_nearby_incidents.dart";
import "package:ciudadano/features/incidents/presentation/bloc/create_incident/create_incident_bloc.dart";
import "package:ciudadano/features/incidents/presentation/bloc/nearby_incidents/nearby_incidents_bloc.dart";
import "package:ciudadano/features/profile/presentation/bloc/user_profile_bloc.dart";
import "package:ciudadano/features/sidebar/logout/data/logout_datasource.dart";
import "package:ciudadano/features/sidebar/logout/bloc/logout_bloc.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";

final sl = GetIt.instance;

void setUpServiceLocator() {
  // Utils
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  sl.registerSingleton<DioClient>(DioClient());

  // Sources
  sl.registerSingleton<IncidentApiService>(IncidentApiService());
  sl.registerSingleton<SocketSource>(SocketSource());
  sl.registerSingleton<ChatLocalSource>(ChatLocalSource());
  sl.registerSingleton<ChatApiSource>(ChatApiSource());

  //Repositories
  sl.registerSingleton<LocationRepository>(LocationRepositoryImpl());
  sl.registerSingleton<IncidentRepository>(
    IncidentRepositoryImpl(sl<IncidentApiService>()),
  );
  sl.registerSingleton<SocketRepository>(
    SocketRepositoryImpl(sl<SocketSource>()),
  );
  sl.registerSingleton<ChatRepository>(
    ChatRepositoryImpl(sl<ChatApiSource>(), sl<ChatLocalSource>()),
  );

  // Use Cases
  sl.registerSingleton(GetNearbyIncidentsUseCase(sl<IncidentRepository>()));
  sl.registerSingleton(CreateIncidentUseCase(sl<IncidentRepository>()));
  sl.registerSingleton(GetContactsByPhoneUseCase(sl<ChatRepository>()));
  sl.registerSingleton(GetGroupsUseCase(sl<ChatRepository>()));
  sl.registerSingleton(CreateChatGroupUseCase(sl<ChatRepository>()));
  sl.registerSingleton(GetMessagesByGroupUseCase(sl<ChatRepository>()));
  sl.registerSingleton(SendMessageToGroupUseCase(sl<ChatRepository>()));

  // Cubits and Blocs
  sl.registerLazySingleton(() => LocationCubit(sl<LocationRepository>()));
  sl.registerFactory(
    () => NearbyIncidentsBloc(sl<GetNearbyIncidentsUseCase>()),
  );
  sl.registerFactory(() => CreateIncidentBloc(sl<CreateIncidentUseCase>()));
  sl.registerFactory(() => SocketBloc(sl<SocketRepository>()));
  sl.registerFactory(() => ChatContactsBloc(sl<GetContactsByPhoneUseCase>()));
  sl.registerFactory(() => ChatGroupsBloc(sl<GetGroupsUseCase>()));
  sl.registerFactory(() => CreateChatGroupBloc(sl<CreateChatGroupUseCase>()));
  sl.registerFactory(() => GroupMessagesCubit(sl<GetMessagesByGroupUseCase>()));
  sl.registerFactory(
    () => SendMessageToGroupCubit(sl<SendMessageToGroupUseCase>()),
  );
  sl.registerFactory(() => UserProfileBloc());

  // Logout
  sl.registerSingleton<LogoutDatasource>(LogoutDatasource(sl()));
  sl.registerFactory(() => LogoutBloc(sl()));
}
