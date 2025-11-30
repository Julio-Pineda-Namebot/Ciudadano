import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/chats/domain/entities/contact_permission_status.dart";
import "package:ciudadano/features/chats/presentation/bloc/add_chat_contact_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/check_contacts_permission_status_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_chat_contacts_cubit.dart";
import "package:ciudadano/features/chats/presentation/bloc/get_possible_contacts_by_phone_cubit.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart" as hooked;
import "package:permission_handler/permission_handler.dart";

class ChatContactAddPage extends HookWidget {
  const ChatContactAddPage({super.key});

  _buildContactsLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  _buildContactsError(
    String message,
    BuildContext context,
    ContactPermissionStatus? state,
    GetPossibleContactsByPhoneState? contactsState,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Error al cargar contactos",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (contactsState != null) {
                context
                    .read<GetPossibleContactsByPhoneCubit>()
                    .getPossibleContactsByPhone();
                return;
              }

              if (state == ContactPermissionStatus.denied) {
                context
                    .read<CheckContactsPermissionStatusCubit>()
                    .checkPermissionStatus();
              } else if (state == ContactPermissionStatus.permanentlyDenied) {
                openAppSettings();
              }
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContactPermissionView(
    BuildContext context,
    CheckContactsPermissionStatusState state,
    String searchQuery,
    GetChatContactsState getChatContactsState,
  ) {
    if (state.status == null) {
      return _buildContactsLoading();
    }

    if (state.status != ContactPermissionStatus.granted) {
      _buildContactsError(
        "No se han otorgado los permisos necesarios para acceder a los contactos.",
        context,
        state.status,
        null,
      );
    }

    return BlocProvider(
      create:
          (_) =>
              sl<GetPossibleContactsByPhoneCubit>()
                ..getPossibleContactsByPhone(),
      child: BlocBuilder<
        GetPossibleContactsByPhoneCubit,
        GetPossibleContactsByPhoneState
      >(
        builder: (context, state) {
          if (state is GetPossibleContactsByPhoneLoadingState) {
            return _buildContactsLoading();
          }

          if (getChatContactsState is GetChatContactsLoadingState) {
            return _buildContactsLoading();
          }

          if (state is GetPossibleContactsByPhoneErrorState) {
            return _buildContactsError(state.message, context, null, state);
          }

          if (getChatContactsState is GetChatContactsErrorState) {
            return _buildContactsError(
              getChatContactsState.message,
              context,
              null,
              state,
            );
          }

          if (state is GetPossibleContactsByPhoneLoadedState) {
            final filteredContacts =
                state.contacts.where((contact) {
                  if (searchQuery.isEmpty) {
                    return (getChatContactsState as GetChatContactsLoadedState)
                        .contacts
                        .every(
                          (chatContact) => chatContact.phone != contact.phone,
                        );
                  }
                  return (contact.firstName.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          contact.lastName.toLowerCase().contains(
                            searchQuery,
                          ) ||
                          contact.phone.contains(searchQuery)) &&
                      (getChatContactsState as GetChatContactsLoadedState)
                          .contacts
                          .every(
                            (chatContact) => chatContact.phone != contact.phone,
                          );
                }).toList();

            if (filteredContacts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      searchQuery.isEmpty
                          ? Icons.contacts_outlined
                          : Icons.search_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isEmpty
                          ? "No hay contactos disponibles"
                          : "No se encontraron contactos",
                    ),
                  ],
                ),
              );
            }

            return BlocProvider(
              create: (_) => sl<AddChatContactCubit>(),
              child: BlocListener<AddChatContactCubit, AddChatContactState>(
                listener: (context, state) {
                  if (state is AddChatContactSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Contacto ${state.contact.firstName} ${state.contact.lastName} agregado exitosamente",
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else if (state is AddChatContactErrorState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<AddChatContactCubit, AddChatContactState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Text(
                              contact.firstName.isNotEmpty
                                  ? contact.firstName[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            "${contact.firstName} ${contact.lastName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(contact.phone),
                          enabled: state is AddChatContactInitialState,
                          onTap: () {
                            context
                                .read<AddChatContactCubit>()
                                .addChatContactCubit(contact.userId);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = useState<String>("");
    final checkContactsPermissionStatusCubit = useBlocProvider(
      () => sl<CheckContactsPermissionStatusCubit>()..checkPermissionStatus(),
    );
    final checkContactsPermissionStatusState = hooked.useBlocBuilder(
      checkContactsPermissionStatusCubit,
    );
    final getChatContactsCubit = useBlocProvider(
      () => sl<GetChatContactsCubit>()..loadChatContacts(),
    );
    final getChatContactsState = hooked.useBlocBuilder(getChatContactsCubit);

    return BlocProvider.value(
      value: checkContactsPermissionStatusCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text("Agregar contactos")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar contactos...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  searchQuery.value = value.toLowerCase();
                },
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildChatContactPermissionView(
                context,
                checkContactsPermissionStatusState,
                searchQuery.value,
                getChatContactsState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
