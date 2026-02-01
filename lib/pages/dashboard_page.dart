import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _ProfileResult {
  final Map<String, dynamic>? data;
  final String? warning; // "connexion lente" etc
  final String? error;
  const _ProfileResult({this.data, this.warning, this.error});
}

class _DashboardPageState extends State<DashboardPage> {
  Future<_ProfileResult>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() {
      _future = _loadProfile(user.uid);
    });
  }

  Future<_ProfileResult> _loadProfile(String uid) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    // 1) Cache-first
    Map<String, dynamic>? cached;
    try {
      final c = await ref.get(const GetOptions(source: Source.cache));
      cached = c.data();
    } catch (_) {}

    // 2) Serveur avec timeout
    try {
      final s = await ref
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 8));
      return _ProfileResult(data: s.data() ?? cached);
    } on TimeoutException {
      return _ProfileResult(
        data: cached,
        warning: "Connexion Firestore lente. Tu peux continuer, et réessayer plus tard.",
      );
    } on FirebaseException catch (e) {
      // Ex: unavailable / offline / permission-denied
      final msg = "${e.code}: ${e.message ?? ''}".trim();
      return _ProfileResult(
        data: cached,
        warning: "Connexion Firestore lente. Tu peux continuer, et réessayer plus tard.",
        error: msg.isEmpty ? e.code : msg,
      );
    } catch (e) {
      return _ProfileResult(
        data: cached,
        warning: "Connexion Firestore lente. Tu peux continuer, et réessayer plus tard.",
        error: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Non connecté")));
    }

    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Tableau de bord'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: FutureBuilder<_ProfileResult>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                final result = snap.data ?? const _ProfileResult();
                final data = result.data;

                final email = (data?['email'] ?? user.email ?? '').toString();
                final name = (data?['displayName'] ?? user.displayName ?? '').toString();

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bienvenue${name.isNotEmpty ? " $name" : ""}",
                          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: kDarkColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          email,
                          style: GoogleFonts.inter(fontSize: 13, color: kTextLight, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 14),

                        if (result.warning != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.18)),
                            ),
                            child: Text(
                              result.warning!,
                              style: GoogleFonts.inter(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/students'),
                              child: const Text("Mes élèves"),
                            ),
                            OutlinedButton(
                              onPressed: () => Navigator.pushNamed(context, '/students/add'),
                              child: const Text("Ajouter un élève"),
                            ),
                            OutlinedButton(
                              onPressed: _reload,
                              child: const Text("Réessayer profil"),
                            ),
                          ],
                        ),

                        if (result.error != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            "Détail: ${result.error}",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
