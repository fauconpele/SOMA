import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../common/section_base.dart';

class WhySection extends StatelessWidget {
  const WhySection({super.key});

  @override
  Widget build(BuildContext context) {
    final small = isSmallScreen(context);
    final radius = adaptiveRadius(context);

    return SectionBase(
      background: Colors.white,
      child: Column(
        children: [
          Text('POURQUOI SOMA',
              style: GoogleFonts.inter(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text('Pourquoi choisir SOMA pour l\'accompagnement scolaire',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w900, color: kDarkColor, height: 1.2)),
          const SizedBox(height: 40),
          small
              ? Column(
                  children: [
                    const _WhyText(),
                    const SizedBox(height: 24),
                    _WhyVisual(radius: radius),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(child: _WhyText()),
                    const SizedBox(width: 40),
                    Expanded(child: _WhyVisual(radius: radius)),
                  ],
                ),
        ],
      ),
    );
  }
}

class _WhyText extends StatelessWidget {
  const _WhyText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Des précepteurs sélectionnés avec rigueur',
            style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: kDarkColor)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            TagChip(label: 'Compétence'),
            TagChip(label: 'Expérience'),
            TagChip(label: 'Pédagogie'),
            TagChip(label: 'Fiabilité'),
            TagChip(label: 'Engagement'),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'SOMA sélectionne des précepteurs qualifiés et engagés afin de garantir un accompagnement scolaire sérieux, adapté au niveau de chaque élève et orienté vers des résultats concrets.',
          style: GoogleFonts.inter(fontSize: 16, color: kTextLight, height: 1.7),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/services'),
          style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor, foregroundColor: Colors.white),
          child: const Text('Découvrir les services'),
        ),
      ],
    );
  }
}

class _WhyVisual extends StatelessWidget {
  final double radius;
  const _WhyVisual({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: kSecondaryColor.withOpacity(0.10),
      ),
      child: Center(
        child: Image.asset(
          kLogoAsset,
          height: 150,
          errorBuilder: (_, __, ___) => const Icon(Icons.groups, size: 110, color: kSecondaryColor),
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: kPrimaryColor.withOpacity(0.30)),
      ),
      child: Text(label, style: GoogleFonts.inter(color: kPrimaryColor, fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }
}
