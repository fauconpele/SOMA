import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../widgets/common/brand_mark.dart';
import '../widgets/common/section_base.dart';
import '../widgets/common/hover_scale.dart';

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
  final List<ServiceItem> services = const [
    ServiceItem(
      'Services pour les parents',
      'Trouvez des précepteurs qualifiés pour accompagner vos enfants.',
      Icons.family_restroom,
      details: '• Recherche selon vos critères\n• Mise en relation sécurisée\n• Suivi des progrès\n• Facturation transparente',
    ),
    ServiceItem(
      'Services pour les précepteurs',
      'Valorisez vos compétences et trouvez des élèves.',
      Icons.school,
      details: '• Profil détaillé\n• Mise en relation\n• Gestion planning\n• Paiements sécurisés',
    ),
    ServiceItem(
      'Accompagnement scolaire',
      'Soutien personnalisé primaire et secondaire.',
      Icons.auto_stories,
      details: '• Évaluation initiale\n• Programme personnalisé\n• Cours à domicile\n• Bilans réguliers',
    ),
    ServiceItem(
      'Orientation académique',
      'Aide à l\'orientation scolaire et académique.',
      Icons.trending_up,
      details: '• Tests d\'orientation\n• Analyse des compétences\n• Accompagnement au choix',
    ),
    ServiceItem(
      'Suivi et performance',
      'Indicateurs clairs, rapports simples, communication.',
      Icons.analytics,
      details: '• Tableaux de bord\n• Rapports\n• Alertes\n• Recommandations',
    ),
    ServiceItem(
      'Plateforme éducative',
      'Outils numériques simples et sécurisés.',
      Icons.computer,
      details: '• Messagerie\n• Planning\n• Documents partagés\n• Support',
    ),
  ];

  int? expandedIndex;

  // ✅ Scroll + FAB
  final ScrollController _scrollController = ScrollController();
  bool _showTop = false;
  bool _showBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFabVisibility());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() => _refreshFabVisibility();

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
        title: const BrandMark(textColor: Colors.white, logoHeight: 28),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
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
                      Text(
                        'NOS SERVICES',
                        style: GoogleFonts.inter(
                          color: kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Découvrez notre gamme complète de services conçus pour répondre aux besoins éducatifs des parents, des élèves et des précepteurs.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 16, color: kTextLight, height: 1.7),
                      ),
                      const SizedBox(height: 40),
                      LayoutBuilder(builder: (context, c) {
                        final w = c.maxWidth;
                        final crossCount = w > 900 ? 3 : (w > 600 ? 2 : 1);

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossCount,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: crossCount == 1 ? 1.25 : 0.95,
                          ),
                          itemCount: services.length,
                          itemBuilder: (_, i) {
                            final isExpanded = expandedIndex == i;
                            return HoverScale(
                              onTap: () => setState(() => expandedIndex = isExpanded ? null : i),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius),
                                  side: BorderSide(
                                    color: isExpanded ? kPrimaryColor.withOpacity(0.25) : Colors.grey.shade200,
                                    width: isExpanded ? 2 : 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 54,
                                            height: 54,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor.withOpacity(0.10),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(services[i].icon, color: kPrimaryColor, size: 30),
                                          ),
                                          const Spacer(),
                                          Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: kPrimaryColor),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        services[i].title,
                                        style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w900, color: kDarkColor),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        services[i].description,
                                        style: GoogleFonts.inter(fontSize: 14, color: kTextLight, height: 1.6),
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(height: 14),
                                        Divider(height: 1, color: Colors.grey.shade200),
                                        const SizedBox(height: 14),
                                        Text('Détails :', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: kDarkColor)),
                                        const SizedBox(height: 8),
                                        Text(
                                          services[i].details,
                                          style: GoogleFonts.inter(fontSize: 13, color: kTextLight, height: 1.6),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () => Navigator.pushNamed(context, '/contact'),
                                                child: const Text('En savoir plus'),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => Navigator.pushNamed(context, '/contact'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: kSecondaryColor,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: const Text('Nous contacter'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        const Spacer(),
                                        Text(
                                          'Développer →',
                                          style: GoogleFonts.inter(color: kSecondaryColor, fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
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
