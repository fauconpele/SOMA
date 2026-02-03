// lib/pages/dashboard_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? _user;
  DocumentReference<Map<String, dynamic>>? _profileRef;

  bool _checkingServer = true; // ✅ probe serveur (pour afficher offline seulement si vrai)
  bool _serverOffline = false;
  String? _serverNote;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;

    final u = _user;
    if (u != null) {
      _profileRef = FirebaseFirestore.instance.collection('users').doc(u.uid);
      _probeFirestoreServer();
    } else {
      _checkingServer = false;
    }
  }

  bool _isOfflineLike(Object e) {
    if (e is TimeoutException) return true;
    if (e is FirebaseException) {
      final msg = (e.message ?? '').toLowerCase();
      return e.code == 'unavailable' ||
          msg.contains('offline') ||
          msg.contains('network') ||
          msg.contains('failed to get document') ||
          msg.contains('transport');
    }
    final s = e.toString().toLowerCase();
    return s.contains('offline') || s.contains('network') || s.contains('unavailable');
    // (on reste large parce que sur Web certains messages varient)
  }

  Future<void> _probeFirestoreServer() async {
    setState(() {
      _checkingServer = true;
      _serverOffline = false;
      _serverNote = null;
    });

    try {
      // ✅ Petit ping serveur (Source.server) : si ça échoue => offline réel / réseau bloqué
      await FirebaseFirestore.instance
          .collection('users')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 6));

      if (!mounted) return;
      setState(() {
        _checkingServer = false;
        _serverOffline = false;
        _serverNote = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _checkingServer = false;
        _serverOffline = _isOfflineLike(e);
        _serverNote = _serverOffline
            ? "Firestore semble indisponible (offline). Les données peuvent rester en cache et se synchroniser plus tard."
            : "Erreur de connexion Firestore : $e";
      });
    }
  }

  Future<void> _ensureProfileExists() async {
    final u = _user;
    if (u == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(u.uid);
    final now = FieldValue.serverTimestamp();

    await ref.set({
      'uid': u.uid,
      // Tes pages utilisent parfois "name" / parfois "displayName" :
      // on met les deux pour éviter les écrans vides.
      'name': u.displayName ?? '',
      'displayName': u.displayName ?? '',
      'email': u.email ?? '',
      'role': 'parent',
      'status': 'active',
      'createdAt': now,
      'updatedAt': now,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Non connecté")),
      );
    }

    final profileRef = _profileRef!;
    final titleStyle = GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w900,
      color: kDarkColor,
    );

    final smallStyle = GoogleFonts.inter(
      fontSize: 13,
      color: kTextLight,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );

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
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: profileRef.snapshots(includeMetadataChanges: true),
              builder: (context, snap) {
                final data = snap.data?.data();

                final name = (data?['displayName'] ??
                        data?['name'] ??
                        user.displayName ??
                        '')
                    .toString()
                    .trim();

                final email = (data?['email'] ?? user.email ?? '').toString();
                final role = (data?['role'] ?? 'parent').toString();
                final status = (data?['status'] ?? 'active').toString();

                final isPendingPrecepteur = role == 'precepteur' && status == 'pending';

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
                          'Bienvenue${name.isNotEmpty ? " $name" : ""}',
                          style: titleStyle,
                        ),
                        const SizedBox(height: 6),
                        Text(email, style: smallStyle),
                        const SizedBox(height: 14),

                        // ✅ Bandeau jaune UNIQUEMENT si probe serveur => offline vrai
                        if (_serverOffline) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.withOpacity(0.18)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.wifi_off_rounded, color: Colors.orange.shade700),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _serverNote ??
                                        "Firestore est indisponible (offline).",
                                    style: GoogleFonts.inter(
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.w700,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Loader discret pendant le probe (pas de bandeau)
                        if (_checkingServer) ...[
                          Row(
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 10),
                              Text("Vérification Firestore…", style: smallStyle),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Statut compte
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: kPrimaryColor.withOpacity(0.18)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user_outlined, color: kPrimaryColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Rôle : $role  •  Statut : $status",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    color: kDarkColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (isPendingPrecepteur) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.orange.withOpacity(0.20)),
                            ),
                            child: Text(
                              "Ton profil précepteur est en attente de validation admin. "
                              "Tu ne seras visible aux parents qu'après approbation.",
                              style: GoogleFonts.inter(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],

                        // Erreurs non-offline
                        if (snap.hasError && !_serverOffline) ...[
                          const SizedBox(height: 14),
                          Text(
                            "Erreur profil : ${snap.error}",
                            style: GoogleFonts.inter(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],

                        // Si le doc n'existe pas du tout (cas rare) -> bouton pour le créer
                        if (snap.connectionState == ConnectionState.active &&
                            snap.data != null &&
                            snap.data!.exists == false) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.withOpacity(0.15)),
                            ),
                            child: Text(
                              "Ton document users/${user.uid} n'existe pas encore. Clique pour le créer.",
                              style: GoogleFonts.inter(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _ensureProfileExists();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text("Créer mon profil Firestore"),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/students'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.school_outlined),
                              label: const Text("Mes élèves"),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/students/add'),
                              icon: const Icon(Icons.add),
                              label: const Text("Ajouter un élève"),
                            ),
                            OutlinedButton.icon(
                              onPressed: _probeFirestoreServer,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Tester Firestore"),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/contact'),
                              icon: const Icon(Icons.support_agent),
                              label: const Text("Support"),
                            ),
                          ],
                        ),
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
