import "package:ciudadano/features/profile/presentation/bloc/user_profile_event.dart";
import "package:ciudadano/features/profile/presentation/pages/form_profile.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:ciudadano/features/profile/presentation/bloc/user_profile_bloc.dart";

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc()..add(FetchProfile()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          title: const Text(
            "Perfil de Usuario",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        body: const Padding(padding: EdgeInsets.all(16), child: UserForm()),
      ),
    );
  }
}
