import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../common/section_base.dart';
import '../common/hover_scale.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  static const teamMembers = [
    TeamMember('Allain ALI M.', 'Chief Executive Officer (CEO)',
        imagePath: 'assets/images/team/allain_ali.jpg'),
    TeamMember('Raphaël MWELA K.', 'Chief Operating Officer',
        imagePath: 'assets/images/team/raphael_mwela.jpg'),
    TeamMember('Sarah JESSICA', 'Chargée de Marketing',
        imagePath: 'assets/images/team/sarah_jessica.jpg'),
    TeamMember('Noëlla SIFA', 'Secrétaire',
        imagePath: 'assets/images/team/noella_sifa.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final radius = adaptiveRadius(context);

    return SectionBase(
      background: kLightColor,
      child: Column(
        children: [
          Text(
            'NOTRE ÉQUIPE',
            style: GoogleFonts.inter(
              color: kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Une équipe engagée pour votre réussite',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth;
            final crossCount = w > 900 ? 4 : (w > 600 ? 2 : 1);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: crossCount == 1 ? 1.2 : 0.75,
              ),
              itemCount: teamMembers.length,
              itemBuilder: (_, i) => HoverScale(
                child: TeamCard(member: teamMembers[i], radius: radius),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String? imagePath;
  const TeamMember(this.name, this.role, {this.imagePath});
}

class TeamCard extends StatelessWidget {
  final TeamMember member;
  final double radius;

  const TeamCard({super.key, required this.member, required this.radius});

  @override
  Widget build(BuildContext context) {
    final initials = member.name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // important pour clipper l’image
      child: Column(
        children: [
          // ✅ IMAGE FULL WIDTH (occupe toute la partie supérieure)
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: (member.imagePath != null)
                      ? Image.asset(
                          member.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _InitialsCover(initials: initials),
                        )
                      : _InitialsCover(initials: initials),
                ),

                // Optionnel: léger dégradé (utile si un jour tu mets du texte sur l'image)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ PARTIE BASSE (nom + rôle) — les noms restent bien affichés
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: kDarkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.role,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kTextLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Placeholder “cover” si image manquante
class _InitialsCover extends StatelessWidget {
  final String initials;
  const _InitialsCover({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor.withOpacity(0.12),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
