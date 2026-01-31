import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../widgets/common/brand_mark.dart';
import '../widgets/common/section_base.dart';
import '../widgets/common/hover_scale.dart';
import '../widgets/common/buttons.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final String details;
  const ServiceItem(this.title, this.description, this.icon, {this.details = ''});
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = ScrollController();

  bool _showTop = false;
  bool _showBottom = false;

  final List<ServiceItem> services = const [
    ServiceItem(
      'Services pour les parents',
      'Trouvez des précepteurs qualifiés pour accompagner vos enfants.',
      Icons.family_restroom,
      details:
          'Recherche selon vos critères\nMise en relation sécurisée\nSuivi des progrès\nFacturation transparente',
    ),
    ServiceItem(
      'Services pour les précepteurs',
      'Valorisez vos compétences et trouvez des élèves.',
      Icons.school,
      details: 'Profil détaillé\nMise en relation\nGestion planning\nPaiements sécurisés',
    ),
    ServiceItem(
      'Accompagnement scolaire',
      'Soutien personnalisé primaire et secondaire.',
      Icons.auto_stories,
      details: 'Évaluation initiale\nProgramme personnalisé\nCours à domicile\nBilans réguliers',
    ),
    ServiceItem(
      'Orientation académique',
      'Aide à l’orientation scolaire et académique.',
      Icons.trending_up,
      details: 'Tests d’orientation\nAnalyse des compétences\nAccompagnement au choix',
    ),
    ServiceItem(
      'Suivi et performance',
      'Indicateurs clairs, rapports simples, communication.',
      Icons.analytics,
      details: 'Tableaux de bord\nRapports\nAlertes\nRecommandations',
    ),
    ServiceItem(
      'Plateforme éducative',
      'Outils numériques simples et sécurisés.',
      Icons.computer,
      details: 'Messagerie\nPlanning\nDocuments partagés\nSupport',
    ),
  ];

  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_refreshFabVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFabVisibility());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_refreshFabVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshFabVisibility() {
    if (!mounted) return;
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final offset = pos.pixels;
    final max = pos.maxScrollExtent;

    final showTop = offset > 220;
    final showBottom = max > 220 && (max - offset) > 220;

    if (showTop != _showTop || showBottom != _showBottom) {
      setState(() {
        _showTop = showTop;
        _showBottom = showBottom;
      });
    }
  }

  Future<void> _goTop() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _goBottom() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = adaptiveRadius(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(
          tooltip: 'Retour',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/contact'),
            child: Text(
              'Contact',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: SectionBase(
                  background: kLightColor,
                  child: Column(
                    children: [
                      _HeroServices(
                        radius: radius,
                        onContact: () => Navigator.pushNamed(context, '/contact'),
                        onBecomeTutor: () => Navigator.pushNamed(context, '/devenir-precepteur'),
                      ),
                      const SizedBox(height: 24),

                      LayoutBuilder(builder: (context, c) {
                        final w = c.maxWidth;
                        final crossCount = w > 900 ? 3 : (w > 600 ? 2 : 1);

                        // Un peu plus de hauteur pour éviter les overflows quand on développe.
                        final childRatio = crossCount == 1 ? 1.08 : 0.86;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossCount,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: childRatio,
                          ),
                          itemCount: services.length,
                          itemBuilder: (_, i) {
                            final isExpanded = expandedIndex == i;

                            return HoverScale(
                              onTap: () => setState(() => expandedIndex = isExpanded ? null : i),
                              child: _ServiceCard(
                                radius: radius,
                                item: services[i],
                                isExpanded: isExpanded,
                                onMore: () => Navigator.pushNamed(context, '/contact'),
                                onContact: () => Navigator.pushNamed(context, '/contact'),
                                onBecomeTutor: () => Navigator.pushNamed(context, '/devenir-precepteur'),
                              ),
                            );
                          },
                        );
                      }),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Boutons Haut/Bas sur cette page
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ScrollFab(
                    visible: _showTop,
                    tooltip: 'Aller en haut',
                    icon: Icons.keyboard_arrow_up_rounded,
                    onPressed: _goTop,
                  ),
                  const SizedBox(height: 10),
                  _ScrollFab(
                    visible: _showBottom,
                    tooltip: 'Aller en bas',
                    icon: Icons.keyboard_arrow_down_rounded,
                    onPressed: _goBottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroServices extends StatelessWidget {
  const _HeroServices({
    required this.radius,
    required this.onContact,
    required this.onBecomeTutor,
  });

  final double radius;
  final VoidCallback onContact;
  final VoidCallback onBecomeTutor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.14),
            kSecondaryColor.withOpacity(0.10),
            Colors.white.withOpacity(0.70),
          ],
        ),
        border: Border.all(color: kPrimaryColor.withOpacity(0.18), width: 1),
      ),
      child: Column(
        children: [
          Text(
            'NOS SERVICES',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Des solutions éducatives complètes',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Découvrez des services pensés pour les parents, les élèves et les précepteurs : '
            'clairs, pratiques et adaptés au contexte local.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: kTextLight,
              height: 1.7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              CtaButton(label: 'Nous contacter', onPressed: onContact),
              GhostButton(label: 'Devenir précepteur', onPressed: onBecomeTutor),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.radius,
    required this.item,
    required this.isExpanded,
    required this.onMore,
    required this.onContact,
    required this.onBecomeTutor,
  });

  final double radius;
  final ServiceItem item;
  final bool isExpanded;
  final VoidCallback onMore;
  final VoidCallback onContact;
  final VoidCallback onBecomeTutor;

  List<String> _detailLines(String raw) {
    final lines = raw
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final lines = _detailLines(item.details);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isExpanded ? 0.08 : 0.05),
            blurRadius: isExpanded ? 26 : 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
            color: isExpanded ? kPrimaryColor.withOpacity(0.30) : Colors.grey.shade200,
            width: isExpanded ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.18), width: 1),
                    ),
                    child: Icon(item.icon, color: kPrimaryColor, size: 30),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isExpanded ? kSecondaryColor.withOpacity(0.12) : kPrimaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: (isExpanded ? kSecondaryColor : kPrimaryColor).withOpacity(0.22),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 18,
                          color: isExpanded ? kSecondaryColor : kPrimaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isExpanded ? 'Réduire' : 'Détails',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isExpanded ? kSecondaryColor : kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                item.title,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: kDarkColor,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item.description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: kTextLight,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              if (!isExpanded) ...[
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Voir détails',
                      style: GoogleFonts.inter(
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, color: kSecondaryColor, size: 18),
                  ],
                ),
              ] else ...[
                Divider(height: 18, color: Colors.grey.shade200),

                Text(
                  'Ce que vous obtenez :',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    color: kDarkColor,
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ Liste scrollable (évite overflow)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (final l in lines) _DetailRow(text: l),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: GhostButton(
                        label: 'En savoir plus',
                        onPressed: onMore,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CtaButton(
                        label: 'Nous contacter',
                        onPressed: onContact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onBecomeTutor,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kSecondaryColor,
                      side: BorderSide(color: kSecondaryColor.withOpacity(0.45)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w800),
                    ),
                    child: const Text('Devenir précepteur'),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 18, color: kSecondaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: kTextLight,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollFab extends StatelessWidget {
  const _ScrollFab({
    required this.visible,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final bool visible;
  final String tooltip;
  final IconData icon;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: IgnorePointer(
        ignoring: !visible,
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onPressed(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kDarkColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
