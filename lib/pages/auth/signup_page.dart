import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _info;

  Future<void> _signup() async {
    if (_loading) return;

    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() => _error = "Tous les champs sont obligatoires.");
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = cred.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'unknown', message: "Utilisateur non créé.");
      }

      // Optionnel : displayName côté Auth
      await user.updateDisplayName(name);

      // ✅ Profil Firestore (on n’empêche PAS la navigation si c’est lent)
      final profileWrite = FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'displayName': name,
          'email': email,
          'role': 'parent',
          'status': 'active',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      try {
        await profileWrite.timeout(const Duration(seconds: 8));
      } on TimeoutException {
        // Profil en cours… on continue quand même
        if (mounted) {
          setState(() {
            _info = "Connexion Firestore lente : ton profil se crée en arrière-plan.";
          });
        }
      }

      if (!mounted) return;

      // ✅ STOP loader + redirection
      setState(() => _loading = false);
      Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (r) => false);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = switch (e.code) {
          'email-already-in-use' => "Cet email est déjà utilisé.",
          'invalid-email' => "Email invalide.",
          'weak-password' => "Mot de passe trop faible.",
          _ => e.message ?? "Erreur d’inscription.",
        };
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = "Erreur inattendue : $e";
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        title: const Text("Inscription"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Créer un compte",
                      style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: kDarkColor),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Inscris-toi pour accéder aux fonctionnalités.",
                      style: GoogleFonts.inter(color: kTextLight, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),

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
                          style: GoogleFonts.inter(color: Colors.red.shade700, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (_info != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.withOpacity(0.18)),
                        ),
                        child: Text(
                          _info!,
                          style: GoogleFonts.inter(color: Colors.orange.shade800, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: "Nom complet",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _loading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text("Créer mon compte"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Déjà un compte ? Se connecter"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
