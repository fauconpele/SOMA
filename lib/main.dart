// lib/main.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ DEBUG: vérifier que tu es sur le BON projet Firebase
  final app = Firebase.app();
  debugPrint('Firebase projectId = ${app.options.projectId}');
  debugPrint('Firebase appId     = ${app.options.appId}');

  final fs = FirebaseFirestore.instance;

  // ✅ Au cas où le réseau Firestore aurait été désactivé quelque part
  try {
    await fs.enableNetwork();
  } catch (_) {}

  // ✅ IMPORTANT: settings AVANT toute requête Firestore
  // (Sur web, long polling aide beaucoup quand Firestore est "offline" derrière certains réseaux)
  if (kIsWeb) {
    fs.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      webExperimentalForceLongPolling: true,
      webExperimentalAutoDetectLongPolling: true,
    );
  } else {
    fs.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  runApp(const SomaApp());
}
