import "package:ciudadano/features/app_shell/presentation/bloc/presentation_cubit.dart";
import "package:ciudadano/features/app_shell/presentation/pages/present/presentation_screen_page.dart";
import "package:ciudadano/features/auth/presentation/pages/redirect_login_page.dart";
import "package:ciudadano/service_locator.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class RedirectPresentationScreenPage extends StatelessWidget {
  const RedirectPresentationScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<PresentationCubit>()..checkIfPresentationHasSeen(),
      child: BlocBuilder<PresentationCubit, PresentationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child:
                state is PresentationNotSeen
                    ? const PresentationScreenPage()
                    : const RedirectLoginPage(),
          );
        },
      ),
    );
  }
}
