import "package:ciudadano/common/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/presentation/bloc/contacts/chat_contacts_bloc.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class ContactSelectionPage extends HookWidget {
  final List<ChatContact> selectedContacts;

  const ContactSelectionPage({super.key, required this.selectedContacts});

  @override
  Widget build(BuildContext context) {
    final selectedContactIds = useState<Set<String>>(
      selectedContacts.map((contact) => contact.id).toSet(),
    );
    final searchQuery = useState<String>("");
    final chatContactBloc = useBlocProvider(
      () => sl<ChatContactsBloc>()..add(const LoadChatContacts()),
    );

    // useEffect(() {
    //   if (chatContactsBlocInstance.state is! ChatContactsLoading) {
    //     chatContactsBlocInstance.add(const LoadChatContacts());
    //   }
    //   return null;
    // }, [selectedContactIds]);

    return BlocProvider.value(
      value: chatContactBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Seleccionar contactos",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Obtener contactos seleccionados del estado actual
                final state = chatContactBloc.state;

                if (state is ChatContactsLoaded) {
                  final selected =
                      state.contacts
                          .where(
                            (contact) =>
                                selectedContactIds.value.contains(contact.id),
                          )
                          .toList();
                  Navigator.of(context).pop(selected);
                }
              },
              child: Text(
                "Listo (${selectedContactIds.value.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
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
                  const SizedBox(height: 8),
                  // Contador de contactos seleccionados
                  if (selectedContactIds.value.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Text(
                        "${selectedContactIds.value.length} contacto(s) seleccionado(s)",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Lista de contactos
            Expanded(
              child: BlocBuilder<ChatContactsBloc, ChatContactsState>(
                builder: (context, state) {
                  if (state is ChatContactsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatContactsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Error al cargar contactos",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChatContactsBloc>().add(
                                const LoadChatContacts(),
                              );
                            },
                            child: const Text("Reintentar"),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ChatContactsLoaded) {
                    // Filtrar contactos según la búsqueda
                    final filteredContacts =
                        state.contacts.where((contact) {
                          if (searchQuery.value.isEmpty) {
                            return true;
                          }
                          return contact.name.toLowerCase().contains(
                                searchQuery.value,
                              ) ||
                              contact.phone.contains(searchQuery.value);
                        }).toList();

                    if (filteredContacts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              searchQuery.value.isEmpty
                                  ? Icons.contacts_outlined
                                  : Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.value.isEmpty
                                  ? "No hay contactos disponibles"
                                  : "No se encontraron contactos",
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        final isSelected = selectedContactIds.value.contains(
                          contact.id,
                        );

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[300],
                            child:
                                isSelected
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                    : Text(
                                      contact.name.isNotEmpty
                                          ? contact.name[0].toUpperCase()
                                          : "?",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                          title: Text(
                            contact.name.isNotEmpty
                                ? contact.name
                                : "Sin nombre",
                            style: TextStyle(
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(contact.phone),
                          trailing:
                              isSelected
                                  ? Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                  : const Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.grey,
                                  ),
                          onTap: () {
                            final currentSelected = Set<String>.from(
                              selectedContactIds.value,
                            );
                            if (isSelected) {
                              currentSelected.remove(contact.id);
                            } else {
                              currentSelected.add(contact.id);
                            }
                            selectedContactIds.value = currentSelected;
                          },
                        );
                      },
                    );
                  }

                  // Estado inicial o cualquier otro estado
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Cargando contactos..."),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
