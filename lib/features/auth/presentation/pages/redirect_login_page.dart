import "package:ciudadano/features/app_shell/presentation/pages/MY_app.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:provider/provider.dart";

class RedirectLoginPage extends StatelessWidget {
  const RedirectLoginPage({super.key});

  Widget _buildStateWidget(AuthState state) {
    if (state is AuthLoadingState) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state is UnauthenticatedState) {
      return LoginPage();
    }

    if (state is AuthenticatedState) {
      return Provider<AuthProfile>(
        create: (context) => state.authProfile,
        child: const MyApp(),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>()..checkAuthentication(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildStateWidget(state),
          );
        },
      ),
    );
  }
}
