import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../common/section_base.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final small = isSmallScreen(context);
    final radius = adaptiveRadius(context);

    return SectionBase(
      background: kPrimaryColor,
      child: small
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CtaText(),
                const SizedBox(height: 24),
                _CtaVisual(radius: radius),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: _CtaText()),
                const SizedBox(width: 40),
                Expanded(child: _CtaVisual(radius: radius)),
              ],
            ),
    );
  }
}

class _CtaText extends StatelessWidget {
  const _CtaText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prêt à offrir un meilleur accompagnement scolaire à votre enfant ?',
            style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
        const SizedBox(height: 16),
        Text(
          'Avec SOMA, trouvez des précepteurs qualifiés, bénéficiez d\'un suivi structuré et accompagnez efficacement la réussite scolaire de vos enfants.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white.withOpacity(0.92), height: 1.7),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/nos-precepteurs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: kPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('Trouver un précepteur', style: GoogleFonts.inter(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

class _CtaVisual extends StatelessWidget {
  final double radius;
  const _CtaVisual({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white.withOpacity(0.12),
      ),
      child: Center(
        child: Image.asset(
          kLogoWhiteAsset,
          height: 140,
          errorBuilder: (_, __, ___) => const Icon(Icons.handshake, size: 90, color: Colors.white),
        ),
      ),
    );
  }
}
