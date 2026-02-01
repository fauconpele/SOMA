import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  static const _networkTimeout = Duration(seconds: 8);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _loadStudents(
    String uid,
  ) async {
    final q = FirebaseFirestore.instance
        .collection('students')
        .where('parentId', isEqualTo: uid);

    try {
      // ✅ Essaye réseau (mais si c'est lent, on ne bloque pas indéfiniment)
      final snap = await q.get().timeout(_networkTimeout);
      return snap.docs;
    } on TimeoutException {
      // ✅ Réseau lent → tente cache
      final cacheSnap = await q.get(const GetOptions(source: Source.cache));
      return cacheSnap.docs;
    }
  }

  Future<void> _deleteStudent(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(docId)
          .delete()
          .timeout(_networkTimeout);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Élève supprimé.")),
      );
      await _refresh();
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connexion lente… suppression non confirmée. Réessaie."),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      final msg = (e.code == 'permission-denied')
          ? "Permission refusée (règles Firestore)."
          : "Erreur Firestore : ${e.message ?? e.code}";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur inattendue : $e")),
      );
    }
  }

  Future<void> _refresh() async {
    setState(() {
      // on force rebuild FutureBuilder en changeant une clé
      _reloadKey = UniqueKey();
    });
  }

  Key _reloadKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: kLightColor,
        appBar: AppBar(
          backgroundColor: kDarkColor,
          foregroundColor: Colors.white,
          title: const Text("Mes élèves"),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
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
                      "Tu dois être connecté.",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Se connecter"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        title: const Text("Mes élèves"),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/students/add'),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Ajouter", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        key: _reloadKey,
        future: _loadStudents(user.uid),
        builder: (context, snap) {
          // Loader court
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erreurs
          if (snap.hasError) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
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
                            "Erreur de chargement",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: kDarkColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${snap.error}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _refresh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text("Réessayer"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final docs = snap.data ?? [];

          // Aucun élève
          if (docs.isEmpty) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
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
                            "Aucun élève pour l’instant",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: kDarkColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Clique sur « Ajouter » pour créer le premier profil élève.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: kTextLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 46,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/students/add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSecondaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text("Ajouter un élève"),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _refresh,
                            child: const Text("Actualiser"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Liste
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(18),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final doc = docs[i];
                final d = doc.data();

                final name = (d['name'] ?? '').toString();
                final classe = (d['classe'] ?? '').toString();
                final school = (d['school'] ?? '').toString();

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: kPrimaryColor.withOpacity(0.12),
                      child: Icon(Icons.school_outlined, color: kPrimaryColor),
                    ),
                    title: Text(
                      name.isEmpty ? "Élève sans nom" : name,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      [classe, if (school.isNotEmpty) school].join(" • "),
                      style: GoogleFonts.inter(
                        color: kTextLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'delete') {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Supprimer l’élève ?"),
                              content: Text(
                                "Supprimer “${name.isEmpty ? "cet élève" : name}” ?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Annuler"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Supprimer"),
                                ),
                              ],
                            ),
                          );

                          if (ok == true) {
                            await _deleteStudent(doc.id);
                          }
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text("Supprimer"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
