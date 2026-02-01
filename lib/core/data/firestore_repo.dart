import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepo {
  FirestoreRepo._();
  static final instance = FirestoreRepo._();

  final _db = FirebaseFirestore.instance;

  static const colUsers = 'users';
  static const colPrecepteurs = 'precepteurs';
  static const colDemandes = 'demandes';

  DocumentReference<Map<String, dynamic>> userRef(String uid) =>
      _db.collection(colUsers).doc(uid);

  DocumentReference<Map<String, dynamic>> precepteurRef(String uid) =>
      _db.collection(colPrecepteurs).doc(uid);

  CollectionReference<Map<String, dynamic>> demandesCol() =>
      _db.collection(colDemandes);

  Future<void> ensureUserDoc({
    required String uid,
    required String email,
    String? displayName,
    String role = 'parent',
  }) async {
    final ref = userRef(uid);
    final snap = await ref.get();

    final now = FieldValue.serverTimestamp();

    if (!snap.exists) {
      await ref.set({
        'uid': uid,
        'email': email,
        'displayName': (displayName ?? '').trim(),
        'role': role,
        'createdAt': now,
        'updatedAt': now,
      });
      return;
    }

    final data = snap.data() ?? {};
    final updates = <String, dynamic>{};

    if ((data['email'] as String?)?.trim().isEmpty ?? true) {
      updates['email'] = email;
    }
    if ((data['displayName'] as String?)?.trim().isEmpty ?? true) {
      updates['displayName'] = (displayName ?? '').trim();
    }
    if ((data['role'] as String?)?.trim().isEmpty ?? true) {
      updates['role'] = role;
    }

    if (updates.isNotEmpty) {
      updates['updatedAt'] = now;
      await ref.update(updates);
    }
  }

  Future<void> ensurePrecepteurProfile({
    required String uid,
    required String displayName,
  }) async {
    final ref = precepteurRef(uid);
    final snap = await ref.get();
    final now = FieldValue.serverTimestamp();

    if (snap.exists) return;

    await ref.set({
      'uid': uid,
      'displayName': displayName.trim(),
      'subjects': <String>[],
      'city': '',
      'bio': '',
      'tarifHoraire': 0,
      'isActive': true,
      'ratingAvg': 0.0,
      'ratingCount': 0,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<String> createDemande({
    required String parentUid,
    required String precepteurUid,
    required String message,
  }) async {
    final now = FieldValue.serverTimestamp();
    final doc = await demandesCol().add({
      'parentUid': parentUid,
      'precepteurUid': precepteurUid,
      'message': message.trim(),
      'status': 'pending',
      'createdAt': now,
      'updatedAt': now,
    });
    return doc.id;
  }
}
