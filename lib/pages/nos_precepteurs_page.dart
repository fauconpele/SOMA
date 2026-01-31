// lib/pages/nos_precepteurs_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants.dart';
import '../widgets/common/simple_page_scaffold.dart';
import '../widgets/common/buttons.dart';

class NosPrecepteursPage extends StatefulWidget {
  const NosPrecepteursPage({super.key});

  @override
  State<NosPrecepteursPage> createState() => _NosPrecepteursPageState();
}

class _NosPrecepteursPageState extends State<NosPrecepteursPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _niveau = 'Tous';
  String _matiere = 'Toutes';
  String _format = 'Tous';
  bool _onlyVerified = false;

  // ✅ Démo (remplace ensuite par tes données/BD/API)
  final List<_Precepteur> _all = const [
    _Precepteur(
      name: 'Allain ALI M.',
      title: 'Mathématiques • Physique',
      city: 'Kinshasa',
      verified: true,
      rating: 4.9,
      reviews: 48,
      formats: ['Présentiel', 'En ligne'],
      levels: ['Secondaire', 'Humanités'],
      description:
          'Approche structurée, pédagogie progressive, focus sur la compréhension et la méthode.',
      avatarAsset: 'assets/images/team/allain_ali.jpg',
    ),
    _Precepteur(
      name: 'Raphaël MWELA K.',
      title: 'Sciences • Méthodologie',
      city: 'Kinshasa',
      verified: true,
      rating: 4.8,
      reviews: 32,
      formats: ['Présentiel'],
      levels: ['Secondaire', 'Humanités'],
      description:
          'Accompagnement personnalisé, exercices ciblés, suivi régulier et motivation.',
      avatarAsset: 'assets/images/team/raphael_mwela.jpg',
    ),
    _Precepteur(
      name: 'Sarah JESSICA',
      title: 'Langues • Communication',
      city: 'Kinshasa',
      verified: false,
      rating: 4.6,
      reviews: 17,
      formats: ['En ligne'],
      levels: ['Primaire', 'Secondaire'],
      description:
          'Méthode active, amélioration de l’expression, confiance et progression rapide.',
      avatarAsset: 'assets/images/team/sarah_jessica.jpg',
    ),
    _Precepteur(
      name: 'Noëlla SIFA',
      title: 'Encadrement • Devoirs',
      city: 'Kinshasa',
      verified: true,
      rating: 4.7,
      reviews: 21,
      formats: ['Présentiel'],
      levels: ['Primaire'],
      description:
          'Suivi des devoirs, consolidation des bases, routine de travail et autonomie.',
      avatarAsset: 'assets/images/team/noella_sifa.jpg',
    ),
  ];

  List<_Precepteur> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();

    return _all.where((p) {
      final okVerified = !_onlyVerified || p.verified;

      final okNiveau = _niveau == 'Tous' || p.levels.contains(_niveau);
      final okFormat = _format == 'Tous' || p.formats.contains(_format);

      final okMatiere = _matiere == 'Toutes' ||
          p.title.toLowerCase().contains(_matiere.toLowerCase());

      final okQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.title.toLowerCase().contains(q) ||
          p.city.toLowerCase().contains(q);

      return okVerified && okNiveau && okFormat && okMatiere && okQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = adaptiveRadius(context);
    final list = _filtered;

    return SimplePageScaffold(
      title: 'Nos précepteurs',
      subtitle:
          'Filtrez, comparez, puis contactez le bon profil en quelques clics.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FiltersCard(
            radius: r,
            searchCtrl: _searchCtrl,
            niveau: _niveau,
            matiere: _matiere,
            format: _format,
            onlyVerified: _onlyVerified,
            onChanged: () => setState(() {}),
            onNiveauChanged: (v) => setState(() => _niveau = v),
            onMatiereChanged: (v) => setState(() => _matiere = v),
            onFormatChanged: (v) => setState(() => _format = v),
            onOnlyVerifiedChanged: (v) => setState(() => _onlyVerified = v),
            onClear: () {
              _searchCtrl.clear();
              setState(() {
                _niveau = 'Tous';
                _matiere = 'Toutes';
                _format = 'Tous';
                _onlyVerified = false;
              });
            },
          ),
          const SizedBox(height: 18),

          // ✅ Petit bandeau “Devenir précepteur”
          _BecomePrecepteurBanner(
            radius: r,
            onBecome: () => Navigator.pushNamed(context, '/devenir-precepteur'),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Text(
                '${list.length} profil(s) trouvé(s)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kTextLight,
                ),
              ),
              const Spacer(),
              _MiniPill(
                icon: Icons.verified_rounded,
                label: 'Vérifiés',
                active: _onlyVerified,
              ),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth;
            final crossCount = w > 1000 ? 3 : (w > 650 ? 2 : 1);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: crossCount == 1 ? 1.25 : 0.88,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) => _PrecepteurCard(
                p: list[i],
                radius: r,
                onTap: () => _openProfile(context, list[i]),
              ),
            );
          }),

          const SizedBox(height: 18),
          _HelpBanner(
            radius: r,
            onContact: () => Navigator.pushNamed(context, '/contact'),
            onBecome: () => Navigator.pushNamed(context, '/devenir-precepteur'),
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context, _Precepteur p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(adaptiveRadius(context)),
        ),
      ),
      builder: (_) {
        final r = adaptiveRadius(context);
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.92,
            child: Column(
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: kDarkColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(r)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Fermer',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHero(p: p, radius: r),
                        const SizedBox(height: 16),

                        Text(
                          'À propos',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: kDarkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.6,
                            color: kTextDark,
                          ),
                        ),

                        const SizedBox(height: 16),
                        _InfoRow(icon: Icons.location_on_rounded, text: p.city),
                        const SizedBox(height: 10),
                        _InfoRow(
                            icon: Icons.school_rounded,
                            text: p.levels.join(' • ')),
                        const SizedBox(height: 10),
                        _InfoRow(
                            icon: Icons.video_call_rounded,
                            text: p.formats.join(' • ')),

                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: kPrimaryColor.withOpacity(0.14)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_rounded,
                                  color: kPrimaryColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Pour contacter ce précepteur, appuyez sur “Contacter”. '
                                  'Vous serez redirigé vers la page Contact.',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    height: 1.45,
                                    color: kTextDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/contact');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: kPrimaryColor.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Contacter',
                            style: GoogleFonts.inter(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/contact');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSecondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Demander un devis',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Precepteur {
  final String name;
  final String title;
  final String city;
  final bool verified;
  final double rating;
  final int reviews;
  final List<String> formats;
  final List<String> levels;
  final String description;
  final String? avatarAsset;

  const _Precepteur({
    required this.name,
    required this.title,
    required this.city,
    required this.verified,
    required this.rating,
    required this.reviews,
    required this.formats,
    required this.levels,
    required this.description,
    this.avatarAsset,
  });
}

class _FiltersCard extends StatelessWidget {
  const _FiltersCard({
    required this.radius,
    required this.searchCtrl,
    required this.niveau,
    required this.matiere,
    required this.format,
    required this.onlyVerified,
    required this.onChanged,
    required this.onNiveauChanged,
    required this.onMatiereChanged,
    required this.onFormatChanged,
    required this.onOnlyVerifiedChanged,
    required this.onClear,
  });

  final double radius;
  final TextEditingController searchCtrl;

  final String niveau;
  final String matiere;
  final String format;
  final bool onlyVerified;

  final VoidCallback onChanged;
  final ValueChanged<String> onNiveauChanged;
  final ValueChanged<String> onMatiereChanged;
  final ValueChanged<String> onFormatChanged;
  final ValueChanged<bool> onOnlyVerifiedChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search
          TextField(
            controller: searchCtrl,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Rechercher un précepteur, matière, ville…',
              filled: true,
              fillColor: kLightColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),

          LayoutBuilder(builder: (context, c) {
            final wide = c.maxWidth > 720;

            final niveauItems = const ['Tous', 'Primaire', 'Secondaire', 'Humanités'];
            final formatItems = const ['Tous', 'Présentiel', 'En ligne'];
            final matiereItems = const [
              'Toutes',
              'Mathématiques',
              'Sciences',
              'Langues',
              'Méthodologie'
            ];

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _DropPill(
                  label: 'Niveau',
                  value: niveau,
                  items: niveauItems,
                  onChanged: onNiveauChanged,
                  width: wide ? 210 : null,
                ),
                _DropPill(
                  label: 'Format',
                  value: format,
                  items: formatItems,
                  onChanged: onFormatChanged,
                  width: wide ? 210 : null,
                ),
                _DropPill(
                  label: 'Matière',
                  value: matiere,
                  items: matiereItems,
                  onChanged: onMatiereChanged,
                  width: wide ? 240 : null,
                ),
                _TogglePill(
                  label: 'Vérifiés uniquement',
                  value: onlyVerified,
                  onChanged: onOnlyVerifiedChanged,
                ),
                const SizedBox(width: 2),
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    'Réinitialiser',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _BecomePrecepteurBanner extends StatelessWidget {
  const _BecomePrecepteurBanner({required this.radius, required this.onBecome});

  final double radius;
  final VoidCallback onBecome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: kDarkColor,
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 560;

        final text = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vous êtes précepteur ?',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Rejoignez SOMA et proposez vos cours (présentiel / en ligne).',
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.86),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );

        final btn = SizedBox(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: onBecome,
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
            label: Text(
              'Devenir précepteur',
              style: GoogleFonts.inter(fontWeight: FontWeight.w900),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: kAccentColor.withOpacity(0.95)),
                  const SizedBox(width: 8),
                  text,
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: btn),
            ],
          );
        }

        return Row(
          children: [
            Icon(Icons.star_rounded, color: kAccentColor.withOpacity(0.95)),
            const SizedBox(width: 10),
            text,
            const SizedBox(width: 12),
            btn,
          ],
        );
      }),
    );
  }
}

class _PrecepteurCard extends StatelessWidget {
  const _PrecepteurCard({required this.p, required this.radius, required this.onTap});

  final _Precepteur p;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = p.verified ? kSecondaryColor : kTextLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // cover image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: (p.avatarAsset != null)
                            ? Image.asset(
                                p.avatarAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _CoverFallback(name: p.name),
                              )
                            : _CoverFallback(name: p.name),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.02),
                                Colors.black.withOpacity(0.20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: _PillBadge(
                          icon: p.verified
                              ? Icons.verified_rounded
                              : Icons.info_outline_rounded,
                          label: p.verified ? 'Vérifié' : 'Profil',
                          color: badgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // content
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: kDarkColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: kTextLight,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 16, color: kTextLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              p.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: kTextLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 18, color: kAccentColor),
                          const SizedBox(width: 4),
                          Text(
                            p.rating.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              color: kDarkColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${p.reviews} avis)',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: kTextLight,
                              fontSize: 12.5,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded,
                              color: kTextLight),
                        ],
                      ),

                      const Spacer(),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final f in p.formats.take(2))
                            _ChipMini(
                                text: f,
                                color: kPrimaryColor.withOpacity(0.12)),
                          for (final l in p.levels.take(1))
                            _ChipMini(
                                text: l,
                                color: kSecondaryColor.withOpacity(0.12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.p, required this.radius});
  final _Precepteur p;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: (p.avatarAsset != null)
                ? Image.asset(
                    p.avatarAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _CoverFallback(name: p.name),
                  )
                : _CoverFallback(name: p.name),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (p.verified)
                      _PillBadge(
                        icon: Icons.verified_rounded,
                        label: 'Vérifié',
                        color: kSecondaryColor,
                      ),
                    _PillBadge(
                      icon: Icons.star_rounded,
                      label:
                          '${p.rating.toStringAsFixed(1)} • ${p.reviews} avis',
                      color: kAccentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpBanner extends StatelessWidget {
  const _HelpBanner({
    required this.radius,
    required this.onContact,
    required this.onBecome,
  });

  final double radius;
  final VoidCallback onContact;
  final VoidCallback onBecome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.10),
            kSecondaryColor.withOpacity(0.10),
          ],
        ),
        border: Border.all(color: kPrimaryColor.withOpacity(0.14)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 560;

        final leading = Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(Icons.support_agent_rounded, color: kPrimaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Vous ne trouvez pas le bon profil ? Écrivez-nous : on vous aide à choisir rapidement.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.45,
                  color: kTextDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: onBecome,
                icon: Icon(Icons.person_add_alt_1_rounded,
                    size: 18, color: kPrimaryColor),
                label: Text(
                  'Devenir précepteur',
                  style: GoogleFonts.inter(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryColor.withOpacity(0.45)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 44,
              child: CtaButton(
                label: 'Contact',
                onPressed: onContact,
              ),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leading,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: actions),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: leading),
            const SizedBox(width: 12),
            actions,
          ],
        );
      }),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      color: kPrimaryColor.withOpacity(0.12),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 46,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class _DropPill extends StatelessWidget {
  const _DropPill({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: kLightColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            borderRadius: BorderRadius.circular(14),
            icon: const Icon(Icons.expand_more_rounded),
            items: items
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        '$label : $e',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          color: kDarkColor,
                          fontSize: 13,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? kSecondaryColor.withOpacity(0.14) : kLightColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 18,
              color: value ? kSecondaryColor : kTextLight,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: kDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipMini extends StatelessWidget {
  const _ChipMini({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          color: kDarkColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.icon, required this.label, required this.active});
  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? kSecondaryColor.withOpacity(0.14) : kLightColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: active ? kSecondaryColor : kTextLight),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kPrimaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              height: 1.4,
              color: kTextDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
