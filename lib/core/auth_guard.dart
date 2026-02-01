import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/auth/login_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  String? _resolveRedirectTo(BuildContext context) {
    // 1) si la route a un nom → on redirige vers elle après login
    final routeName = ModalRoute.of(context)?.settings.name;

    // 2) si un redirectTo est passé via arguments → priorité
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['redirectTo'] is String) {
      return args['redirectTo'] as String;
    }

    return routeName;
  }

  @override
  Widget build(BuildContext context) {
    final redirectTo = _resolveRedirectTo(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Pas connecté => login
        if (snap.data == null) {
          return LoginPage(redirectTo: redirectTo);
        }

        // Connecté => affiche la page demandée
        return child;
      },
    );
  }
}
