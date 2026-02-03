import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../common/section_base.dart';
import '../common/hover_scale.dart';

class ServicesHomeSection extends StatelessWidget {
  const ServicesHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = adaptiveRadius(context);

    const services = [
      _HomeService(
        'Pour les parents',
        'Trouvez des précepteurs qualifiés pour accompagner vos enfants.',
        Icons.family_restroom,
      ),
      _HomeService(
        'Pour les précepteurs',
        'Valorisez vos compétences et trouvez des élèves facilement.',
        Icons.school,
      ),
      _HomeService(
        'Accompagnement scolaire',
        'Soutien personnalisé pour la réussite et la progression.',
        Icons.auto_stories,
      ),
    ];

    return SectionBase(
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
          const SizedBox(height: 16),
          Text(
            'Solutions éducatives complètes',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isSmallScreen(context) ? 26 : 34,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Découvrez notre gamme de services conçus pour accompagner la réussite scolaire.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: kTextLight,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),

          // ✅ MOBILE : colonne (hauteur libre => pas d’overflow)
          // ✅ TABLET/DESKTOP : grille
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final crossCount = w > 900 ? 3 : (w > 620 ? 2 : 1);

              if (crossCount == 1) {
                return Column(
                  children: List.generate(services.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _ServiceCard(
                        radius: radius,
                        data: services[i],
                        onTap: () => Navigator.pushNamed(context, '/services'),
                      ),
                    );
                  }),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (_, i) => _ServiceCard(
                  radius: radius,
                  data: services[i],
                  onTap: () => Navigator.pushNamed(context, '/services'),
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Découvrir tous nos services',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.radius,
    required this.data,
    required this.onTap,
  });

  final double radius;
  final _HomeService data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverScale(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ permet de grandir si besoin
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: kPrimaryColor, size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                data.title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kDarkColor,
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Texte flexible : pas de Spacer, pas d’overflow
              Text(
                data.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: kTextLight,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 14),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'En savoir plus',
                    style: GoogleFonts.inter(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16, color: kSecondaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeService {
  final String title;
  final String description;
  final IconData icon;
  const _HomeService(this.title, this.description, this.icon);
}
