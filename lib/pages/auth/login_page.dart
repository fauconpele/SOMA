import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class LoginPage extends StatefulWidget {
  final String? redirectTo;
  const LoginPage({super.key, this.redirectTo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _showPassword = false;

  String _resolveRedirectTo(BuildContext context) {
    // priorité 1 : param widget.redirectTo
    if (widget.redirectTo != null && widget.redirectTo!.trim().isNotEmpty) {
      return widget.redirectTo!;
    }

    // priorité 2 : arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['redirectTo'] is String) {
      return args['redirectTo'] as String;
    }

    // fallback
    return '/dashboard';
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(_resolveRedirectTo(context));
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyAuthError(e));
    } catch (_) {
      setState(() => _error = "Une erreur inattendue s'est produite.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Email invalide.";
      case 'user-not-found':
        return "Aucun compte trouvé avec cet email.";
      case 'wrong-password':
      case 'invalid-credential':
        return "Email ou mot de passe incorrect.";
      case 'user-disabled':
        return "Compte désactivé.";
      default:
        return "Erreur de connexion : ${e.message ?? e.code}";
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final redirectTo = _resolveRedirectTo(context);

    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        title: const Text('Connexion'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bienvenue sur SOMA',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: kDarkColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Connecte-toi pour accéder à ton espace.',
                    style: GoogleFonts.inter(color: kTextLight, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  if (_error != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.15)),
                      ),
                      child: Text(
                        _error!,
                        style: GoogleFonts.inter(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _password,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _showPassword ? 'Masquer' : 'Afficher',
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    onSubmitted: (_) => _loading ? null : _login(),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Se connecter'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pas de compte ? ', style: GoogleFonts.inter(color: kTextLight)),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                Navigator.of(context).pushReplacementNamed(
                                  '/signup',
                                  arguments: {'redirectTo': redirectTo},
                                );
                              },
                        child: const Text("S'inscrire"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
