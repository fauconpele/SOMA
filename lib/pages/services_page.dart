import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../widgets/common/brand_mark.dart';
import '../widgets/nav/nav_sheet.dart';
import '../widgets/nav/top_nav_link.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final small = isSmallScreen(context);

    final services = <_ServiceData>[
      const _ServiceData(
        title: 'Accompagnement scolaire',
        subtitle: 'Soutien personnalisé primaire et secondaire.',
        icon: Icons.menu_book_rounded,
        details: [
          'Évaluation initiale',
          'Cours à domicile',
          'Bilans réguliers',
        ],
      ),
      const _ServiceData(
        title: 'Orientation académique',
        subtitle: "Aide à l'orientation scolaire et académique.",
        icon: Icons.trending_up_rounded,
        details: [
          'Choix de filière',
          'Conseils de parcours',
          'Plan de travail personnalisé',
        ],
      ),
      const _ServiceData(
        title: 'Suivi et performance',
        subtitle: 'Indicateurs clairs, rapports simples, communication.',
        icon: Icons.analytics_rounded,
        details: [
          'Suivi des objectifs',
          'Rapports périodiques',
          'Échanges avec les parents',
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const BrandMark(textColor: Colors.white, logoHeight: 28),
        actions: [
          if (!small) ...[
            TopNavLink(label: 'Accueil', onTap: () => Navigator.pushNamed(context, '/')),
            TopNavLink(label: 'Blog', onTap: () => Navigator.pushNamed(context, '/blog')),
            TopNavLink(label: 'À propos', onTap: () => Navigator.pushNamed(context, '/about')),
            TopNavLink(label: 'Contact', onTap: () => Navigator.pushNamed(context, '/contact')),
            const SizedBox(width: 12),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => NavSheet.open(context),
              tooltip: 'Menu',
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            Text(
              'NOS SERVICES',
              style: GoogleFonts.inter(
                color: kPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Solutions éducatives complètes',
              style: GoogleFonts.inter(
                fontSize: small ? 26 : 34,
                fontWeight: FontWeight.w900,
                color: kDarkColor,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Choisis un service et développe les détails. Les cartes sont flexibles, donc plus de bandes jaunes/noires.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: kTextLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),

            // ✅ LISTE => hauteur libre => pas d’overflow
            ...List.generate(services.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ServiceExpandableCard(data: services[i]),
              );
            }),

            const SizedBox(height: 10),
            _BottomCtas(small: small),
          ],
        ),
      ),
    );
  }
}

class _BottomCtas extends StatelessWidget {
  const _BottomCtas({required this.small});
  final bool small;

  @override
  Widget build(BuildContext context) {
    // ✅ Wrap => les boutons passent à la ligne => aucun overflow
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/nos-precepteurs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.search_rounded),
            label: Text(
              'Trouver un précepteur',
              style: GoogleFonts.inter(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SizedBox(
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/devenir-precepteur'),
            style: OutlinedButton.styleFrom(
              foregroundColor: kDarkColor,
              side: BorderSide(color: kDarkColor.withOpacity(0.15)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.school_rounded),
            label: Text(
              'Devenir précepteur',
              style: GoogleFonts.inter(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> details;

  const _ServiceData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.details,
  });
}

class _ServiceExpandableCard extends StatefulWidget {
  const _ServiceExpandableCard({required this.data});

  final _ServiceData data;

  @override
  State<_ServiceExpandableCard> createState() => _ServiceExpandableCardState();
}

class _ServiceExpandableCardState extends State<_ServiceExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    final radius = adaptiveRadius(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ laisse grandir la carte
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _toggle,
                borderRadius: BorderRadius.circular(radius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.data.icon, color: kPrimaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.title,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: kDarkColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.data.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                color: kTextLight,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _open ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: kTextLight,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),

              if (_open) ...[
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 10),

                Text(
                  'Détails :',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(height: 8),

                // ✅ bullet list flexible : Row + Expanded (pas de débordement)
                ...widget.data.details.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('•  ', style: GoogleFonts.inter(color: kTextLight)),
                        Expanded(
                          child: Text(
                            d,
                            style: GoogleFonts.inter(
                              color: kTextLight,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
