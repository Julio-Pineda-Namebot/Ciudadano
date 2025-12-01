import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lottie/lottie.dart";
import "package:skeletonizer/skeletonizer.dart";

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

  Map<String, bool> editing = {
    "name": false,
    "dni": false,
    "email": false,
    "phone": false,
    "address": false,
  };

  @override
  void initState() {
    AuthProfile profile = context.read<AuthProfile>();

    _nameController.text = "${profile.firstName} ${profile.lastName}";
    _dniController.text = profile.dni ?? "";
    _emailController.text = profile.email ?? "";
    _phoneController.text = profile.phone ?? "";
  }

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
    return Skeletonizer(
      enabled: false,
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
                CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                  child: Lottie.asset(
                    "assets/lottie/user.json",
                    width: 150,
                    height: 150,
                    repeat: false,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildTextField(
            keyField: "name",
            label: "Nombre Completo",
            controller: _nameController,
            // onChanged: (value) =>
            //     context.read<UserProfileBloc>().add(UpdateField(name: value)),
          ),

          _buildTextField(
            keyField: "dni",
            label: "DNI",
            controller: _dniController,
            // onChanged: (value) =>
            //     context.read<UserProfileBloc>().add(UpdateField(dni: value)),
          ),

          _buildTextField(
            keyField: "email",
            label: "Correo Electrónico",
            controller: _emailController,
            // onChanged: (value) =>
            //     context.read<UserProfileBloc>().add(UpdateField(email: value)),
          ),

          _buildTextField(
            keyField: "phone",
            label: "Teléfono",
            controller: _phoneController,
            // onChanged: (value) =>
            //     context.read<UserProfileBloc>().add(UpdateField(phone: value)),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String keyField,
    required String label,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(
              editing[keyField]! ? Icons.lock_open : Icons.lock,
              color: editing[keyField]! ? Colors.green : Colors.grey,
            ),
            onPressed: () {},
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
