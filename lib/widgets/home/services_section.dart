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

    final services = const [
      _HomeService('Pour les parents', 'Trouvez des précepteurs qualifiés pour accompagner vos enfants', Icons.family_restroom),
      _HomeService('Pour les précepteurs', 'Valorisez vos compétences et trouvez des élèves', Icons.school),
      _HomeService('Accompagnement scolaire', 'Soutien personnalisé pour la réussite des élèves', Icons.auto_stories),
    ];

    return SectionBase(
      background: kLightColor,
      child: Column(
        children: [
          Text('NOS SERVICES',
              style: GoogleFonts.inter(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 16),
          Text('Solutions éducatives complètes',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w900, color: kDarkColor, height: 1.2)),
          const SizedBox(height: 20),
          Text('Découvrez notre gamme de services conçus pour accompagner la réussite scolaire',
              textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 17, color: kTextLight, height: 1.7)),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final crossCount = w > 900 ? 3 : (w > 600 ? 2 : 1);

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: crossCount == 1 ? 1.35 : 0.95,
                ),
                itemCount: services.length,
                itemBuilder: (_, i) => HoverScale(
                  onTap: () => Navigator.pushNamed(context, '/services'),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 16),
                          Text(services[i].title,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: kDarkColor)),
                          const SizedBox(height: 10),
                          Text(services[i].description, style: GoogleFonts.inter(fontSize: 14, color: kTextLight, height: 1.6)),
                          const Spacer(),
                          Row(
                            children: [
                              Text('En savoir plus', style: GoogleFonts.inter(color: kSecondaryColor, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16, color: kSecondaryColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/services'),
            style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor, foregroundColor: Colors.white),
            child: const Text('Découvrir tous nos services'),
          ),
        ],
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
