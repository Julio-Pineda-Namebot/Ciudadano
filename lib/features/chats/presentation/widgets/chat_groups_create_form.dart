import "package:ciudadano/features/chats/data/model/create_chat_group_model.dart";
import "package:ciudadano/features/chats/domain/entity/chat_contact.dart";
import "package:ciudadano/features/chats/presentation/bloc/create_group/create_chat_group_bloc.dart";
import "package:ciudadano/features/chats/presentation/bloc/groups/chat_groups_bloc.dart";
import "package:ciudadano/features/chats/presentation/pages/contact_selection_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_hooks_bloc/flutter_hooks_bloc.dart";

class ChatGroupsCreateForm extends HookWidget {
  const ChatGroupsCreateForm({super.key});

  void _createGroup(
    BuildContext context,
    String groupName,
    String groupDescription,
    List<ChatContact> contacts,
  ) {
    context.read<CreateChatGroupBloc>().add(
      SubmitCreateChatGroupEvent(
        CreateChatGroupModel(
          name: groupName,
          description: groupDescription,
          members: contacts.map((contact) => contact.id).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedContacts = useState<List<ChatContact>>([]);
    final groupName = useState<String>("");
    final groupDescription = useState<String>("");

    return BlocProvider(
      create: (context) => sl<CreateChatGroupBloc>(),
      child: BlocListener<CreateChatGroupBloc, CreateChatGroupState>(
        listener: (context, state) {
          if (state is SuccessCreateChatGroupState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Grupo creado exitosamente")),
            );
            Navigator.of(context).pop();
          } else if (state is FailureCreateChatGroupState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Nombre del grupo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                onChanged: (value) {
                  groupName.value = value;
                },
              ),
              const SizedBox(height: 16),
              // Campo para selección de contactos
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(
                    context,
                  ).push<List<ChatContact>>(
                    MaterialPageRoute(
                      builder:
                          (context) => ContactSelectionPage(
                            selectedContacts: selectedContacts.value,
                          ),
                    ),
                  );

                  if (result != null) {
                    selectedContacts.value = result;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_add, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedContacts.value.isEmpty
                                  ? "Seleccionar miembros"
                                  : "${selectedContacts.value.length} contacto(s) seleccionado(s)",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    selectedContacts.value.isEmpty
                                        ? Colors.grey[600]
                                        : Colors.black,
                              ),
                            ),
                            if (selectedContacts.value.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                selectedContacts.value
                                        .take(3)
                                        .map((contact) => contact.name)
                                        .join(", ") +
                                    (selectedContacts.value.length > 3
                                        ? " y ${selectedContacts.value.length - 3} más"
                                        : ""),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Descripción del grupo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                onChanged: (value) {
                  groupDescription.value = value;
                },
              ),
              const SizedBox(height: 20),
              // Mostrar contactos seleccionados de forma visual
              if (selectedContacts.value.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedContacts.value.length,
                    itemBuilder: (context, index) {
                      final contact = selectedContacts.value[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    contact.name.isNotEmpty
                                        ? contact.name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {
                                      final updatedList =
                                          List<ChatContact>.from(
                                            selectedContacts.value,
                                          );
                                      updatedList.removeAt(index);
                                      selectedContacts.value = updatedList;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 40,
                              child: Text(
                                contact.name.split(" ").first,
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Botón para crear el grupo
              SizedBox(
                width: double.infinity,
                child: BlocBuilder<CreateChatGroupBloc, CreateChatGroupState>(
                  builder: (context, createChatGroupState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed:
                          (selectedContacts.value.isNotEmpty &&
                                      groupName.value.trim().isNotEmpty) ||
                                  createChatGroupState
                                      is SubmittingCreateChatGroupState
                              ? () {
                                _createGroup(
                                  context,
                                  groupName.value.trim(),
                                  groupDescription.value.trim(),
                                  selectedContacts.value,
                                );
                              }
                              : null,
                      child: Text(
                        "Crear Grupo (${selectedContacts.value.length} miembros)",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
