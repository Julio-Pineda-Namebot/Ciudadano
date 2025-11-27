import "package:ciudadano/features/app_shell/presentation/hooks/use_bloc_provider.dart";
import "package:ciudadano/features/auth/presentation/bloc/auth_cubit.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class AuthProvider extends HookWidget {
  final Widget child;

  const AuthProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authCubit = useBlocProvider(
      () => sl<AuthCubit>()..checkAuthentication(),
    );

    return BlocProvider.value(value: authCubit, child: child);
  }
}
