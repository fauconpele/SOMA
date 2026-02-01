import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatefulWidget {
  final Widget child;

  /// Route de connexion
  final String loginRoute;

  /// Route vers laquelle revenir après login (si on n’en fournit pas via arguments)
  final String defaultRedirectAfterLogin;

  const AuthGate({
    super.key,
    required this.child,
    this.loginRoute = '/login',
    this.defaultRedirectAfterLogin = '/dashboard',
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _redirected = false;

  void _redirectToLogin(String redirectTo) {
    if (_redirected) return;
    _redirected = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        widget.loginRoute,
        arguments: {'redirectTo': redirectTo},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? widget.defaultRedirectAfterLogin;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // Chargement
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snap.data;

        // Pas connecté => redirect
        if (user == null) {
          _redirectToLogin(currentRoute);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Connecté => page protégée
        return widget.child;
      },
    );
  }
}
