import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants.dart';
import '../common/brand_mark.dart';

class NavSheet {
  static Future<void> open(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final user = FirebaseAuth.instance.currentUser;
        return _NavSheetContent(isLoggedIn: user != null);
      },
    );
  }
}

class _NavSheetContent extends StatelessWidget {
  const _NavSheetContent({required this.isLoggedIn});

  final bool isLoggedIn;

  Future<void> _go(BuildContext context, String route) async {
    Navigator.pop(context);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (context.mounted) Navigator.pushNamed(context, route);
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;

    Navigator.pop(context);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.40,
        maxChildSize: 0.92,
        builder: (context, controller) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Container(
              color: kDarkColor,
              child: ListView(
                controller: controller, // ✅ super important
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomPad),
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const BrandMark(textColor: Colors.white, logoHeight: 26),
                  const SizedBox(height: 14),
                  Divider(color: Colors.white.withOpacity(0.12), height: 1),
                  const SizedBox(height: 10),

                  if (isLoggedIn) ...[
                    _NavItem(
                      icon: Icons.dashboard_rounded,
                      label: "Dashboard",
                      onTap: () => _go(context, '/dashboard'),
                    ),
                    _NavItem(
                      icon: Icons.logout_rounded,
                      label: "Déconnexion",
                      trailing: Icons.logout,
                      onTap: () => _logout(context),
                    ),
                    const SizedBox(height: 6),
                    Divider(color: Colors.white.withOpacity(0.12), height: 1),
                    const SizedBox(height: 6),
                  ] else ...[
                    _NavItem(
                      icon: Icons.login_rounded,
                      label: "Connexion",
                      onTap: () => _go(context, '/login'),
                    ),
                    _NavItem(
                      icon: Icons.person_add_alt_1_rounded,
                      label: "Inscription",
                      onTap: () => _go(context, '/signup'),
                    ),
                    const SizedBox(height: 6),
                    Divider(color: Colors.white.withOpacity(0.12), height: 1),
                    const SizedBox(height: 6),
                  ],

                  _NavItem(
                    icon: Icons.home_rounded,
                    label: "Accueil",
                    onTap: () => _go(context, '/'),
                  ),
                  _NavItem(
                    icon: Icons.miscellaneous_services_rounded,
                    label: "Services",
                    onTap: () => _go(context, '/services'),
                  ),
                  _NavItem(
                    icon: Icons.article_rounded,
                    label: "Blog",
                    onTap: () => _go(context, '/blog'),
                  ),
                  _NavItem(
                    icon: Icons.info_rounded,
                    label: "À propos",
                    onTap: () => _go(context, '/about'),
                  ),
                  _NavItem(
                    icon: Icons.mail_rounded,
                    label: "Contact",
                    onTap: () => _go(context, '/contact'),
                  ),

                  const SizedBox(height: 10),
                  Divider(color: Colors.white.withOpacity(0.12), height: 1),
                  const SizedBox(height: 10),

                  _PrimaryNavButton(
                    label: "Trouver un précepteur",
                    onTap: () => _go(context, '/nos-precepteurs'),
                  ),
                  const SizedBox(height: 10),
                  _SecondaryNavButton(
                    label: "Devenir précepteur",
                    onTap: () => _go(context, '/devenir-precepteur'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing = Icons.chevron_right_rounded,
  });

  final IconData icon;
  final String label;
  final IconData trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.90)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(trailing, color: Colors.white.withOpacity(0.55)),
          ],
        ),
      ),
    );
  }
}

class _PrimaryNavButton extends StatelessWidget {
  const _PrimaryNavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kSecondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _SecondaryNavButton extends StatelessWidget {
  const _SecondaryNavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withOpacity(0.22)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}
