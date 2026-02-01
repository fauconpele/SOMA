import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // IMPORTANT: à faire avant toute lecture/écriture Firestore
  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,

      // ✅ Remplace experimentalForceLongPolling (ancien)
      webExperimentalForceLongPolling: true,

      // Optionnel mais utile: règles du long-polling (timeout)
      webExperimentalLongPollingOptions: WebExperimentalLongPollingOptions(
        timeoutDuration: Duration(seconds: 30),
      ),
    );
  }

  runApp(const SomaApp());
}
