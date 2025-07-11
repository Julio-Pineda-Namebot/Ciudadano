import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_bloc.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_state.dart";
import "package:ciudadano/features/sidebar/profile/presentation/bloc/user_profile_event.dart";

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _nameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        final isLoading = state.name.isEmpty && state.email.isEmpty;

        if (!isLoading) {
          _nameController.text = state.name;
          _dniController.text = state.dni;
          _emailController.text = state.email;
          _phoneController.text = state.phone;
          _addressController.text = state.address;
        }

        return Skeletonizer(
          enabled: isLoading,
          child: ListView(
            children: [
              const Text(
                "Administra tu información personal y preferencias",
                style: TextStyle(color: Colors.black, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.photo_camera, size: 30),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Cambiar Foto"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Nombre Completo", _nameController, (value) {
                context.read<UserProfileBloc>().add(UpdateField(name: value));
              }),
              _buildTextField("DNI", _dniController, (value) {
                context.read<UserProfileBloc>().add(UpdateField(dni: value));
              }),
              _buildTextField("Correo Electrónico", _emailController, (value) {
                context.read<UserProfileBloc>().add(UpdateField(email: value));
              }),
              _buildTextField("Teléfono", _phoneController, (value) {
                context.read<UserProfileBloc>().add(UpdateField(phone: value));
              }),
              _buildTextField("Dirección", _addressController, (value) {
                context.read<UserProfileBloc>().add(
                  UpdateField(address: value),
                );
              }),
              const SizedBox(height: 24),
              const Text(
                "Notificaciones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text("Notificaciones Push"),
                value: state.pushNotifications,
                onChanged: (value) {
                  context.read<UserProfileBloc>().add(
                    UpdateField(pushNotifications: value),
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<UserProfileBloc>().add(SaveProfile());
                  },
                  child: const Text(
                    "Guardar Cambios",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
