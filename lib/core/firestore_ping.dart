import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> firestorePingOnline({
  required String parentId,
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    // Requête “safe” (même s'il n'y a aucun élève, ça marche)
    await FirebaseFirestore.instance
        .collection('students')
        .where('parentId', isEqualTo: parentId)
        .limit(1)
        .get(const GetOptions(source: Source.server))
        .timeout(timeout);

    return true; // serveur OK
  } on FirebaseException catch (e) {
    if (e.code == 'unavailable') return false; // vrai offline
    // permission-denied, etc. => ce n’est PAS “offline”
    return true;
  } on TimeoutException {
    // Timeout ≠ offline certain (connexion lente, proxy, etc.)
    return true;
  } catch (_) {
    return true;
  }
}
