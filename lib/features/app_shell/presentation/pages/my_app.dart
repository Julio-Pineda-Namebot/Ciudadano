import "package:ciudadano/features/auth/domain/entities/auth_profile.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthProfile>().firstName;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text("My App Home Page"), Text(name)],
        ),
      ),
    );
  }
}
