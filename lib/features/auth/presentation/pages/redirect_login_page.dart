import "package:animations/animations.dart";
import "package:ciudadano/features/app_shell/presentation/pages/app_shell.dart";
import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:ciudadano/features/auth/presentation/pages/login_page.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooked_bloc/hooked_bloc.dart";
import "package:provider/provider.dart";

class RedirectLoginPage extends HookWidget {
  const RedirectLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = useBlocBuilder(context.read<AuthCubit>());

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState is AuthenticatedState) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder:
                  (_, __, ___) => Provider<AuthProfile>(
                    create: (context) => authState.authProfile,
                    child: const AppShell(),
                  ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeScaleTransition(animation: animation, child: child),
            ),
            (route) => false,
          );
        }

        if (authState is UnauthenticatedState) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeScaleTransition(animation: animation, child: child),
            ),
            (route) => false,
          );
        }
      });
      return null;
    }, [authState]);

    return const Scaffold(backgroundColor: Colors.black);
  }
}
