import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _name = TextEditingController();
  final _classe = TextEditingController();
  final _school = TextEditingController();

  bool _saving = false;
  bool _backgroundSaving = false;

  String? _error;
  String? _info;

  Timer? _slowTimer;
  Future<void>? _writeFuture;

  Future<void> _save() async {
    if (_saving || _backgroundSaving) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _error = "Tu dois être connecté pour ajouter un élève.");
      return;
    }

    final name = _name.text.trim();
    final classe = _classe.text.trim();
    final school = _school.text.trim();

    if (name.isEmpty || classe.isEmpty) {
      setState(() => _error = "Nom et classe sont obligatoires.");
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _saving = true;
      _backgroundSaving = false;
      _error = null;
      _info = null;
    });

    _slowTimer?.cancel();
    _slowTimer = Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      if (_saving) {
        setState(() {
          _saving = false;
          _backgroundSaving = true;
          _info = "Connexion lente à Firestore… l’enregistrement continue. "
              "Tu peux aller dans “Mes élèves” et réessayer plus tard si besoin.";
        });
      }
    });

    final docRef = FirebaseFirestore.instance.collection('students').doc();
    final now = FieldValue.serverTimestamp();

    // On lance l’écriture, et on accroche des callbacks (au cas où on a timeout)
    _writeFuture = docRef.set({
      'parentId': user.uid,
      'name': name,
      'classe': classe,
      'school': school.isEmpty ? null : school,
      'createdAt': now,
      'updatedAt': now,
    });

    _writeFuture!.then((_) {
      _slowTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _saving = false;
        _backgroundSaving = false;
        _info = null;
      });
      Navigator.of(context).pushReplacementNamed('/students');
    }).catchError((e) {
      _slowTimer?.cancel();
      if (!mounted) return;

      String msg = "Erreur inattendue : $e";
      if (e is FirebaseException) {
        if (e.code == 'permission-denied') {
          msg = "Permission refusée (règles Firestore). Vérifie les règles pour 'students'.";
        } else {
          msg = "Erreur Firestore : ${e.message ?? e.code}";
        }
      }

      setState(() {
        _saving = false;
        _backgroundSaving = false;
        _error = msg;
      });
    });

    // On attend un peu (pour succès rapide). Si timeout => UI passe en backgroundSaving
    try {
      await _writeFuture!.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      // UI déjà gérée par le timer ; rien à faire ici
    }
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _name.dispose();
    _classe.dispose();
    _school.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        title: const Text("Ajouter un élève"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nouveau profil élève",
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w900, color: kDarkColor),
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
                        labelText: "Nom complet de l'élève",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _classe,
                      decoration: const InputDecoration(
                        labelText: "Classe / Niveau",
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _school,
                      decoration: const InputDecoration(
                        labelText: "École (optionnel)",
                        prefixIcon: Icon(Icons.apartment_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: (_saving || _backgroundSaving) ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(_backgroundSaving ? "Enregistrement…" : "Enregistrer"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _saving ? null : () => Navigator.pop(context),
                            child: const Text("Annuler"),
                          ),
                        ),
                        if (_backgroundSaving) ...[
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, '/students'),
                              child: const Text("Mes élèves"),
                            ),
                          ),
                        ],
                      ],
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
