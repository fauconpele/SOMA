import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({
    super.key,
    required this.child,
    this.allowedRoles,
  });

  final Widget child;

  /// Exemple : ['admin'] ou ['parent', 'tutor']
  final List<String>? allowedRoles;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // loading
        if (snap.connectionState == ConnectionState.waiting) {
          return const _LoadingScaffold();
        }

        // pas connecté => redirect login
        final user = snap.data;
        if (user == null) {
          return const _Redirect(to: '/login');
        }

        // connecté => on lit le profil Firestore
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
          builder: (context, profSnap) {
            if (profSnap.connectionState == ConnectionState.waiting) {
              return const _LoadingScaffold();
            }

            final data = profSnap.data?.data();
            if (data == null) {
              // profil Firestore manquant
              return _ErrorScaffold(
                title: 'Profil introuvable',
                message:
                    "Ton compte est connecté mais ton profil Firestore n'existe pas (users/${user.uid}).\n"
                    "Solution : déconnecte-toi puis recrée ton compte, ou crée le document manuellement.",
                actionLabel: 'Se déconnecter',
                onAction: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
              );
            }

            final role = (data['role'] ?? '').toString();
            final status = (data['status'] ?? '').toString();

            // statut tutor en attente => page attente (pas de crash)
            if (role == 'tutor' && status != 'approved') {
              return _InfoScaffold(
                title: 'Compte en attente de validation',
                message:
                    "Ton profil précepteur a bien été reçu.\n"
                    "Un administrateur doit valider ton compte avant qu’il soit visible.",
                actionLabel: 'Retour à l’accueil',
                onAction: () => Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
                secondaryLabel: 'Se déconnecter',
                onSecondary: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                },
              );
            }

            // contrôle des rôles
            if (allowedRoles != null && allowedRoles!.isNotEmpty && !allowedRoles!.contains(role)) {
              return _ErrorScaffold(
                title: 'Accès refusé',
                message: "Ton rôle ($role) n’a pas accès à cette page.",
                actionLabel: 'Retour',
                onAction: () => Navigator.maybePop(context),
              );
            }

            return child;
          },
        );
      },
    );
  }
}

class _Redirect extends StatefulWidget {
  const _Redirect({required this.to});
  final String to;

  @override
  State<_Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<_Redirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, widget.to, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) => const _LoadingScaffold();
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: SizedBox(width: 26, height: 26, child: CircularProgressIndicator())),
    );
  }
}

class _InfoScaffold extends StatelessWidget {
  const _InfoScaffold({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
                        ),
                        if (secondaryLabel != null && onSecondary != null) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
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

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return _InfoScaffold(
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
