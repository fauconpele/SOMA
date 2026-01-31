import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/common/simple_page_scaffold.dart';
import '../widgets/common/scroll_to_top_bottom.dart';
import '../core/constants.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _sc = ScrollController();

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      title: 'À propos',
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _sc,
            padding: const EdgeInsets.only(bottom: 110),
            child: _AboutContent(
              onGoContact: () => Navigator.pushNamed(context, '/contact'),
            ),
          ),
          ScrollToTopBottom(controller: _sc),
        ],
      ),
    );
  }
}

// =================== CONTENU "À PROPOS" ===================
class _AboutContent extends StatelessWidget {
  final VoidCallback onGoContact;
  const _AboutContent({required this.onGoContact});

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderBlock(
          eyebrow: 'À PROPOS DE SOMA',
          title: 'Notre histoire, notre vision et notre mission',
          subtitle:
              'SOMA est une plateforme éducative en RDC qui met en relation les familles et des précepteurs qualifiés pour un accompagnement scolaire fiable, structuré et orienté résultats.',
        ),
        const SizedBox(height: 18),

        // ✅ NOUVEAU : Bouton vers Contact (bien visible)
        _ContactCtaRow(onGoContact: onGoContact),
        const SizedBox(height: 18),

        _InfoCard(
          icon: Icons.lightbulb_outline,
          title: 'Naissance d’une conviction',
          child: Text(
            'SOMA est née d’une conviction simple : la réussite n’est jamais le fruit du hasard. '
            'Elle se construit grâce à un accompagnement juste, humain et exigeant.\n\n'
            'Dans un contexte où l’enseignement de masse laisse trop souvent les apprenants livrés à eux-mêmes '
            '(classes surchargées, manque de suivi, difficulté à trouver un encadrement sérieux), SOMA propose '
            'une alternative centrée sur la qualité du suivi.',
            style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
          ),
        ),
        const SizedBox(height: 18),

        _InfoCard(
          icon: Icons.location_on_outlined,
          title: 'Notre implantation',
          child: Text(
            'SOMA est implantée à Kinshasa (RDC) et s’inscrit comme un espace de proximité, accessible et '
            'profondément ancré dans son environnement.\n\n'
            'Un lieu pensé pour apprendre, progresser et construire l’avenir dans un cadre sérieux, structuré '
            'et propice à la concentration.',
            style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
          ),
        ),
        const SizedBox(height: 18),

        _InfoCard(
          icon: Icons.groups_outlined,
          title: 'Le préceptorat : notre choix fort',
          accent: kPrimaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dès ses débuts, SOMA place le préceptorat au cœur de son identité : un accompagnement individualisé, '
                'rigoureux et profondément humain.',
                style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
              ),
              const SizedBox(height: 12),
              _BulletList(items: const [
                'Suivi personnalisé selon le niveau et le rythme',
                'Ciblage des difficultés réelles',
                'Objectifs clairs et progression mesurable',
                'Cadre sérieux et méthode structurée',
              ]),
              const SizedBox(height: 12),
              Text(
                'Les séances se déroulent principalement en présentiel pour favoriser l’interaction directe. '
                'Lorsque nécessaire, certaines séances peuvent être proposées en ligne sans compromettre l’exigence pédagogique.',
                style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        _InfoCard(
          icon: Icons.engineering_outlined,
          title: 'Au-delà du préceptorat',
          accent: kSecondaryColor,
          child: Text(
            'SOMA développe aussi des formations professionnelles pratiques, exigeantes et orientées employabilité.\n\n'
            'Exemples : Conception Assistée par Ordinateur (AutoCAD / SOLIDWORKS) et Systèmes d’Information Géographique (ArcGIS).',
            style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
          ),
        ),
        const SizedBox(height: 18),

        _BigIdentityCard(isSmall: isSmall),
        const SizedBox(height: 18),

        _InfoCard(
          icon: Icons.visibility_outlined,
          title: 'Notre vision à long terme',
          accent: kAccentColor,
          child: Text(
            'Former des esprits compétents, autonomes et confiants, capables de relever les défis académiques '
            'et professionnels de leur génération.\n\n'
            'Une vision portée par l’exigence, la proximité et la foi profonde dans le potentiel humain.',
            style: GoogleFonts.inter(fontSize: 16, height: 1.7, color: kTextDark),
          ),
        ),
        const SizedBox(height: 22),

        _CtaBox(onGoContact: onGoContact),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ✅ CTA principal vers Contact
class _ContactCtaRow extends StatelessWidget {
  final VoidCallback onGoContact;
  const _ContactCtaRow({required this.onGoContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kDarkColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.mail_outline, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Besoin d’informations ou d’un accompagnement ?',
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.4,
                color: Colors.white.withOpacity(0.92),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onGoContact,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kSecondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }
}

// =================== UI BLOCKS ===================

class _HeaderBlock extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _HeaderBlock({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.7,
              color: kTextLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Color? accent;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final c = accent ?? kPrimaryColor;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: c),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: kDarkColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: kSecondaryColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.5,
                        color: kTextDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BigIdentityCard extends StatelessWidget {
  final bool isSmall;
  const _BigIdentityCard({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 10),
            color: kPrimaryColor.withOpacity(0.25),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notre identité',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'SOMA n’est pas simplement un centre de formation. C’est un partenaire de réussite : '
                  'un espace où l’on reprend confiance, où l’on apprend à apprendre, et où l’on construit '
                  'des compétences solides et durables.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.7,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Discipline • Excellence • Accompagnement humain',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaBox extends StatelessWidget {
  final VoidCallback onGoContact;
  const _CtaBox({required this.onGoContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.10),
            kSecondaryColor.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.support_agent, color: kPrimaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Prêt à nous rejoindre ? Contactez-nous pour en savoir plus sur nos services et le préceptorat SOMA.',
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.6,
                color: kTextDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onGoContact,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Nous contacter'),
          ),
        ],
      ),
    );
  }
}
