import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../common/buttons.dart';
import '../../utils/launch.dart';

class NavSheet {
  static void open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kDarkColor,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetCtx) {
        final current = ModalRoute.of(context)?.settings.name;

        void go(String route) {
          Navigator.of(sheetCtx).pop();
          if (current != route) {
            Navigator.of(context).pushNamed(route);
          }
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // évite le débordement sur petits écrans
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // --- Liens principaux ---
                    _SheetItem(
                      'Accueil',
                      icon: Icons.home_rounded,
                      isActive: current == '/',
                      onTap: () => go('/'),
                    ),
                    _SheetItem(
                      'Services',
                      icon: Icons.grid_view_rounded,
                      isActive: current == '/services',
                      onTap: () => go('/services'),
                    ),
                    _SheetItem(
                      'Blog',
                      icon: Icons.article_rounded,
                      isActive: current == '/blog',
                      onTap: () => go('/blog'),
                    ),
                    _SheetItem(
                      'À propos',
                      icon: Icons.info_rounded,
                      isActive: current == '/about',
                      onTap: () => go('/about'),
                    ),
                    _SheetItem(
                      'Contact',
                      icon: Icons.mail_rounded,
                      isActive: current == '/contact',
                      onTap: () => go('/contact'),
                    ),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 10),

                    // --- Section Précepteurs ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          'PRÉCEPTEURS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.70),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _SheetItem(
                      'Nos précepteurs',
                      icon: Icons.people_alt_rounded,
                      isActive: current == '/nos-precepteurs',
                      onTap: () => go('/nos-precepteurs'),
                    ),

                    // ✅ Mise en avant : Devenir précepteur (plus visible)
                    _SheetHighlight(
                      label: 'Devenir précepteur',
                      icon: Icons.school_rounded,
                      isActive: current == '/devenir-precepteur',
                      onTap: () => go('/devenir-precepteur'),
                    ),

                    const SizedBox(height: 18),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 14),

                    // CTA mail
                    CtaButton(
                      label: 'Nous contacter',
                      onPressed: () async {
                        Navigator.of(sheetCtx).pop();
                        await launchSmart(context, 'mailto:contact@soma-rdc.org');
                      },
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SheetItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;

  const _SheetItem(
    this.label, {
    required this.icon,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = kSecondaryColor.withOpacity(0.18);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? kSecondaryColor.withOpacity(0.35) : Colors.white10,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.90), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.55),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHighlight extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;

  const _SheetHighlight({
    required this.label,
    required this.icon,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? kSecondaryColor.withOpacity(0.95) : kSecondaryColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Postuler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
