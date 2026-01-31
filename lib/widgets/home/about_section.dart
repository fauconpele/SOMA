import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../common/section_base.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final small = isSmallScreen(context);
    final radius = adaptiveRadius(context);

    return SectionBase(
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('À PROPOS DE SOMA',
              style: GoogleFonts.inter(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text('SOMA au service de la réussite scolaire',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w900, color: kDarkColor, height: 1.2)),
          const SizedBox(height: 20),
          Text(
            'SOMA est né d\'un constat simple : les parents ont besoin d\'un accompagnement scolaire fiable, et les précepteurs compétents manquent de visibilité.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 17, color: kTextLight, height: 1.7),
          ),
          const SizedBox(height: 48),
          small
              ? Column(
                  children: [
                    _AboutVisual(radius: radius),
                    const SizedBox(height: 24),
                    const _AboutText(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _AboutVisual(radius: radius)),
                    const SizedBox(width: 48),
                    const Expanded(child: _AboutText()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _AboutVisual extends StatelessWidget {
  final double radius;
  const _AboutVisual({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: kPrimaryColor.withOpacity(0.10),
      ),
      child: Center(
        child: Image.asset(
          kLogoAsset,
          height: 150,
          errorBuilder: (_, __, ___) => Icon(Icons.school, size: 110, color: kPrimaryColor),
        ),
      ),
    );
  }
}

class _AboutText extends StatelessWidget {
  const _AboutText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notre mission', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w800, color: kDarkColor)),
        const SizedBox(height: 18),
        Text(
          'Nous avons créé une plateforme qui met en relation les familles et des précepteurs qualifiés, dans un cadre structuré, sécurisé et orienté résultats.',
          style: GoogleFonts.inter(fontSize: 16, color: kTextLight, height: 1.7),
        ),
        const SizedBox(height: 26),
        const _FeatureList(
          features: [
            'Précepteurs sélectionnés et évalués',
            'Accompagnement scolaire personnalisé',
            'Suivi de la progression des élèves',
            'Plateforme simple, transparente et fiable',
          ],
        ),
      ],
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<String> features;
  const _FeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: kSecondaryColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(f, style: GoogleFonts.inter(fontSize: 15, color: kDarkColor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
