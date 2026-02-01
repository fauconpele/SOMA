import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants.dart';
import '../common/buttons.dart';
import '../../utils/launch.dart';

class NavSheet {
  static void open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kDarkColor,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetCtx) {
        void go(String route) {
          Navigator.of(sheetCtx).pop();
          final current = ModalRoute.of(context)?.settings.name;
          if (current != route) {
            Navigator.of(context).pushNamed(route);
          }
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snap) {
                final user = snap.data;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    // ✅ Auth actions en haut du menu
                    if (user == null) ...[
                      _SheetItem('Connexion', onTap: () => go('/login')),
                      _SheetItem('Inscription', onTap: () => go('/signup')),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),
                    ] else ...[
                      _SheetItem('Dashboard', onTap: () => go('/dashboard')),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Déconnexion', style: TextStyle(color: Colors.white, fontSize: 16)),
                        trailing: const Icon(Icons.logout_rounded, color: Colors.white54),
                        onTap: () async {
                          Navigator.of(sheetCtx).pop();
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),
                    ],

                    _SheetItem('Accueil', onTap: () => go('/')),
                    _SheetItem('Services', onTap: () => go('/services')),
                    _SheetItem('Blog', onTap: () => go('/blog')),
                    _SheetItem('À propos', onTap: () => go('/about')),
                    _SheetItem('Contact', onTap: () => go('/contact')),
                    _SheetItem('Nos précepteurs', onTap: () => go('/nos-precepteurs')),
                    _SheetItem('Devenir précepteur', onTap: () => go('/devenir-precepteur')),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    CtaButton(
                      label: 'Nous contacter',
                      onPressed: () async {
                        Navigator.of(sheetCtx).pop();
                        await launchSmart(context, 'mailto:contact@soma-rdc.org');
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SheetItem extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _SheetItem(this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}
